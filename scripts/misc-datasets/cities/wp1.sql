#************************************************************
#
# Create worldcities
#
#************************************************************
drop table IF EXISTS worldcities;

create table worldcities(
	gid			serial	NOT NULL,
	country		text,
	city			text,
	accentCity	text,
	region		text,
	population	text,
	the_geom		geometry,
	latitude		float,
	longitude	float,

  CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2),
  CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL),
  CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 4326)
);

-- Index: landmarks_the_geom_gist
-- DROP INDEX worldcities_the_geom_gist;
 
CREATE INDEX worldcities_the_geom_gist ON worldcities
  USING gist
  (the_geom );

-- \copy worldcities(country,city,accentCity,region,population,latitude,longitude) FROM 'worldcitiespop.csv'  DELIMITERS ',' CSV HEADER;

#************************************************************
#
# Copy the csv into the table
#
#************************************************************

\copy worldcities(country,city,accentCity,region,population,latitude,longitude) FROM 'worldcitiespop.csv'  DELIMITERS ',' QUOTE E'\f' CSV HEADER ENCODING 'LATIN1';

#************************************************************
#
# Update the column
#
#************************************************************

update worldcities SET the_geom = ST_GeomFromText('POINT(' || longitude || ' ' || latitude || ')',4326);
alter table worldcities add column loc point;
update worldcities SET loc = point(longitude, latitude )

