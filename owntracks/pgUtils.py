import psycopg2
from collections import defaultdict
#===============================================================================
defConnection= '''
dbname  = 'SCHASDB'
user    = 'postgres'
host    = 'localhost'
password= ''
port    = 5433
'''
#===============================================================================
def connect(connectionInformation= defConnection):
    connection = None;
    try:
        connection=psycopg2.connect(connectionInformation)
    except:
        print ("Cannot connect to the database.")

    return connection
#===============================================================================

#===============================================================================
def getType(num):
    types = { 23: int, 21: str, 1043: str, 16: bool, 701: float }
    
    if ( num in types ):
    	return types[num];
    else:
        return None
        
def ColumnFormat(row, typeS, typeM):
    rf = [];
    for i,rv in enumerate(row):
        if (rv is None or not rv):
            rf.append("null");
            continue;
        
        if ( getType(typeM[i]) == str):
           r = u' '.join((rv,));
           r1 = r.replace('\'', '\'\'')
           if (rv):
               rf.append("'" + r1 + "'");
        else:
        	rf.append(str(rv))
        	
        #print( typeS[i], typeM[i]);
        continue;
    return rf;

#===============================================================================
# This is bit of fancy SQL for testing and such.
# If you want to run the query or update faster without bells and whistles
# just run it yourself as it is super fast:
#
# cur = con.cursor(); cur.execute(q); rows  = cur.fetchall();
#
def runSQL(con, q= "SELECT datname from pg_database order by datname", output=False, title= None):
    cur = con.cursor()
    cur.execute(q)

    if ( cur.description == None):
        return None, None, None, None

    rows  = cur.fetchall();
    cols  = [cn[0] for cn in cur.description]
    typeM = [cn[1] for cn in cur.description]
    typeS = [typeInfoDict[cn[1]] + "(" + str(cn[1]) + ")" for cn in cur.description]

    if ( output):
        if (title):
            print ("==> %s\n", (title))
        fmt = (",%s"*len(cols))[1:]
        print ("--Names: " + fmt % tuple(cols))
        print ("--Types: " + fmt % tuple(typeS))
        #print ("--Types: " + fmt % tuple(typeM))
        print ("\n")

        for row in  rows:
            nrow = ColumnFormat(row, typeS, typeM)
            print (fmt % tuple(nrow))

    return cols, typeM, rows, typeS
#===============================================================================
def genSQL(connection, tableName, limit = 10):
    q = "select * from " + tableName + " limit 1";
    (cols, t2, r2, typeS2) = runSQL(connection,q=q, output=False);
    scols = ""
    for i,t in enumerate(typeS2):
        if (t.startswith("geography") or t.startswith("geometry")):
            scols = scols + ", ST_asText(" + cols[i] + ")"
        else:
            scols = scols + ", " + cols[i]
    q = "SELECT " + scols[1:] + " FROM " + tableName;
    q = q + " LIMIT " + str(limit) if limit > 0 else "";
    return q;


#===============================================================================
# Simple function to get the table info
#
def table(connection, tableName, hasGeom=False, output=True, limit=10):
    q = "select * from " + tableName + " limit " + str(limit);
    if ( hasGeom ):
    	q = genSQL(connection, tableName, limit);
    (c2, t2, r2, typeS2) = runSQL(connection,q=q, output=output);

    if ( output) :
        print ("\n--Query: " + q, "\nNumber of Rows: " , len(r2));

    return (q, c2,t2,r2, typeS2)
#===============================================================================
# Documentation and example use below
#
#
#===============================================================================
def Test():
	con1= '''
dbname  = 'SCHASDB'
user    = 'postgres'
host    = 'localhost'
password= ''
port    = 5433
'''
    # First  example:
	connection = None;
	connection = connect(con1)
	table(connection, tableName, True, 5)
	
	
	
if __name__ == "__main__":
	print ("Load and run Test() to Test some functions");
	
	
#-============================================================================
#FAQ
'''
run:
[ ] unset LC_ALL
If you get errors:
UnicodeEncodeError: 'ascii' codec can't encode character '\u2122' in position

'''