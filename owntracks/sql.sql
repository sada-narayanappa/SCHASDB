CREATE TABLE ownt (
  id           varchar(16)
  lat          float,
  lon          float,
  acc          float,
  battery      float,
  tid          varchar,
  measured_at  timestamp default (now() at time zone 'utc'),
  stored_at    timestamp default (now() at time zone 'utc'),
  notes        varchar,
  the_geom     geometry
);
