export LATEST=SCHASDB.gz
export BACKUPFILE=SCHASDB-`date +%Y-%m-%d_%H-%M-%S`.gz
echo "Backing up to " $BACKUPFILE
#pg_dump -h geospaces.org -U postgres SCHASDB | gzip > $BACKUPFILE
pg_dump -h 127.0.0.1  -U postgres SCHASDB | gzip > $BACKUPFILE
rm -i $LATEST
ln -s $BACKUPFILE $LATEST

