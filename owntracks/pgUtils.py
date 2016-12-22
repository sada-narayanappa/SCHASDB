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
typeinfoSQL='''
SELECT  distinct f.atttypid,
        pg_catalog.format_type(f.atttypid, f.atttypmod) AS type
FROM pg_attribute f
ORDER BY type;
''';
typeInfoDict={};
def getTypeNames(con):
    cur = con.cursor()
    cur.execute(typeinfoSQL)
    rows = cur.fetchall();
    for row in  rows:
        typeInfoDict[row[0]] =  row[1];
    #print typeInfoDict;
    return typeInfoDict;
#===============================================================================
def connect(connectionInformation= defConnection):
    connection = None;
    try:
        connection=psycopg2.connect(connectionInformation)
    except:
        print ("Cannot connect to the database.")

    return connection
#===============================================================================
def getType(num):
    types = { 23: int, 21: str, 1043: str, 16: bool, 701: float }
    
    if ( num in types ):
    	return types[num];
    else:
        return None
        
def ColumnFormat(row, typeM):
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
def runSQL(con, q= "SELECT datname from pg_database", output=False, title= "", returnTypeInfo = False,
           fetchSize = 100000):
    cur = con.cursor()
    cur.execute(q)
    rowCount = cur.rowcount;

    if ( cur.description == None):
        return None, None, rowCount, None, None

    rows  = cur.fetchmany(fetchSize);
    rowCount = cur.rowcount;

    cols  = [cn[0] for cn in cur.description]
    typeI = [] #
    typeS = [] # Typenames in Strings

    if (returnTypeInfo):
        if (len(typeInfoDict) <= 0 ):
            getTypeNames(con);
        typeS = [typeInfoDict[cn[1]] + "(" + str(cn[1]) + ")" for cn in cur.description]
        typeI =[cn[1] for cn in cur.description]

    if ( output):
        print (title, end='')
        fmt = (",%s"*len(cols))[1:]
        print ("--Names: " + fmt % tuple(cols))
        print ("--Types: " + fmt % tuple(typeS))
        #print ("--Types: " + fmt % tuple(typeM))
        print ("\n")

        for row in  rows:
            nrow = ColumnFormat(row, typeI)
            print (fmt % tuple(nrow))

    return cols, rows, rowCount, typeI, typeS

def Json(cols, rows, rowCount, typeI, typeS, fmt="html", hasUtf8=False):
    json = "";

    return json;
#===============================================================================
# Documentation and example use below
# SOme utility functions are below - but mostly you won't need them
#
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
	table(connection, "<<tableName>>", True, 5)
	
	
	
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