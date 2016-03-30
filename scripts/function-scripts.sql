--1
CREATE OR REPLACE FUNCTION mphtonext(loc)
	RETURNS float8 AS 
$func$
WITH rows AS (
	SELECT 
		*, 
		ROW_NUMBER() OVER (ORDER BY mobile_id, id DESC) AS rn 
	FROM 
		loc 
	WHERE 
		(record_type <> 'active' OR record_type IS NULL)
) 
SELECT 
	sqrt(69.1*(loc1.lat-loc2.lat)*69.1*(loc1.lat-loc2.lat)+(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))*(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3)))/nullif(0.000277778*extract(EPOCH FROM (loc2.measured_at - loc1.measured_at)),0)
FROM rows loc1 
JOIN rows loc2 
ON loc1.rn = loc2.rn + 1 
WHERE 
	loc1.mobile_id = loc2.mobile_id AND
	loc1.id = $1.id 
$func$ LANGUAGE SQL STABLE;
--------------------------------------------------------------------------
--2
CREATE OR REPLACE FUNCTION miledifftonext(loc)
	RETURNS float8 AS 
$func$
WITH rows AS (
	SELECT 
		*, 
		ROW_NUMBER() OVER (ORDER BY mobile_id, id DESC) AS rn 
	FROM 
		loc 
	WHERE 
		(record_type <> 'active' OR record_type IS NULL)
) 
SELECT 
	sqrt(69.1*(loc1.lat-loc2.lat)*69.1*(loc1.lat-loc2.lat)+(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))*(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3)))
FROM rows loc1 
JOIN rows loc2 
ON loc1.rn = loc2.rn + 1 
WHERE 
	loc1.mobile_id = loc2.mobile_id AND
	loc1.id = $1.id 
$func$ LANGUAGE SQL STABLE;
--------------------------------------------------------------------------
--3
CREATE OR REPLACE FUNCTION seconddifftonext(loc)
	RETURNS float8 AS 
$func$
WITH rows AS (
	SELECT 
		*, 
		ROW_NUMBER() OVER (ORDER BY mobile_id, id DESC) AS rn 
	FROM 
		loc 
	WHERE 
		(record_type <> 'active' OR record_type IS NULL)
) 
SELECT 
	extract(EPOCH FROM (loc2.measured_at - loc1.measured_at))
FROM rows loc1 
JOIN rows loc2 
ON loc1.rn = loc2.rn + 1 
WHERE 
	loc1.mobile_id = loc2.mobile_id AND
	loc1.id = $1.id 
$func$ LANGUAGE SQL STABLE;
--------------------------------------------------------------------------
--4
CREATE OR REPLACE FUNCTION mphfromprevious(loc)
	RETURNS float8 AS 
$func$
WITH rows AS (
	SELECT 
		*, 
		ROW_NUMBER() OVER (ORDER BY mobile_id, id DESC) AS rn 
	FROM 
		loc 
	WHERE 
		(record_type <> 'active' OR record_type IS NULL)
) 
SELECT 
	(sqrt(69.1*(loc2.lat-loc1.lat)*69.1*(loc2.lat-loc1.lat)+(69.1*(loc2.lon - loc1.lon)*cos(loc1.lat/57.3))*(69.1*(loc2.lon - loc1.lon)*cos(loc1.lat/57.3))))/nullif(0.000277778*extract(EPOCH FROM (loc1.measured_at- loc2.measured_at)),0)
FROM rows loc1 
JOIN rows loc2 
ON loc1.rn = loc2.rn - 1 
WHERE 
	loc1.mobile_id = loc2.mobile_id AND
	loc1.id = $1.id 
$func$ LANGUAGE SQL STABLE;
--------------------------------------------------------------------------
--5
CREATE OR REPLACE FUNCTION miledifffromprevious(loc)
	RETURNS float8 AS 
$func$
WITH rows AS (
	SELECT 
		*, 
		ROW_NUMBER() OVER (ORDER BY mobile_id, id DESC) AS rn 
	FROM 
		loc 
	WHERE 
		(record_type <> 'active' OR record_type IS NULL)
) 
SELECT 
	sqrt(69.1*(loc2.lat-loc1.lat)*69.1*(loc2.lat-loc1.lat)+(69.1*(loc2.lon - loc1.lon)*cos(loc1.lat/57.3))*(69.1*(loc2.lon - loc1.lon)*cos(loc1.lat/57.3)))
FROM rows loc1 
JOIN rows loc2 
ON loc1.rn = loc2.rn - 1 
WHERE 
	loc1.mobile_id = loc2.mobile_id AND
	loc1.id = $1.id 
$func$ LANGUAGE SQL STABLE;
--------------------------------------------------------------------------
--6
CREATE OR REPLACE FUNCTION seconddifffromprevious(loc)
	RETURNS float8 AS 
$func$
WITH rows AS (
	SELECT 
		*, 
		ROW_NUMBER() OVER (ORDER BY mobile_id, id DESC) AS rn 
	FROM 
		loc 
	WHERE 
		(record_type <> 'active' OR record_type IS NULL)
) 
SELECT 
	extract(EPOCH FROM (loc1.measured_at- loc2.measured_at))
FROM rows loc1 
JOIN rows loc2 
ON loc1.rn = loc2.rn - 1 
WHERE 
	loc1.mobile_id = loc2.mobile_id AND
	loc1.id = $1.id 
$func$ LANGUAGE SQL STABLE;
--------------------------------------------------------------------------
--7
CREATE OR REPLACE FUNCTION angleinradians(loc)
	RETURNS float8 AS 
$func$
WITH rows AS (
	SELECT 
		mobile_id,
		id,
		lat,
		lon,
		ROW_NUMBER() OVER (ORDER BY mobile_id, id DESC) AS rn 
	FROM 
		loc 
	WHERE 
		(record_type <> 'active' OR record_type IS NULL)
) 
SELECT  
	acos(CASE WHEN ((69.1*(loc2.lat-loc3.lat)*69.1*(loc2.lat-loc3.lat)+(69.1*(loc2.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc2.lon - loc3.lon)*cos(loc3.lat/57.3)))-(69.1*(loc1.lat-loc3.lat)*69.1*(loc1.lat-loc3.lat)+(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3)))-(69.1*(loc1.lat-loc2.lat)*69.1*(loc1.lat-loc2.lat)+(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))*(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))))/nullif(-2*sqrt(69.1*(loc1.lat-loc3.lat)*69.1*(loc1.lat-loc3.lat)+(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3)))*sqrt(69.1*(loc1.lat-loc2.lat)*69.1*(loc1.lat-loc2.lat)+(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))*(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))),0) < -1 THEN -1 WHEN ((69.1*(loc2.lat-loc3.lat)*69.1*(loc2.lat-loc3.lat)+(69.1*(loc2.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc2.lon - loc3.lon)*cos(loc3.lat/57.3)))-(69.1*(loc1.lat-loc3.lat)*69.1*(loc1.lat-loc3.lat)+(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3)))-(69.1*(loc1.lat-loc2.lat)*69.1*(loc1.lat-loc2.lat)+(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))*(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))))/nullif(-2*sqrt(69.1*(loc1.lat-loc3.lat)*69.1*(loc1.lat-loc3.lat)+(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3)))*sqrt(69.1*(loc1.lat-loc2.lat)*69.1*(loc1.lat-loc2.lat)+(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))*(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))),0) > 1 THEN 1 ELSE ((69.1*(loc2.lat-loc3.lat)*69.1*(loc2.lat-loc3.lat)+(69.1*(loc2.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc2.lon - loc3.lon)*cos(loc3.lat/57.3)))-(69.1*(loc1.lat-loc3.lat)*69.1*(loc1.lat-loc3.lat)+(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3)))-(69.1*(loc1.lat-loc2.lat)*69.1*(loc1.lat-loc2.lat)+(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))*(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))))/nullif(-2*sqrt(69.1*(loc1.lat-loc3.lat)*69.1*(loc1.lat-loc3.lat)+(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3))*(69.1*(loc1.lon - loc3.lon)*cos(loc3.lat/57.3)))*sqrt(69.1*(loc1.lat-loc2.lat)*69.1*(loc1.lat-loc2.lat)+(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))*(69.1*(loc1.lon - loc2.lon)*cos(loc2.lat/57.3))),0) END) 

FROM rows loc1 
JOIN rows loc2 
ON loc1.rn = loc2.rn + 1 
JOIN rows loc3 
ON  loc1.rn = loc3.rn - 1 
WHERE 
	loc1.mobile_id = loc2.mobile_id AND 
	loc1.mobile_id = loc3.mobile_id AND
	loc1.id = $1.id
$func$ LANGUAGE SQL STABLE;