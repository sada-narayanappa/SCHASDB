#------------------------------------------------------------------------
# RUN as
# [ ] test.sh 
#------------------------------------------------------------------------
export DBNAME=SCHASDB
export AUTH='-h localhost -U postgres '
export PSQL="psql $AUTH -d $DBNAME"

function checkVersion {
	${PSQL} -c "SELECT postgis_full_version();"
	if [ $? != 0 ]; then
		echo "error ..."
		exit;
	fi
}

function createtestTable {
	$PSQL -c "drop table test;"
	$PSQL  <<EOF
	create table test (
			 name	 varchar,
			 value varchar,
			 valid boolean,
			 num1	 int,
			 num2	 float8,
			 num3	 float8
	);
EOF
	$PSQL  -c "insert into test values ('name1' , 'value', true, 0,0,0);"
	$PSQL  -c 'SELECT * from test'
}

echo "**** $PSQL"

checkVersion
createtestTable