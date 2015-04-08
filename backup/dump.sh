export BACKUPFILE=SCHASDB-`date +%Y-%m-%d_%H-%M-%S`.gz
echo "Backing up to " $BACKUPFILE
pg_dump -h geospaces.org -U postgres SCHASDB | gzip > $BACKUPFILE


