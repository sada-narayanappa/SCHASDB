FILE="worldcitiespop.csv"

if [[ ! -e "$FILE" ]]; then
	echo "File does not exist .. I will download it"
	echo "RUN THE FOLLOWING COMMANDS"
	echo ""
	echo "**** RUN ****"
	echo""
	echo "wget http://www.maxmind.com/download/worldcities/worldcitiespop.txt.gz"
	echo "gunzip worldcitiespop.txt.gz"
	echo "mv worldcitiespop.txt worldcitiespop.csv"
	echo ""
	echo "make sure NOT TO check worldcitiespop.txt.gz to git"
	exit
else
	echo "file $FILE ...exists"
fi

cp worldcitiespop.csv  /tmp/worldcitiespop1.csv  
perl -pi -e 's/[[:^ascii:]]//g' /tmp/worldcitiespop1.csv  

PSQL='psql -h localhost -U postgres -d SCHASDB' 

$PSQL -f wp1.sql

