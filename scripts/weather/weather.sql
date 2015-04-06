DROP TABLE IF EXISTS "public"."weather";
CREATE TABLE "public"."weather" (
	"station_id" varchar(8) COLLATE "default",
	"weather_xml" varchar COLLATE "default",
	"weather_json" json,
	"time_gmt" time(6),
	"time_local" time(6)
	"temp_f" float4,
	"humidity" float4,
	"wind_mph" float4,
	"visibility_mile" varchar COLLATE "default",
	"raw" varchar COLLATE "default",
	"source" varchar COLLATE "default",
)
WITH (OIDS=FALSE);
ALTER TABLE "public"."weather" OWNER TO "postgres";

