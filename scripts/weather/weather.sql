DROP TABLE IF EXISTS "public"."weather";
CREATE TABLE "public"."weather" (
	"station_id" 		varchar(8) COLLATE "default",
	"time_gmt" 			timestamp(6),
	"time_gmt_unix" 	int8,
	"time_local" 		timestamp(6),
	"temp_f" 			float4,
	"weather_json" 	json,
	"humidity" 			float4,
	"wind_mph" 			float4,
	"visibility_mile" varchar COLLATE "default",
	"raw" 				varchar COLLATE "default",
	"source" 			varchar COLLATE "default",
	"weather_xml" 		varchar COLLATE "default"
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."weather" OWNER TO "postgres";

