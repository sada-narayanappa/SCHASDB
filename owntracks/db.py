import sqlalchemy
from sqlalchemy import *
from geoalchemy2 import Geometry, Geography
from collections import namedtuple

#from sqlalchemy import Table, Column, Integer, String, ForeignKey
#from flask import request

e = create_engine('postgresql+psycopg2://postgres:postgres@localhost:5433/SCHASDB',client_encoding='utf8')
con = e.connect()

def saveMetaData():
    meta = sqlalchemy.MetaData(bind=con, reflect=True)
    for table in meta.tables:
        print (table);

#def execute(q="SELECT datname from pg_database order by datname"):
def execute(q="SELECT * from ownt LIMIT 10"):
    result = e.execute(q)

    Record = namedtuple('Record', result.keys())

    print (result.keys())
    print (Record)
#    records = [Record(*r) for r in result.fetchall()]
    records = result.fetchall()
    for k in records:
        print (k)

execute()