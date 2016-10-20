--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: pgrouting; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pgrouting WITH SCHEMA public;


--
-- Name: EXTENSION pgrouting; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgrouting IS 'pgRouting Extension';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = public, pg_catalog;

--
-- Name: convert_to_integer(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION convert_to_integer(v_input text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE v_int_value INTEGER DEFAULT NULL;
BEGIN
    BEGIN
        v_int_value := v_input::INTEGER;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Invalid integer value: "%".  Returning NULL.', v_input;
        RETURN NULL;
    END;
RETURN v_int_value;
END;


$$;


ALTER FUNCTION public.convert_to_integer(v_input text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: loc; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE loc (
    id integer NOT NULL,
    stored_at timestamp without time zone DEFAULT timezone('utc'::text, now()),
    measured_at timestamp without time zone DEFAULT timezone('utc'::text, now()),
    is_valid integer DEFAULT 0,
    api_key character varying(16) NOT NULL,
    version character varying(16),
    record_type character varying(16),
    session_num character varying(16),
    mobile_id character varying(32),
    user_id character varying(32),
    caller_ip character varying(32),
    lat double precision,
    lon double precision,
    accuracy double precision,
    speed double precision,
    bearing double precision,
    alt double precision,
    device_temp character varying(16),
    device_pressure character varying(16),
    device_humidity character varying(16),
    device_light character varying(16),
    medication character varying(32),
    weather_time timestamp without time zone,
    temperature_min double precision,
    temperature_max double precision,
    humidity double precision,
    no2 double precision,
    pressure double precision,
    wind character varying(64),
    clouds_sky character varying(64),
    notes character varying,
    attr hstore,
    the_geom geometry,
    location point,
    activity character varying(16),
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(the_geom) = 'POINT'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


ALTER TABLE loc OWNER TO postgres;

--
-- Name: loc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE loc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE loc_id_seq OWNER TO postgres;

--
-- Name: loc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE loc_id_seq OWNED BY loc.id;


--
-- Name: network; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE network (
    gid integer,
    osm_id character varying(11),
    name character varying(48),
    ref character varying(16),
    type character varying(16),
    oneway smallint,
    bridge smallint,
    tunnel smallint,
    maxspeed smallint,
    geom geometry(MultiLineString,4326),
    is_interested boolean,
    st_startpoint geometry,
    st_endpoint geometry,
    start_id integer,
    end_id integer
);


ALTER TABLE network OWNER TO postgres;

--
-- Name: node; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE node (
    id integer,
    the_geom geometry
);


ALTER TABLE node OWNER TO postgres;

--
-- Name: nodetesting; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE nodetesting (
    id integer,
    the_geom geometry
);


ALTER TABLE nodetesting OWNER TO postgres;

--
-- Name: pgr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pgr (
    id integer NOT NULL,
    osm_id bigint,
    osm_name character varying,
    osm_meta character varying,
    osm_source_id bigint,
    osm_target_id bigint,
    clazz integer,
    flags integer,
    source integer,
    target integer,
    km double precision,
    kmh integer,
    cost double precision,
    reverse_cost double precision,
    x1 double precision,
    y1 double precision,
    x2 double precision,
    y2 double precision,
    geom_way geometry
);


ALTER TABLE pgr OWNER TO postgres;

--
-- Name: refined_weather_delaunay; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE refined_weather_delaunay (
    id integer NOT NULL,
    geom geometry(MultiPolygon,4326),
    pointa numeric,
    pointb numeric,
    pointc numeric
);


ALTER TABLE refined_weather_delaunay OWNER TO postgres;

--
-- Name: refined_weather_delaunay_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE refined_weather_delaunay_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE refined_weather_delaunay_id_seq OWNER TO postgres;

--
-- Name: refined_weather_delaunay_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE refined_weather_delaunay_id_seq OWNED BY refined_weather_delaunay.id;


--
-- Name: refined_weather_voronoi; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE refined_weather_voronoi (
    id integer NOT NULL,
    geom geometry(MultiPolygon,4326),
    station_id character varying(254),
    state character varying(254),
    state_name character varying(254),
    lat numeric,
    lon numeric,
    html_url character varying(254),
    rss_url character varying(254),
    xml_url character varying(254),
    is_interes character varying(254),
    voronoi_ge character varying(254),
    is_valid character varying(254),
    gid integer,
    pointa numeric,
    pointb numeric,
    pointc numeric
);


ALTER TABLE refined_weather_voronoi OWNER TO postgres;

--
-- Name: refined_weather_voronoi_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE refined_weather_voronoi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE refined_weather_voronoi_id_seq OWNER TO postgres;

--
-- Name: refined_weather_voronoi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE refined_weather_voronoi_id_seq OWNED BY refined_weather_voronoi.id;


--
-- Name: roads; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE roads (
    gid integer NOT NULL,
    osm_id character varying(11),
    name character varying(48),
    ref character varying(16),
    type character varying(16),
    oneway smallint,
    bridge smallint,
    tunnel smallint,
    maxspeed smallint,
    geom geometry(MultiLineString,4326),
    is_interested boolean
);


ALTER TABLE roads OWNER TO postgres;

--
-- Name: roads_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE roads_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE roads_gid_seq OWNER TO postgres;

--
-- Name: roads_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE roads_gid_seq OWNED BY roads.gid;


--
-- Name: t1; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t1 (
    c1 integer,
    c2 integer
);


ALTER TABLE t1 OWNER TO postgres;

--
-- Name: t2; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE t2 (
    c1 integer,
    c3 integer
);


ALTER TABLE t2 OWNER TO postgres;

--
-- Name: temproutes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE temproutes (
    seq integer NOT NULL,
    route integer NOT NULL,
    node integer,
    edge integer,
    routecost double precision,
    st_asgeojson text,
    sourcenode integer NOT NULL,
    targetnode integer NOT NULL
);


ALTER TABLE temproutes OWNER TO postgres;

--
-- Name: test; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE test (
    name character varying,
    value character varying,
    valid boolean,
    num1 integer,
    num2 double precision,
    num3 double precision,
    dt time without time zone
);


ALTER TABLE test OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    userid integer NOT NULL,
    fname character varying(32),
    lname character varying(32),
    cname character varying(32),
    address character varying(128),
    cellphone character varying(16),
    mobileid character varying(32),
    homephone character varying(16),
    passwd character varying(128),
    home_location character varying(128),
    viewable_mobileid character varying
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_userid_seq OWNER TO postgres;

--
-- Name: users_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_userid_seq OWNED BY users.userid;


--
-- Name: weather; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE weather (
    station_id character varying(8),
    time_gmt timestamp(6) without time zone,
    time_local timestamp(6) without time zone,
    temp_f real,
    weather_json json,
    humidity real,
    wind_mph real,
    visibility_mile character varying,
    raw character varying,
    source character varying,
    weather_xml character varying,
    time_gmt_unix bigint
);


ALTER TABLE weather OWNER TO postgres;

--
-- Name: weather_delaunay; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE weather_delaunay (
    gid integer NOT NULL,
    pointa numeric,
    pointb numeric,
    pointc numeric,
    geom geometry(MultiPolygon,4326),
    center_geom geometry(MultiPoint,4326)
);


ALTER TABLE weather_delaunay OWNER TO postgres;

--
-- Name: weather_delaunay_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE weather_delaunay_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE weather_delaunay_gid_seq OWNER TO postgres;

--
-- Name: weather_delaunay_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE weather_delaunay_gid_seq OWNED BY weather_delaunay.gid;


--
-- Name: weather_stations; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE weather_stations (
    station_id character varying,
    state character varying,
    state_name character varying,
    lat double precision,
    lon double precision,
    html_url character varying,
    rss_url character varying,
    xml_url character varying,
    geom geometry(Point,4326),
    is_interested boolean,
    voronoi_geom geometry(MultiPolygon,4326),
    is_valid boolean
);


ALTER TABLE weather_stations OWNER TO postgres;

--
-- Name: weather_stationsae; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE weather_stationsae (
    station_id character varying,
    state character varying,
    state_name character varying,
    lat double precision,
    lon double precision,
    html_url character varying,
    rss_url character varying,
    xml_url character varying,
    geom geometry,
    is_interested boolean,
    voronoi_geom geometry,
    is_valid boolean
);


ALTER TABLE weather_stationsae OWNER TO postgres;

--
-- Name: weatherae; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE weatherae (
    station_id character varying(8),
    time_gmt timestamp(6) without time zone,
    time_local timestamp(6) without time zone,
    temp_f real,
    weather_json json,
    humidity real,
    wind_mph real,
    visibility_mile character varying,
    raw character varying,
    source character varying,
    weather_xml character varying,
    time_gmt_unix bigint
);


ALTER TABLE weatherae OWNER TO postgres;

--
-- Name: worldcities; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE worldcities (
    gid integer NOT NULL,
    country text,
    city text,
    accentcity text,
    region text,
    population text,
    the_geom geometry,
    latitude double precision,
    longitude double precision,
    loc point,
    CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(the_geom) = 'POINT'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(the_geom) = 4326))
);


ALTER TABLE worldcities OWNER TO postgres;

--
-- Name: worldcities_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE worldcities_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE worldcities_gid_seq OWNER TO postgres;

--
-- Name: worldcities_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE worldcities_gid_seq OWNED BY worldcities.gid;


--
-- Name: wv_vor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE wv_vor (
    gid integer NOT NULL,
    pointa numeric,
    pointb numeric,
    pointc numeric,
    geom geometry(MultiPolygon,4326)
);


ALTER TABLE wv_vor OWNER TO postgres;

--
-- Name: wv_vor_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE wv_vor_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wv_vor_gid_seq OWNER TO postgres;

--
-- Name: wv_vor_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE wv_vor_gid_seq OWNED BY wv_vor.gid;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY loc ALTER COLUMN id SET DEFAULT nextval('loc_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY refined_weather_delaunay ALTER COLUMN id SET DEFAULT nextval('refined_weather_delaunay_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY refined_weather_voronoi ALTER COLUMN id SET DEFAULT nextval('refined_weather_voronoi_id_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY roads ALTER COLUMN gid SET DEFAULT nextval('roads_gid_seq'::regclass);


--
-- Name: userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN userid SET DEFAULT nextval('users_userid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY weather_delaunay ALTER COLUMN gid SET DEFAULT nextval('weather_delaunay_gid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY worldcities ALTER COLUMN gid SET DEFAULT nextval('worldcities_gid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY wv_vor ALTER COLUMN gid SET DEFAULT nextval('wv_vor_gid_seq'::regclass);


--
-- Data for Name: loc; Type: TABLE DATA; Schema: public; Owner: postgres
--
