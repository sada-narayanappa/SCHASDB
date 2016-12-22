import collections
import paho.mqtt.client as mqtt
import json
import psycopg2

#===============================================================================
# The callback for when the client successfully connects to the broker
def on_connect(client, userdata, rc):
    ''' We subscribe on_connect() so that if we lose the connection
        and reconnect, subscriptions will be renewed. '''

    client.subscribe("owntracks/+/+")
#===============================================================================
defConnection= '''
dbname  = 'SCHASDB'
user    = 'postgres'
host    = 'localhost'
password= ''
port    = 5433
'''
connection=psycopg2.connect(defConnection);
connection.autocommit = True

SQL1= '''
INSERT INTO ownt(id, lat, lon, acc, battery, tid, measured_at, notes, the_geom)
VALUES (
'$id', $lat, $lon, $acc, $batt, '$tid', to_timestamp($tst) at time zone 'utc', '$notes',
ST_GeomFromText('POINT(' || $lon || ' ' || $lat || ')',4326)
)
'''
SQL2='''
INSERT INTO loc (
    mobile_id, lat, lon, speed, accuracy, session_num, user_id, measured_at,  api_key, the_geom
)
VALUES (
    '$id', $lat, $lon, 20, $acc, '1', '$id', to_timestamp($tst) at time zone 'utc', 'api_key',
    ST_GeomFromText('POINT(' || $lon || ' ' || $lat || ')',4326)
)
'''

sql3='''INSERT INTO loc (mobile_id, lat, lon, accuracy, session_num, user_id, measured_at, stored_at, api_key, the_geom)
select 'ownt', lat, lon, acc, '1', id, measured_at, stored_at, 'api_key', the_geom FROM ownt'''

#Process JSON data
def process(topic, data, notes):
    t = data['_type']
    if ( t != "location"):
        return;
    id = topic.split("/")[-1]
    id= "ownt - " + id;
    #if (not id.startswith('79f') ):
	#    mid = "ownt - ";

    s = SQL2;

    d = collections.OrderedDict(sorted(data.items(), reverse = True))
    for t in d:
        print(t, end=" ");
        s = s.replace("$"+t, (str(d[t])) )

    s = s.replace("$id", format(id));
    #s = s.replace("$notes", format(notes));

    print (s)
    cur = connection.cursor()
    cur.execute(s)

#===============================================================================
# The callback for when a PUBLISH message is received from the broker
def on_message(client, userdata, msg):
    if (msg.retain > 0):
        print ("Retained Message:")
        return;

    topic = msg.topic

    try:
        s = str(msg.payload.decode('utf-8'))
        data = json.loads(s)
        print(topic, s)
        process(topic, data, s);
        #print ("TID = {0}  {1}, {2}".format(data['tid'], data['lat'], data['lon']))
    except ValueError as err:
        print ("ERROR: Cannot decode data on topic {} {}\n\n\n".format(topic,s ))
        print(err)
        quit();

#===============================================================================
client = mqtt.Client(client_id="SCHAS1", clean_session=False)
#client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.username_pw_set("owntracks", "a");
client.connect("www.geospaces.org", 8883, 60)

# Blocking call which processes all network traffic and dispatches
# callbacks (see on_*() above). It also handles reconnecting.
client.loop_forever()

