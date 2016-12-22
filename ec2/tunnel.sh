#Use the following to put it in background
#ssh -i "schas.pem" -f -N -L 5400:localhost:5432 centos@35.160.151.26
ssh -i "schas.pem"  -N -L 5400:localhost:5432 centos@35.160.151.26
