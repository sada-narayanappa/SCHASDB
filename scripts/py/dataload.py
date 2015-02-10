import time
import json

def loadLOC():
    f ="/opt/SCHAS/data/LOC.txt"
    with open(f) as f:
        content = f.readlines()
    f.close()
    cs = ['api_key','measured_at', 'lon','lat','bearing','alt','speed','mobile_id','accuracy'];
    print ",".join(cs);
    for l in content:
        l = l.strip();
        o = json.loads(l)
        t =  o['time']
        t = int(t)/1000;
        o['api_key'] = "BULK LOADED";
        o['measured_at'] = time.strftime("%Y-%m-%d %H:%M:%S",  time.gmtime(o['unix_time']))
        o['mobile_id'] = o['id']
        n = [ o[k] for k in cs];
        l1 = map(str, n)
        print ",".join(l1);

loadLOC();

d='{ "unix_time": 1423174829, "datetime": "2015/02/05 22:20:29","id": "a5c611cf9c7c24cf" ,"lat": "39.51984501824363" ,"lon": "-104.93792518811892" ,"time": "1423013025538" ,"bearing": "0.0" ,"alt": "1825.0" ,"accuracy": "10.0" ,"speed": "0.0" }'
o = json.loads(d)

print o
t = o['time']
t = int(t)/1000;
t = str(t);
l = [o['unix_time'], o['lon'], t, o['lat'], o['bearing'], o['alt'], o['speed'], o['id'],o['accuracy'] ]
l1 = map(str, l)
print ",".join(l1)
