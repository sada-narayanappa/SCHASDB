import getopt;
import sys
from pgUtils import *;
#===============================================================================
con1= '''
dbname  = 'SCHASDB'
user    = 'postgres'
host    = 'localhost'
password= ''
port    = 5433
'''
connection = None;
#==========================================================================MAIN

if __name__ == "__main__":
    if (len(sys.argv) < 2):
        print ("Error - no table name given");
        exit();

    tableName = sys.argv[1]
    connection = connect(con1)
    table(connection, tableName, False, True, 5)