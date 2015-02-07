DROP TABLE hospital ;

CREATE TABLE hospital (
	gid 						serial 		NOT NULL			,
	provider_number		text,
	name						text,
	address_1				text,
	address_2				text,
	address_3				text,
	city						text,
	state						text,
	zip						text,
	county					text,
	phone						text,
	hospital_type			text,
	hospital_ownership	text,
	emergency_services	text,
	the_geom 				geometry	,
	latitude					float,
	longitude				float,

  CONSTRAINT hospital_pkey PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2),
  CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL),
  CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 4326)
);
-- Index: landmarks_the_geom_gist
DROP INDEX hospital_the_geom_gist;
 
CREATE INDEX hospital_the_geom_gist ON hospital USING gist (the_geom );

