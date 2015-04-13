SCHASDB
=======
Contains the DB scripts for SCHAS project. Should contains the create script for the db

To start postgress 

To open port 80
===============
sudo service iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
sudo service iptables save
sudo service iptables restart 

sudo apachectl start 

sudo service postgresql-9.4 start

