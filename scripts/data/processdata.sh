export CFILE="../data/us_zip.csv.orig"

cat ${CFILE} | sed '/^$/d' | sed 's/"//g' |  \
	 awk  -F ","  'BEGIN{OFS=","}{print $1, $2, $3,"US", $4, $5, $6, $7 }' > \
	 ../data/us_zip.csv
