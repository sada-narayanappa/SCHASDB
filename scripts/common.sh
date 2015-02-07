################################################################
# 
# commong path generation for raw Hadoop paths.  
#
# Example:  generatePaths /raw/player/columbus 2012/01/14,2012/01/15 produces:
#
################################################################
function generatePaths
{
  local dates="$2"
  local files=""
  local rawPath="$1"
  arr=$(echo $dates | tr "," "\n")
  for x in $arr
  do
    p="$rawPath$x/*.lzo"
    if [ -z "$files" ]; then
      files="$p"
    else
      files="$files,$p"
     fi
  done
  echo $files
}

# Internal function to replace a template date (identified with the string 
# "[DATE]") with an actual date
# Params: 
# 	1 - template
#	2 - actual date
#
# Example:
# bidule=`_replaceDateInPath "/gab/[DATE]/*.lzo" "2012/01/01"`
# echo "bidule = $bidule"
function _replaceDateInPath
{
	local template=$1;
	local day=$2;
	local awkCall='{sub(/\[DATE\]/, "'$day'", $0); print}'
	#echo "awkCall = $awkCall"
	echo "$template" | awk "$awkCall"
}

################################################################
#
# Generates a path for log files around the specified date
# Params:
# 	1 - The template directory in which we replace [DATE] by 
#	the appropriate values.
#	2 - The target date, using format YYYY/MM/DD
#	3/4 - (Optional) The number of days before or after to 
#	include (use negative for days before)
#
# Example: 
# generatePathsAround "/test/me-gab/[DATE]/access1*.lzo" "2012/02/02" 5
# generatePathsAround "/test/me-gab/[DATE]/access2*.lzo" "2012/02/02" 0
# generatePathsAround "/test/me-gab/[DATE]/access3*.lzo" "2012/02/02" -5 5
# generatePathsAround "/test/me-gab/[DATE]/access4*.lzo" "2012/02/02" 5 -5
# generatePathsAround "/test/me-gab/[DATE]/access5*.lzo" "2012/02/02" -2 -2
# generatePathsAround "/test/me-gab/[DATE]/access6*.lzo" "2012/02/02" 2 2
# generatePathsAround "/test/me-gab/[DATE]/access7*.lzo" "2012/02/02"
#
#################################################################
function generatePathsAroundOld
{
	local rawPath="$1"
	local reportDay="$2"
	local daysBack=0
	local daysAhead=0
	# The result - always add target day
	filePaths=`_replaceDateInPath "$rawPath" "$reportDay"`
	if [ -n "$3" ]
	then
		if [ $3 -gt 0 ]
		then 
			daysAhead=$3
		fi
		if [ $3 -lt 0 ]
		then 
			daysBack=$3
		fi
		if [ -n "$4" ] 
		then
			if [ $4 -gt 0 ]
			then 
				daysAhead=$4
			fi
			if [ $4 -lt 0 ]
			then 
				daysBack=$4
			fi
		fi
	fi
#	echo "daysBack=$daysBack ; daysAhead=$daysAhead"
	for(( i=-1; i>=$daysBack; i-- ))
	do  
		filePaths="$filePaths,"`_replaceDateInPath "$rawPath" "$(date -d "$reportDay $i days" "+%Y/%m/%d")"`
	done
	for(( i=1; i<=$daysAhead; i++ ))
	do  
		filePaths="$filePaths,"`_replaceDateInPath "$rawPath" "$(date -d "$reportDay $i days" "+%Y/%m/%d")"`
	done
	echo $filePaths
}

function generatePathsAround
{
	local rawPath="$1"
	local reportDay="$2"
	local daysBack=0
	local daysAhead=0
	# The result - always add target day
	filePaths=`_replaceDateInPath "$rawPath" "$reportDay"`
	if [ -n "$3" ]
	then
		if [ $3 -gt 0 ]
		then 
			daysAhead=$3
		fi
		if [ $3 -lt 0 ]
		then 
			daysBack=$3
		fi
		if [ -n "$4" ] 
		then
			if [ $4 -gt 0 ]
			then 
				daysAhead=$4
			fi
			if [ $4 -lt 0 ]
			then 
				daysBack=$4
			fi
		fi
	fi
#	echo "daysBack=$daysBack ; daysAhead=$daysAhead"
	for(( i=-1; i>=$daysBack; i-- ))
	do  
		 P=`adddays $reportDay $i`
		 NP=`_replaceDateInPath "$rawPath" $P`
		 PE=`hadoopPathExists "$NP"`
		 if [ "$PE" == "" ]
		 then
			  filePaths="$filePaths,"$NP
		 fi
	done
	for(( i=1; i<=$daysAhead; i++ ))
	do  
		 P=`adddays $reportDay $i`
		 NP=`_replaceDateInPath "$rawPath" $P`
		 PE=`hadoopPathExists "$NP"`
		 if [ "$PE" == "" ]
		 then
			  filePaths="$filePaths,"$NP
		 fi
	done
	echo $filePaths
}

#
# This function is deprecated - use generatePathAround instead
#
################################################################
#
# Generates a path for logs file going back N days
#
# Example: generatePathsLast /raw/player/columbus/ 90
#
################################################################
function generatePathsLast
{
	local rawPath="$1"
	local daysBack="$2"
	local lastDay="$3"
	local filePaths=""
	for(( c=0; c<$daysBack; c++ ))
	do  
		if [ $c -eq 0 ]; then
			filePaths="$rawPath"$(date -d "$lastDay -$c days" "+%Y/%m/%d")"/*.lzo"
		else
			filePaths="$filePaths,$rawPath"$(date -d "$lastDay -$c days" "+%Y/%m/%d")"/*.lzo"
		fi  
	done
	echo $filePaths
}


################################################################
#
# Runs a job in batches, and sets variable "i" for each run
# Params: 
#	1 - The function to execute
#	2 - Total number of iterations
#	3 - Size of the batch
#	4 - (optional) Delay on job start. No delay on start if
#	not specified
#
# Example: 
# function test 
# {
# 	echo "Started instance $1 : `date`"
# 	sleep 5
# 	echo "Finised instance $1"
# }
# runInBatch test 7 5 
# runInBatch test 7 5 2
#
################################################################
function runInBatch
{
	nbIteration=$2
	batchSize=$3
	startDelay=$4
	for(( n=0; n<$nbIteration; ))
	do 
		for(( i=1; i<=$batchSize & n<$nbIteration; i++ ))
		do
			let n=n+1
			if [ "$startDelay" != "" ]
			then
				if [ $startDelay -gt 0 ]
				then
					sleep $startDelay
				fi
			fi
			($1 $n) &
		done
		wait
	done
}


################################################################
#
# Checks that the date provided as argument matches the date 
# format: YYYY/MM/DD and that the . If not, it exits with code 1
#
# Example: 
# checkDateFormat "2012/03/01" 
# checkDateFormat "2012-03-01" 
# checkDateFormat "1999/03/01" 
# checkDateFormat "2012/03/45" 
#
################################################################
function checkDateFormat
{
	dateStr=$1
	if [[ $dateStr =~ '20[[:digit:]]{2}/[[:digit:]]{2}/[[:digit:]]{2}' ]]
	then
		res=$(date -d "$dateStr" "+%Y/%m/%d")
		if [ "$res" != "$dateStr" ]
		then
			echo "'$dateStr' is not a valid date. It must be formatted: YYYY/MM/DD"
			exit 1;
		fi
	else
		echo "'$dateStr' is not a valid date. It must be formatted: YYYY/MM/DD and be part of the 21st century"
		exit 1;
	fi
}


################################################################
#
# Echoes the report name and path (for consistent naming)
# The report is located in path: 
#	/report/[report name]/YYYY/MM/DD
# And the report file name is:
#	YYYY-MM-DD.ts.[report name]
# (To which additionnal sreport-specific info can be appeneded)
# where:
# 	YYYY-MM-DD is the human readable report day
# 	ts is the unix timestamp of when the report was generated
#
# Params: 
#	1 - Report name
#	2 - Report date
#
# Example:
# echoReportFSName "uniqCount" "2012/03/12"
# 
################################################################
function echoReportFSName
{
	reportName="$1"
	reportDay="$2"
	reportDate=`echo "$reportDay" | tr '/' '-'`
	reportTs=`date +%s`
	echo "/report/$reportName/$reportDay/$reportDate.$reportTs.$reportName"
}

function echoReportFSNameFixed
{
   reportName="$1"
   reportDay="$2"
   reportDate=`echo "$reportDay" | tr '/' '-'`
   reportTs=$3;
   echo "/report/$reportName/$reportDay/$reportDate.$reportTs.$reportName"
}
function noop {
    echo $*
}
#######################################################################
# To make scripts wprk on Mac/BSD and on LINUX
#
########################################################################
function day  {
    uname=`uname`;
    if [ "$uname" == "Darwin" ]
    then
        DAY=$(date -v${1}d "+%Y/%m/%d")
    else
        DAY=$(date -d "$1 day" "+%Y/%m/%d")
    fi
    echo $DAY;
}

function adddays  {
    uname=`uname`;
    if [ "$uname" == "Darwin" ]
    then
		  if [[ $2 == -* ]]
		  then
				DAY=$(date -v$2d -j -f "%Y/%m/%d" "$1" "+%Y/%m/%d")
		  else
				DAY=$(date -v+$2d -j -f "%Y/%m/%d" "$1" "+%Y/%m/%d")
		  fi
		  P=
    else
		  DAY=$(date -d "$1 $2 days" "+%Y/%m/%d")
    fi
    echo $DAY;
}

function test {
	ff="";
	for(( i=-1; i>=-5; i-- ))
	do  
		 P=`adddays $reportDay $i`
		 ff="$ff,"`_replaceDateInPath "raw[DATE]/*.lzo" $P`
	done
	for(( i=1; i<=5; i++ ))
	do  
		 P=`adddays $reportDay $i`
		 ff="$ff,"`_replaceDateInPath "raw[DATE]Path" $P`
	done
	echo "==>" $ff
}

function hadoopPathExists()
{
    local path=$1
    pe=$(hadoop fs -ls $path >/dev/null 2>&1; echo $?);
    if [ "$pe" -ne "0" ]; then
      echo "There are no files in $path"
    else
      arr_push $path
    fi
}

function genHDFSFilePaths()
{
   local totalDays=$1
   local day=$2
   local prefix=$3
   fpath=$4

   for(( c=0; c<$totalDays; c++ ))
   do
     d=$(( $day-($c*86400) ))
     p="$prefix"$(date -d @$d "+%Y/%m/%d")"/*.lzo"

     hadoopPathExists $p
        #if [ $c -eq 0 ]; then
         #  fpath="$p"
   done
 }

arr_push() {
  arr=("${arr[@]}" "$1")
}


# Use as:
# mailfile <TO> <SUBJECT> <FILE> <Gzip?>
#
# Ex: 
# mailfile sada_narayanappa@cable.comcast.com "File attached" t.txt  1
#
function mailfile() {
    TO=$1
    SUBJ=$2
    FILE=$3
         
    if [[ $4 -ne 0 ]]; then 
        gzip $FILE
        FILE=$FILE.gz
    fi   

    (echo "File $FILE ..."; uuencode $FILE $FILE) | mail -s "$SUBJ" $TO

}
# mail Hadoop file
# Use as:
# mailhfile <TO> <SUBJECT> <HADOOP-FILE> <Gzip?>
#  
# Ex:
#    TO=sada_narayanappa@cable.comcast.com 
#    mailhfile $TO "Hadoop File attached" '/tmp/testm.txt'  1
#
function mailhfile() {
   TO=$1
   SUBJ=$2
   HFILE=$3
   FILE=`basename $HFILE`
   PE=`hadoopPathExists "$HFILE"`
   if [ "$PE" != "" ]
   then
		 echo "No such file: $HFILE"
       exit;
   fi
	((MAXSIZE=10 *  1024 * 1024))
	FSIZE=`hadoop fs -dus /tmp/testm.txt | awk '{print $2}'`
	if [ $FSIZE > $MAXSIZE ]; then
		 echo "File larger than $MAXSIZE bytes ..."
		 exit;
	fi


   if [ -f $FILE ]; then
      mv $FILE $FILE.`date +%s`
   fi
   
   hadoop fs -copyToLocal $HFILE $FILE

   if [ ! -f $FILE ]; then
      echo "Internal error ...expecting local copy of the file $HFILE in $FILE"
   fi

   if [[ $4 -ne 0 ]]; then 
      gzip $FILE
      FILE=$FILE.gz
   fi    

   (echo "File $FILE ..."; uuencode $FILE $FILE) | mail -s "$SUBJ" $TO
   rm $FILE
}


