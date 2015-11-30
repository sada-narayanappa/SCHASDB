export LATEST=SCHASDB.gz
export BACKUPFILE=SCHASDB-`date +%Y-%m-%d_%H-%M-%S`.gz
echo "Backing up to " $BACKUPFILE
rm -i $LATEST
pg_dump -h geospaces.org -U postgres SCHASDB | gzip > $BACKUPFILE
cp $BACKUPFILE $LATEST

