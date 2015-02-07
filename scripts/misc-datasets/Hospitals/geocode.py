#!/usr/local/bin/python
import glob, csv, os
import urllib2
import json
from time import sleep
import time

samjson="""
{
   "results" : [
      {
         "formatted_address" : "6975 East Mountain Brush Circle, Littleton, CO 80130, USA",
         "geometry" : {
            "location" : {
               "lat" : 39.550294,
               "lng" : -104.90666
            },
            "location_type" : "ROOFTOP",
            "viewport" : {
               "northeast" : {
                  "lat" : 39.5516429802915,
                  "lng" : -104.9053110197085
               },
               "southwest" : {
                  "lat" : 39.5489450197085,
                  "lng" : -104.9080089802915
               }
            }
         },
         "types" : [ "street_address" ]
      }
   ],
   "status" : "OK"
}
"""
def geocode(address="80130"):
    #address="1600+Amphitheatre+Parkway,+Mountain+View,+CA"
    url="http://maps.googleapis.com/maps/api/geocode/json?address=%s&sensor=false" % address
    response = urllib2.urlopen(url)
    jsongeocode = response.read()
    return jsongeocode;

def getlatlon(jsonstr=samjson):
    try:
        data = json.loads(jsonstr);
        lat = data['results'][0]['geometry']['location']['lat'];
        lng = data['results'][0]['geometry']['location']['lng'];
        return (lat,lng);
    except:
        print "Error decoding ", jsonstr;
    return (0,0)

def geocodeFile(filename = "Hospital_Data.csv"):
    lines = csv.reader(open(filename, 'rb'), delimiter=',')
    i = 0;
    for rowx, row in enumerate(lines):
        if rowx == 0:
            continue;
        a = row[2] + "+" +row[5]+ "+" +row[6]+ "+" +row[7];
        a=a.replace(" ", "+");
        #print "Geo coding : ", a;
        sa = geocode(a);
        lat, lng = getlatlon(sa);
        #lat, lng = getlatlon();
        row = [t.replace(',', ' ').replace("'", ' ')  for t in row]
        row[-1] = 'Y' if row[-1].startswith("Y") else 'N';
        l =  str(row)[1:-1];
        print  '%s,%s,%s'%(l, lat, lng)
        sleep(5)
        if (rowx > 200000):
           break;

if __name__ == "__main__":
    geocodeFile()
    getlatlon();
