--
-- PostgreSQL database dump
--

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg12+1)
-- Dumped by pg_dump version 16.9 (Debian 16.9-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: artist_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artist_events (
    id bigint NOT NULL,
    artist_id bigint NOT NULL,
    event_id bigint NOT NULL,
    set_start_time timestamp(6) without time zone,
    set_end_time timestamp(6) without time zone,
    live boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: artist_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.artist_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artist_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.artist_events_id_seq OWNED BY public.artist_events.id;


--
-- Name: artists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artists (
    id bigint NOT NULL,
    name character varying,
    genre_id bigint,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    ra_followers integer
);


--
-- Name: artists_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artists_events (
    artist_id bigint NOT NULL,
    event_id bigint NOT NULL
);


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.artists_id_seq OWNED BY public.artists.id;


--
-- Name: event_attendees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.event_attendees (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    event_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: event_attendees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.event_attendees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_attendees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.event_attendees_id_seq OWNED BY public.event_attendees.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    title character varying,
    date timestamp(6) without time zone,
    start_time timestamp(6) without time zone,
    end_time timestamp(6) without time zone,
    venue_id bigint NOT NULL,
    source character varying,
    description text,
    event_url character varying,
    attending_count integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    ticket_url character varying,
    ticket_price numeric(8,2),
    ticket_tier character varying,
    ticket_wave character varying,
    font_color character varying,
    manual_override boolean,
    short_title character varying,
    event_logo character varying,
    even_shorter_title character varying,
    free_event boolean,
    food_available boolean,
    indoor_outdoor character varying,
    age character varying,
    promoter character varying,
    notes text,
    bg_color character varying,
    manual_override_ticket boolean DEFAULT false,
    manual_override_location boolean DEFAULT false,
    manual_override_times boolean DEFAULT false,
    manual_override_genres boolean DEFAULT false,
    manual_override_title boolean,
    manual_override_artists boolean,
    manual_artist_names text,
    city_key character varying
);


--
-- Name: events_genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events_genres (
    event_id bigint NOT NULL,
    genre_id bigint NOT NULL
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: examples; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.examples (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: examples_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.examples_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: examples_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.examples_id_seq OWNED BY public.examples.id;


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendships (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    friend_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status character varying
);


--
-- Name: friendships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friendships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendships_id_seq OWNED BY public.friendships.id;


--
-- Name: genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.genres (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    hex_color character varying,
    short_name character varying,
    font_color character varying
);


--
-- Name: genres_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.genres_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: genres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.genres_id_seq OWNED BY public.genres.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: ticket_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ticket_posts (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    event_id bigint NOT NULL,
    price character varying,
    looking_for character varying,
    note text
);


--
-- Name: ticket_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ticket_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ticket_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ticket_posts_id_seq OWNED BY public.ticket_posts.id;


--
-- Name: user_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_events (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    event_id bigint NOT NULL,
    status integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_events_id_seq OWNED BY public.user_events.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    profile_info text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    encrypted_password character varying,
    username character varying,
    picture character varying,
    authentication_token character varying,
    admin boolean
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: venues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.venues (
    id bigint NOT NULL,
    name character varying,
    location character varying,
    capacity integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    image_filename character varying,
    bg_color character varying,
    font_color character varying,
    subheading character varying,
    venue_type character varying,
    serves_alcohol character varying,
    notes text,
    venue_url character varying,
    address character varying,
    description text,
    distance integer,
    additional_images text,
    hex_color character varying,
    city_key character varying
);


--
-- Name: venues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.venues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: venues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.venues_id_seq OWNED BY public.venues.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: artist_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_events ALTER COLUMN id SET DEFAULT nextval('public.artist_events_id_seq'::regclass);


--
-- Name: artists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists ALTER COLUMN id SET DEFAULT nextval('public.artists_id_seq'::regclass);


--
-- Name: event_attendees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendees ALTER COLUMN id SET DEFAULT nextval('public.event_attendees_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: examples id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examples ALTER COLUMN id SET DEFAULT nextval('public.examples_id_seq'::regclass);


--
-- Name: friendships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships ALTER COLUMN id SET DEFAULT nextval('public.friendships_id_seq'::regclass);


--
-- Name: genres id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genres ALTER COLUMN id SET DEFAULT nextval('public.genres_id_seq'::regclass);


--
-- Name: ticket_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_posts ALTER COLUMN id SET DEFAULT nextval('public.ticket_posts_id_seq'::regclass);


--
-- Name: user_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_events ALTER COLUMN id SET DEFAULT nextval('public.user_events_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: venues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues ALTER COLUMN id SET DEFAULT nextval('public.venues_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
1	logo	Venue	6	1	2025-05-16 23:54:29.26764
2	logo	Venue	8	2	2025-05-16 23:54:30.425416
3	logo	Venue	9	3	2025-05-16 23:54:30.669924
4	logo	Venue	11	4	2025-05-16 23:54:30.842465
5	logo	Venue	12	5	2025-05-16 23:54:31.139146
6	logo	Venue	13	6	2025-05-16 23:54:31.349969
7	logo	Venue	15	7	2025-05-16 23:54:31.470247
8	logo	Venue	16	8	2025-05-16 23:54:31.641024
9	logo	Venue	17	9	2025-05-16 23:54:31.828067
10	logo	Venue	19	10	2025-05-16 23:54:31.946983
11	logo	Venue	20	11	2025-05-16 23:54:32.100105
12	logo	Venue	21	12	2025-05-16 23:54:32.366551
13	logo	Venue	22	13	2025-05-16 23:54:32.486661
14	logo	Venue	24	14	2025-05-16 23:54:32.641498
15	logo	Venue	25	15	2025-05-16 23:54:32.732538
16	logo	Venue	26	16	2025-05-16 23:54:32.849893
17	logo	Venue	27	17	2025-05-16 23:54:32.94809
18	logo	Venue	28	18	2025-05-16 23:54:33.048008
19	logo	Venue	29	19	2025-05-16 23:54:33.143289
20	logo	Venue	30	20	2025-05-16 23:54:33.226155
21	logo	Venue	31	21	2025-05-16 23:54:33.309701
22	logo	Venue	37	22	2025-05-16 23:54:33.448787
23	logo	Venue	65	23	2025-05-16 23:54:33.659548
24	logo	Venue	69	24	2025-05-16 23:54:33.78864
25	logo	Venue	70	25	2025-05-16 23:54:33.906878
26	logo	Venue	72	26	2025-05-16 23:54:34.049009
27	logo	Venue	73	27	2025-05-16 23:54:34.115258
28	logo	Venue	74	28	2025-05-16 23:54:34.321044
29	logo	Venue	75	29	2025-05-16 23:54:34.413098
30	logo	Venue	76	30	2025-05-16 23:54:34.493761
31	logo	Venue	77	31	2025-05-16 23:54:34.607307
32	logo	Venue	78	32	2025-05-16 23:54:34.869294
33	logo	Venue	79	33	2025-05-16 23:54:35.034137
34	logo	Venue	80	34	2025-05-16 23:54:35.096437
35	logo	Venue	81	35	2025-05-16 23:54:35.191221
36	logo	Venue	84	36	2025-05-16 23:54:35.327214
37	logo	Venue	87	37	2025-05-16 23:54:35.389058
38	logo	Venue	88	38	2025-05-16 23:54:35.511448
39	logo	Venue	90	39	2025-05-16 23:54:35.589606
40	logo	Venue	92	40	2025-05-16 23:54:35.67873
41	logo	Venue	93	41	2025-05-16 23:54:35.780176
42	logo	Venue	94	42	2025-05-16 23:54:35.883849
43	logo	Venue	95	43	2025-05-16 23:54:35.976314
44	logo	Venue	98	44	2025-05-16 23:54:36.053631
45	logo	Venue	99	45	2025-05-16 23:54:36.111481
46	logo	Venue	100	46	2025-05-16 23:54:36.197378
47	logo	Venue	107	47	2025-05-16 23:54:36.300423
48	logo	Venue	108	48	2025-05-16 23:54:36.682823
49	image	ActiveStorage::VariantRecord	1	49	2025-05-16 23:57:00.34767
50	image	ActiveStorage::VariantRecord	2	50	2025-05-16 23:57:00.858224
51	image	ActiveStorage::VariantRecord	3	51	2025-05-17 00:01:45.444285
54	logo	Venue	109	54	2025-05-17 00:10:01.634719
55	image	ActiveStorage::VariantRecord	5	55	2025-05-17 00:10:02.44523
56	logo	Venue	113	56	2025-05-17 00:10:25.396257
57	image	ActiveStorage::VariantRecord	6	57	2025-05-17 00:10:25.969417
58	logo	Venue	123	58	2025-05-17 00:16:18.533656
59	image	ActiveStorage::VariantRecord	7	59	2025-05-17 00:16:51.538172
61	logo	Venue	110	61	2025-05-18 01:00:31.039783
62	image	ActiveStorage::VariantRecord	8	62	2025-05-18 01:00:31.678286
63	logo	Venue	117	63	2025-05-19 22:13:45.734081
64	image	ActiveStorage::VariantRecord	9	64	2025-05-19 22:13:46.53542
65	logo	Venue	115	65	2025-05-19 22:22:50.964608
66	image	ActiveStorage::VariantRecord	10	66	2025-05-19 22:22:51.739641
67	image	ActiveStorage::VariantRecord	11	67	2025-05-19 22:23:16.456001
68	image	ActiveStorage::VariantRecord	12	68	2025-05-19 22:23:16.462073
69	image	ActiveStorage::VariantRecord	13	69	2025-05-19 22:23:16.695646
70	image	ActiveStorage::VariantRecord	14	70	2025-05-19 22:23:17.151907
71	image	ActiveStorage::VariantRecord	15	71	2025-05-19 22:23:17.158904
72	image	ActiveStorage::VariantRecord	16	72	2025-05-19 22:23:17.348175
73	image	ActiveStorage::VariantRecord	17	73	2025-05-19 22:23:17.544381
74	image	ActiveStorage::VariantRecord	18	74	2025-05-19 22:23:17.636356
75	image	ActiveStorage::VariantRecord	19	75	2025-05-19 22:23:18.151024
76	image	ActiveStorage::VariantRecord	20	76	2025-05-19 22:23:18.154952
77	logo	Venue	118	77	2025-05-19 22:32:31.865715
78	image	ActiveStorage::VariantRecord	21	78	2025-05-19 22:32:32.440337
79	logo	Venue	121	79	2025-05-19 22:39:27.963128
80	image	ActiveStorage::VariantRecord	22	80	2025-05-19 22:39:28.485038
81	logo	Venue	132	81	2025-05-20 17:51:29.005455
82	image	ActiveStorage::VariantRecord	23	82	2025-05-20 17:51:29.656426
85	logo	Venue	120	85	2025-05-20 18:06:04.200181
86	image	ActiveStorage::VariantRecord	25	86	2025-05-20 18:06:04.936894
87	logo	Venue	133	87	2025-05-20 18:10:37.41425
88	image	ActiveStorage::VariantRecord	26	88	2025-05-20 18:14:28.958919
89	logo	Venue	131	89	2025-05-20 18:14:40.774919
90	image	ActiveStorage::VariantRecord	27	90	2025-05-20 18:14:41.409275
91	logo	Venue	116	91	2025-05-20 18:20:59.753424
92	image	ActiveStorage::VariantRecord	28	92	2025-05-20 18:21:00.799303
93	logo	Venue	128	93	2025-05-20 18:26:30.594263
94	image	ActiveStorage::VariantRecord	29	94	2025-05-20 18:26:31.329665
95	logo	Venue	125	95	2025-05-20 18:32:35.425508
96	image	ActiveStorage::VariantRecord	30	96	2025-05-20 18:32:35.964488
97	logo	Venue	122	97	2025-05-20 18:35:47.51518
98	image	ActiveStorage::VariantRecord	31	98	2025-05-20 18:35:48.135135
99	image	ActiveStorage::VariantRecord	32	99	2025-05-20 18:39:50.875548
100	logo	Venue	130	100	2025-05-20 18:43:20.934213
101	image	ActiveStorage::VariantRecord	33	101	2025-05-20 18:43:21.676503
102	logo	Venue	138	102	2025-05-21 02:16:08.866972
103	image	ActiveStorage::VariantRecord	34	103	2025-05-21 02:16:09.534996
104	logo	Venue	140	104	2025-05-22 00:36:49.950091
105	image	ActiveStorage::VariantRecord	35	105	2025-05-22 00:36:51.32307
106	logo	Venue	141	106	2025-05-22 00:42:06.760321
107	image	ActiveStorage::VariantRecord	36	107	2025-05-22 17:38:55.030589
108	image	ActiveStorage::VariantRecord	37	108	2025-05-22 17:39:27.91397
109	image	ActiveStorage::VariantRecord	38	109	2025-05-22 17:39:27.916762
110	image	ActiveStorage::VariantRecord	39	110	2025-05-22 17:39:28.085953
111	image	ActiveStorage::VariantRecord	40	111	2025-05-22 17:39:28.325099
112	image	ActiveStorage::VariantRecord	41	112	2025-05-22 17:39:28.541386
113	image	ActiveStorage::VariantRecord	42	113	2025-05-22 17:39:28.809573
114	image	ActiveStorage::VariantRecord	43	114	2025-05-22 17:39:29.022946
115	image	ActiveStorage::VariantRecord	44	115	2025-05-22 17:39:29.13772
116	image	ActiveStorage::VariantRecord	45	116	2025-05-22 17:39:31.030294
117	logo	Venue	147	117	2025-05-22 22:41:21.000653
118	image	ActiveStorage::VariantRecord	46	118	2025-05-22 22:44:57.805503
119	image	ActiveStorage::VariantRecord	47	119	2025-05-22 22:44:59.443801
120	logo	Venue	149	120	2025-05-22 23:29:09.308188
121	logo	Venue	150	121	2025-05-22 23:36:24.3815
122	logo	Venue	151	122	2025-05-22 23:36:24.593798
123	image	ActiveStorage::VariantRecord	48	123	2025-05-22 23:36:42.72864
124	logo	Venue	152	124	2025-05-22 23:43:52.233849
125	image	ActiveStorage::VariantRecord	49	125	2025-05-23 00:31:03.736292
126	image	ActiveStorage::VariantRecord	50	126	2025-05-23 00:31:03.803326
127	image	ActiveStorage::VariantRecord	51	127	2025-05-23 00:31:03.974149
128	image	ActiveStorage::VariantRecord	52	128	2025-05-23 19:34:47.051328
131	logo	Venue	103	131	2025-05-23 19:36:14.296641
132	image	ActiveStorage::VariantRecord	54	132	2025-05-23 19:36:14.819099
133	logo	Venue	160	133	2026-02-26 04:21:57.101819
134	image	ActiveStorage::VariantRecord	55	134	2026-02-26 04:22:00.112328
135	logo	Venue	159	135	2026-02-26 04:29:26.500064
136	image	ActiveStorage::VariantRecord	56	136	2026-02-26 04:29:29.60946
137	image	ActiveStorage::VariantRecord	57	137	2026-02-26 04:30:43.211955
138	image	ActiveStorage::VariantRecord	59	138	2026-02-27 04:22:42.080474
139	image	ActiveStorage::VariantRecord	60	139	2026-02-27 04:22:42.083792
140	image	ActiveStorage::VariantRecord	58	140	2026-02-27 04:22:42.08462
141	image	ActiveStorage::VariantRecord	61	141	2026-02-27 04:22:43.674585
142	image	ActiveStorage::VariantRecord	62	142	2026-02-27 04:22:43.780952
143	logo	Venue	208	143	2026-02-27 04:24:06.409023
144	image	ActiveStorage::VariantRecord	63	144	2026-02-27 04:24:07.793691
145	logo	Venue	205	145	2026-02-27 04:24:25.200478
146	image	ActiveStorage::VariantRecord	64	146	2026-02-27 04:24:26.075432
147	logo	Venue	197	147	2026-02-27 04:24:48.822554
148	image	ActiveStorage::VariantRecord	65	148	2026-02-27 04:24:49.630514
149	logo	Venue	173	149	2026-02-27 04:25:15.381788
150	image	ActiveStorage::VariantRecord	66	150	2026-02-27 04:25:16.36391
153	logo	Venue	170	153	2026-02-27 04:29:50.097573
154	image	ActiveStorage::VariantRecord	68	154	2026-02-27 04:29:51.102152
155	logo	Venue	175	155	2026-02-27 04:30:14.127623
156	image	ActiveStorage::VariantRecord	69	156	2026-02-27 04:30:14.865827
157	logo	Venue	188	157	2026-02-27 04:30:37.626658
158	image	ActiveStorage::VariantRecord	70	158	2026-02-27 04:30:39.032006
159	logo	Venue	174	159	2026-02-27 04:30:49.130741
160	image	ActiveStorage::VariantRecord	71	160	2026-02-27 04:30:50.094414
161	logo	Venue	209	161	2026-02-27 04:31:25.935846
162	image	ActiveStorage::VariantRecord	72	162	2026-02-27 04:31:26.698519
165	logo	Venue	172	165	2026-02-27 04:34:43.327214
166	image	ActiveStorage::VariantRecord	74	166	2026-02-27 04:34:44.176977
169	logo	Venue	165	169	2026-02-27 05:23:05.980463
170	image	ActiveStorage::VariantRecord	76	170	2026-02-27 05:23:06.869993
171	logo	Venue	169	171	2026-02-27 05:30:01.279348
172	image	ActiveStorage::VariantRecord	77	172	2026-02-27 05:30:02.090514
175	image	ActiveStorage::VariantRecord	79	175	2026-02-27 05:38:52.935074
176	logo	Venue	168	176	2026-02-27 05:39:16.745557
177	image	ActiveStorage::VariantRecord	80	177	2026-02-27 05:39:17.548996
180	logo	Venue	178	180	2026-02-27 06:02:55.705793
181	image	ActiveStorage::VariantRecord	82	181	2026-02-27 06:02:56.973483
182	logo	Venue	179	182	2026-02-27 06:16:41.616751
183	image	ActiveStorage::VariantRecord	83	183	2026-02-27 06:16:42.416294
184	logo	Venue	176	184	2026-02-27 06:19:42.131596
185	image	ActiveStorage::VariantRecord	84	185	2026-02-27 06:19:42.936063
187	logo	Venue	191	187	2026-02-27 06:48:20.895962
188	image	ActiveStorage::VariantRecord	85	188	2026-02-27 06:48:21.458284
189	image	ActiveStorage::VariantRecord	86	189	2026-02-27 22:17:01.135044
190	image	ActiveStorage::VariantRecord	87	190	2026-02-27 22:17:01.927341
191	image	ActiveStorage::VariantRecord	88	191	2026-02-27 22:17:02.248551
192	image	ActiveStorage::VariantRecord	89	192	2026-02-27 22:17:54.41814
193	image	ActiveStorage::VariantRecord	90	193	2026-02-27 22:17:54.627379
194	image	ActiveStorage::VariantRecord	91	194	2026-02-27 22:17:54.670911
195	image	ActiveStorage::VariantRecord	92	195	2026-02-27 22:17:55.021499
196	image	ActiveStorage::VariantRecord	93	196	2026-02-27 22:18:16.718129
197	image	ActiveStorage::VariantRecord	94	197	2026-02-27 22:18:16.789049
198	image	ActiveStorage::VariantRecord	95	198	2026-02-27 22:18:17.466469
199	image	ActiveStorage::VariantRecord	96	199	2026-02-27 22:18:25.011002
201	image	ActiveStorage::VariantRecord	98	201	2026-02-27 22:18:25.440898
202	image	ActiveStorage::VariantRecord	99	202	2026-02-27 22:18:25.934362
203	image	ActiveStorage::VariantRecord	100	203	2026-02-27 22:18:26.352766
200	image	ActiveStorage::VariantRecord	97	200	2026-02-27 22:18:25.27295
204	image	ActiveStorage::VariantRecord	101	204	2026-02-27 22:18:26.761891
205	logo	Venue	221	205	2026-02-27 22:55:08.327186
206	image	ActiveStorage::VariantRecord	102	206	2026-02-27 22:55:09.28638
207	logo	Venue	186	207	2026-02-27 23:13:43.764684
208	image	ActiveStorage::VariantRecord	103	208	2026-02-27 23:13:44.312188
211	logo	Venue	185	211	2026-02-28 02:44:34.972603
212	image	ActiveStorage::VariantRecord	105	212	2026-02-28 02:44:35.44086
213	logo	Venue	183	213	2026-02-28 02:51:34.467612
214	image	ActiveStorage::VariantRecord	106	214	2026-02-28 02:51:34.954456
216	logo	Venue	187	216	2026-02-28 03:29:27.022041
217	image	ActiveStorage::VariantRecord	107	217	2026-02-28 03:29:27.75454
220	logo	Venue	180	220	2026-02-28 04:23:57.02175
221	image	ActiveStorage::VariantRecord	109	221	2026-02-28 04:23:57.834136
222	logo	Venue	199	222	2026-02-28 04:34:44.599537
223	image	ActiveStorage::VariantRecord	110	223	2026-02-28 04:34:45.154248
224	logo	Venue	196	224	2026-02-28 04:54:27.03082
225	image	ActiveStorage::VariantRecord	111	225	2026-02-28 04:54:27.619538
226	logo	Venue	192	226	2026-02-28 05:49:12.36317
227	image	ActiveStorage::VariantRecord	112	227	2026-02-28 05:49:12.789477
232	logo	Venue	182	232	2026-03-01 03:15:53.425857
233	image	ActiveStorage::VariantRecord	115	233	2026-03-01 03:15:53.895792
242	logo	Venue	222	242	2026-03-01 03:53:18.626628
243	logo	Venue	193	243	2026-03-01 03:54:43.650627
244	image	ActiveStorage::VariantRecord	120	244	2026-03-01 03:54:44.130031
245	image	ActiveStorage::VariantRecord	121	245	2026-03-01 04:39:57.992277
248	logo	Venue	194	248	2026-03-03 05:42:13.794907
249	image	ActiveStorage::VariantRecord	123	249	2026-03-03 05:42:14.606481
250	logo	Venue	164	250	2026-03-03 06:23:43.734448
251	image	ActiveStorage::VariantRecord	124	251	2026-03-03 06:23:45.027822
256	logo	Venue	177	256	2026-03-03 06:34:30.008571
257	image	ActiveStorage::VariantRecord	127	257	2026-03-03 06:34:30.81426
260	logo	Venue	206	260	2026-03-03 06:42:12.711983
261	image	ActiveStorage::VariantRecord	129	261	2026-03-03 06:42:13.774712
264	logo	Venue	233	264	2026-03-04 05:26:26.814156
265	image	ActiveStorage::VariantRecord	131	265	2026-03-04 05:26:28.126077
266	logo	Venue	224	266	2026-03-04 06:58:17.790614
267	image	ActiveStorage::VariantRecord	132	267	2026-03-04 06:58:18.58649
268	logo	Venue	207	268	2026-03-06 08:37:40.249583
269	image	ActiveStorage::VariantRecord	133	269	2026-03-06 08:37:41.646291
270	logo	Venue	202	270	2026-03-06 08:37:48.93005
271	image	ActiveStorage::VariantRecord	134	271	2026-03-06 08:37:49.625057
272	logo	Venue	181	272	2026-03-06 08:37:55.339231
273	image	ActiveStorage::VariantRecord	135	273	2026-03-06 08:37:56.026952
274	logo	Venue	171	274	2026-03-06 08:38:01.759923
275	image	ActiveStorage::VariantRecord	136	275	2026-03-06 08:38:02.347499
276	logo	Venue	225	276	2026-03-06 11:33:49.695177
277	image	ActiveStorage::VariantRecord	137	277	2026-03-06 11:33:50.796816
278	logo	Venue	231	278	2026-03-06 11:49:09.034428
279	image	ActiveStorage::VariantRecord	138	279	2026-03-06 11:49:09.516252
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
1	3lckbrjl6486hpvpm9h7gacyxmxu	tangent_gallery.png	image/png	{"identified":true,"width":753,"height":753,"analyzed":true}	amazon	15559	VSKTrFjJ6Lw6JLkXsAbnjw==	2025-05-16 23:54:29.249483
2	iux7ny1zfs8ncmnpnelkkzh8wyvv	motorcity-wine.png	image/png	{"identified":true,"width":250,"height":65,"analyzed":true}	amazon	4514	ZezIjvHNZ8p1BCZBvLLYYw==	2025-05-16 23:54:30.322436
3	i43ycbl5q1thp7mc6o5xorpj1rxt	tv_lounge.png	image/png	{"identified":true,"width":1496,"height":910,"analyzed":true}	amazon	33501	Loe057SiFSJ5UDgYD66CSg==	2025-05-16 23:54:30.666522
4	6b0k8qerkzvshmn5y18g53kscs5c	leland.png	image/png	{"identified":true,"width":500,"height":260,"analyzed":true}	amazon	2479	rbqfyD1vI1ySxDOeoWgd+A==	2025-05-16 23:54:30.83665
5	5z341lw2t5k5z01d9an388gsap1w	magic-stick.png	image/png	{"identified":true,"width":496,"height":444,"analyzed":true}	amazon	4687	p25J/L/qR48ZwPw8B+6uMw==	2025-05-16 23:54:31.088257
6	usrcpys7vdwtuqtwbkt8jnsccjri	northern-lights.png	image/png	{"identified":true,"width":1123,"height":803,"analyzed":true}	amazon	109325	IagV/+yikTsBSpouvvnpQA==	2025-05-16 23:54:31.347397
7	rg38axwz0k7djo4rk4utealzwqf1	berts_warehouse.png	image/png	{"identified":true,"width":919,"height":280,"analyzed":true}	amazon	13975	N2zE7oWJ93FFU0Vth0ilBw==	2025-05-16 23:54:31.4639
8	z16o1553nfa2b0408jrsnn9obr2d	foxglove.png	image/png	{"identified":true,"width":553,"height":553,"analyzed":true}	amazon	346289	jd1A/bWMEnfUKf1WPcsaDQ==	2025-05-16 23:54:31.604545
9	xb7od9vh1b8jzwxi5ye2pgi7oubg	lincoln_factory.png	image/png	{"identified":true,"width":607,"height":607,"analyzed":true}	amazon	28124	U3ByH6hJBWqOCSGNRjl4nA==	2025-05-16 23:54:31.825729
10	cerw52p75zv7ep169t8b8d60tjoj	moondog.png	image/png	{"identified":true,"width":372,"height":370,"analyzed":true}	amazon	3240	FB90bDcTvh/nDKi89R7b5Q==	2025-05-16 23:54:31.939218
11	gund9840n3w979510gq59zf1j8ln	diamond-belle.png	image/png	{"identified":true,"width":1536,"height":1024,"analyzed":true}	amazon	2614402	DpppShX8egrb+mMjKun7Cg==	2025-05-16 23:54:32.097492
12	y4zpdkv1r3fgi4a51j7z5ynelhht	movement-logo.png	image/png	{"identified":true,"width":656,"height":571,"analyzed":true}	amazon	40653	K5nAo8PpEmKYoyUYmePNuA==	2025-05-16 23:54:32.36185
13	96nccberx16aqzc5vks394d5v5xe	mcshanes.png	image/png	{"identified":true,"width":600,"height":288,"analyzed":true}	amazon	146137	g/BrC7LhYl6cKyhQ4Yak9A==	2025-05-16 23:54:32.484369
14	eg6uqh8it7gres11u4u3ksqd9o7a	marble_bar.png	image/png	{"identified":true,"width":819,"height":615,"analyzed":true}	amazon	7343	K66XDbX4jxEVjq2nuZVPfw==	2025-05-16 23:54:32.640209
15	329gic10rb0i70m75u53ukm37s14	exodos.png	image/png	{"identified":true,"width":329,"height":107,"analyzed":true}	amazon	36401	a72OiuhTtN5qMZUWTlQkfQ==	2025-05-16 23:54:32.729204
16	o2piv2b2991riijhm45otw2ikjvx	andy-arts.png	image/png	{"identified":true,"width":582,"height":381,"analyzed":true}	amazon	13266	Be5W4gw8TeSEn6dfC4wELw==	2025-05-16 23:54:32.846831
17	s5252fg9bakm1fi1q12f5kxohiky	matis-avli.png	image/png	{"identified":true,"width":317,"height":68,"analyzed":true}	amazon	17217	cV11lXKaLyyLVzvCSj+Yug==	2025-05-16 23:54:32.946849
18	f754lsnek0rb0egldlvb1ix8elby	detroit-shipping-co.png	image/png	{"identified":true,"width":500,"height":164,"analyzed":true}	amazon	2389	6OqKqrAoz7IbY8tDDGwrXw==	2025-05-16 23:54:33.044746
19	1fheozg9snx9gyd577uqg6yy6q63	level-two.png	image/png	{"identified":true,"width":200,"height":71,"analyzed":true}	amazon	2063	PTWNg/8YGqaLhUZc3wiU5A==	2025-05-16 23:54:33.142102
20	5hq9fdl8o5e45g81p2aha6rpp5rd	spotlite.png	image/png	{"identified":true,"width":500,"height":500,"analyzed":true}	amazon	5054	/R8FGcXbq62r532ufpGD9A==	2025-05-16 23:54:33.220649
21	2fmm66zjx9awt65xnx75n8nhjtik	norwood.png	image/png	{"identified":true,"width":415,"height":129,"analyzed":true}	amazon	1648	C0qiVwQwPetA4K0kRyXCWw==	2025-05-16 23:54:33.305341
22	qf0wbkhbgyw5qe5udz09p5f1wxhn	old-western-logo.png	image/webp	{"identified":true,"width":298,"height":298,"analyzed":true}	amazon	29888	twRrXrJ6yxl7ZO2B+svObQ==	2025-05-16 23:54:33.442222
23	68zhkf8nqla3l12d3tbius40vkdg	ufo-bar.png	image/png	{"identified":true,"width":601,"height":357,"analyzed":true}	amazon	12202	ntWPMkEVafdyTIFtt61RHw==	2025-05-16 23:54:33.654011
24	w1vz25wlsymxfw008n6mlwa7t09r	midnight-temple.png	image/png	{"identified":true,"width":561,"height":178,"analyzed":true}	amazon	41786	Vy141clK7He/7efsZAzr0w==	2025-05-16 23:54:33.787634
25	ia84iuhzxbm3euydniy8lrn9s77c	menjos.png	image/png	{"identified":true,"width":1100,"height":449,"analyzed":true}	amazon	658338	CcBZKi42YoI1dJtEkHe5Gw==	2025-05-16 23:54:33.901985
26	p7x4h0dptlbpd9npj2mmk58u7rdq	mix-bricktown.jpg	image/jpeg	{"identified":true,"width":203,"height":133,"analyzed":true}	amazon	26931	PC4wgd79Zpm1lhod0UQC+w==	2025-05-16 23:54:34.047868
27	n927h6tjfn6yts05l39i4ja79c9k	corktown-tavern.png	image/png	{"identified":true,"width":627,"height":588,"analyzed":true}	amazon	437768	LH8EutB5HVsafraSULheNQ==	2025-05-16 23:54:34.114361
28	xn774dd6upwlma85aptr9kx0gcw6	techno-5k.png	image/png	{"identified":true,"width":300,"height":300,"analyzed":true}	amazon	151188	FMsMsElzV3g+Xc8AILtURg==	2025-05-16 23:54:34.320139
29	v266rrqg1r6w0867uhmnvf8lco72	old-miami.png	image/png	{"identified":true,"width":2076,"height":299,"analyzed":true}	amazon	40302	euaHAJ3qyrmeEaFhaFcVYQ==	2025-05-16 23:54:34.412165
30	h7h08cmnue9bp4hj1ppbgran6su1	third-street.png	image/png	{"identified":true,"width":1080,"height":879,"analyzed":true}	amazon	174683	lgfptDgdz55tm/h4413LDQ==	2025-05-16 23:54:34.492503
31	v7zj0pelwd999vkv44ttjjsj2dm8	russell.png	image/png	{"identified":true,"width":851,"height":857,"analyzed":true}	amazon	103834	L8eD1NglWYm0rM6ErbgaQA==	2025-05-16 23:54:34.606249
32	78ke075tay7ain3buwd9j4jv92r5	big-pink.png	image/png	{"identified":true,"width":851,"height":563,"analyzed":true}	amazon	93639	Id2jtCIVTqo4x0VeX6eA0w==	2025-05-16 23:54:34.868371
33	usgywjmp7zrp61wwmeibg4ir781y	dessert-oasis.png	image/png	{"identified":true,"width":848,"height":332,"analyzed":true}	amazon	25382	c33OWdFtwZNhlIk+5+3uZg==	2025-05-16 23:54:35.03307
34	0aqxmi3kcj00z3mp756567qry9oe	eagle.png	image/png	{"identified":true,"width":1341,"height":1277,"analyzed":true}	amazon	165546	j6iTKfw1SP11GFjML5L7mQ==	2025-05-16 23:54:35.095406
35	2to5k02snof8sytvbcra6ssei1x6	whiskey-parlor.png	image/png	{"identified":true,"width":1955,"height":814,"analyzed":true}	amazon	1108221	cypLSaSmmDZ1TuPMfQif2Q==	2025-05-16 23:54:35.190285
36	wiansrmxtg9drjmygmlkg0ijia5d	collected-detroit.png	image/png	{"identified":true,"width":1145,"height":516,"analyzed":true}	amazon	33751	sEnyhPg68jaCu8oLtGEB7w==	2025-05-16 23:54:35.32571
38	jl9xwskvo1gogz4recacfjd2n0wl	bookies.png	image/png	{"identified":true,"width":229,"height":234,"analyzed":true}	amazon	16535	mVjW/SHRhl57+QgDlPR3rA==	2025-05-16 23:54:35.51051
39	fqfc3brakpfsqgraef4kybcvixlv	high-dive.png	image/png	{"identified":true,"width":229,"height":227,"analyzed":true}	amazon	83636	9qZ+qq+TcJ9WROvTK9xNow==	2025-05-16 23:54:35.582056
40	bxw5x3qr1e5ntmeebls6yc4xj9so	newlab.png	image/png	{"identified":true,"width":848,"height":163,"analyzed":true}	amazon	11022	mrjJKzEjk1IHnDa2L/q8zQ==	2025-05-16 23:54:35.676501
46	siy6tbz3erloobzx15g1uib0109n	halo.png	image/avif	{"identified":true,"width":634,"height":216,"analyzed":true}	amazon	16921	DGXu0BdcEvRl1nsx1J0wcA==	2025-05-16 23:54:36.196334
47	qxe43zkr4y5xcqqc4hb3rypv8bb8	common-pub.png	image/png	{"identified":true,"width":596,"height":442,"analyzed":true}	amazon	5234	k9mau5D3+/fj03VPaNDU4g==	2025-05-16 23:54:36.299444
48	wox6xaye7je7y442owil0mndy9kb	bleu.png	image/webp	{"identified":true,"width":1600,"height":269,"analyzed":true}	amazon	11138	nWHHbCWWx7k/xURMo4cVuA==	2025-05-16 23:54:36.68156
37	6hgogmzsxcusy3qaoafeadxlu1qe	shrek-fillmore.png	image/png	{"identified":true,"width":700,"height":1236,"analyzed":true}	amazon	1145494	30xL9EzHdzA1QBOK+/gGFQ==	2025-05-16 23:54:35.388067
41	z4nkxdtonvpuquvt416n65sf640i	belt.png	image/png	{"identified":true,"width":723,"height":141,"analyzed":true}	amazon	8245	an4y8YXv4yQr4DeR8g/4pA==	2025-05-16 23:54:35.777894
42	uy04b5j374hf0pxgp5dkm568527n	batch.png	image/png	{"identified":true,"width":904,"height":917,"analyzed":true}	amazon	20413	Ni+6XQfRTulQHd39jl5F9A==	2025-05-16 23:54:35.881625
43	hca4pbtw5c0dmhsqzd8quxukjawj	movement-logo.png	image/png	{"identified":true,"width":656,"height":571,"analyzed":true}	amazon	40653	K5nAo8PpEmKYoyUYmePNuA==	2025-05-16 23:54:35.975188
44	uwg69k4biy0qgray1o6kyc6172iv	shadow-gallery.png	image/png	{"identified":true,"width":449,"height":323,"analyzed":true}	amazon	49933	K/mjss8OsgIFBQfTteVV8A==	2025-05-16 23:54:36.052553
45	fcmj4gnm00t73v0tg900zxpazi4z	spkrbox.png	image/png	{"identified":true,"width":677,"height":185,"analyzed":true}	amazon	41453	TYUAjEdctT9T/G8HGPFZxA==	2025-05-16 23:54:36.110725
49	hfuxvpzlouwyr1yr4sgzkypmh1lg	common-pub.png	image/png	{"identified":true,"width":100,"height":74,"analyzed":true}	amazon	3671	D6JoC1haeL3EWkJW4huCOA==	2025-05-16 23:57:00.319338
50	1pg323rfpzxhh8miftbgg2n91jz9	bleu.webp	image/webp	{"identified":true,"width":100,"height":17,"analyzed":true}	amazon	1388	b3VOkFZ/cHISdMMK+2x+dw==	2025-05-16 23:57:00.852111
51	dmd2yrak9hvmwdzrkfusss6ics7m	diamond-belle.png	image/png	{"identified":true,"width":100,"height":67,"analyzed":true}	amazon	14761	4HJq4oKO/Q5RaifPcRBt6g==	2025-05-17 00:01:45.441324
63	lw4dzjyo0dmp0rirkplptya5x2hg	puma.png	image/png	{"identified":true,"width":475,"height":429,"analyzed":true}	amazon	6951	qJFRZT4dLUs1Onw/nTwZ+g==	2025-05-19 22:13:45.729266
54	qij6n63ibasecizggto246lgemt0	belle-isle.png	image/png	{"identified":true,"width":312,"height":196,"analyzed":true}	amazon	33874	tihuSkF7JxckIeYUxZlcZg==	2025-05-17 00:10:01.630305
55	i8jgd16wfs9kiji274u7xywjfyov	belle-isle.png	image/png	{"identified":true,"width":100,"height":63,"analyzed":true}	amazon	13019	oTlT15WHx0cpvpwxg+UY8g==	2025-05-17 00:10:02.443797
56	2ixmfqtb591asqy0lz2qgg9zmyli	lowkey.png	image/png	{"identified":true,"width":500,"height":83,"analyzed":true}	amazon	26563	BGtpiejij2eH78pT7angPA==	2025-05-17 00:10:25.393901
57	llvy3vkvi0b0hkgzisb2vjfsrqr2	lowkey.png	image/png	{"identified":true,"width":100,"height":17,"analyzed":true}	amazon	2774	hRTxzF1Ah8W31+Q+dwinRw==	2025-05-17 00:10:25.966263
58	m2fsivc5epzw1lzvlaw6ezzrx6n5	image0 (1).jpeg	image/jpeg	{"identified":true,"width":1000,"height":1000,"analyzed":true}	amazon	37747	1pNAfXqHY990wnDBY7pPcg==	2025-05-17 00:16:18.531509
59	zarnplcn6td1gab7moo8i3z6i93z	image0 (1).jpeg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	2006	+5FgqvTQwDGe0r93TVbNuw==	2025-05-17 00:16:51.535771
61	ij89pd958eqsqi2cjxin5sjwiepx	117235137_298313687894949_6931413034658996433_n.jpg	image/jpeg	{"identified":true,"width":778,"height":778,"analyzed":true}	amazon	70187	3uC4XRJp2oUzs62VFO4LVQ==	2025-05-18 01:00:31.037866
62	qnvcp80z9ok2kalhcqmfdmvzrg92	117235137_298313687894949_6931413034658996433_n.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	4827	2pQ/zbCshmnhpTtlulUGYg==	2025-05-18 01:00:31.676163
64	zfaje588onpd4f9qa9ffeqhvr2tc	puma.png	image/png	{"identified":true,"width":100,"height":90,"analyzed":true}	amazon	9533	uY9kwAOfoQSmyhKOojf1Mg==	2025-05-19 22:13:46.534309
65	4i9vmvjggo3akvuwba2gcs764cj6	lagerhaus.png	image/png	{"identified":true,"width":487,"height":487,"analyzed":true}	amazon	12916	BnlWv8jfi7IrzVn1ZWviaQ==	2025-05-19 22:22:50.962378
66	znm20vfshtbnv78490u1mr7rh8lm	lagerhaus.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	17578	PUIkcJnow/5IA0VjFTOdpg==	2025-05-19 22:22:51.735448
67	yhgoqc5i0t804pzaji0ykap48qhu	batch.png	image/png	{"identified":true,"width":99,"height":100,"analyzed":true}	amazon	9780	kIoVoucNde3XE6ir5BrFww==	2025-05-19 22:23:16.35701
69	dp4qvomjl96byp1evw6blq7q4tfo	andy-arts.png	image/png	{"identified":true,"width":100,"height":65,"analyzed":true}	amazon	12962	4TqSEIp80c3jVr5xxlYzmw==	2025-05-19 22:23:16.694102
68	rz6fg8ljvwse47vitvvajxnbfkb1	berts_warehouse.png	image/png	{"identified":true,"width":100,"height":30,"analyzed":true}	amazon	3264	0Ye0DeRqMrTE3/Xuo3PrSA==	2025-05-19 22:23:16.44854
70	lcnv6w9q32al789am1lkhict6tw6	dessert-oasis.png	image/png	{"identified":true,"width":100,"height":39,"analyzed":true}	amazon	2790	8XUuTqMIrHPbfTroHT4jgg==	2025-05-19 22:23:17.149557
71	tpg1mpwiekxb6q7je89ibfdlpeeu	eagle.png	image/png	{"identified":true,"width":100,"height":95,"analyzed":true}	amazon	7441	2ZgNSpFx2DlZQadpNlvNOg==	2025-05-19 22:23:17.153934
72	vjtz483gi89lz9g70qvtvcpo5j0t	corktown-tavern.png	image/png	{"identified":true,"width":100,"height":94,"analyzed":true}	amazon	21273	At7QWT7vG5j7D4dmWF83Tw==	2025-05-19 22:23:17.346667
73	wzq64mjllgsvg6d2zk4yxk5u87an	detroit-shipping-co.png	image/png	{"identified":true,"width":100,"height":33,"analyzed":true}	amazon	3075	WGADN9viaQwYlNQEZzIcZQ==	2025-05-19 22:23:17.543275
74	nr75bdgkisxz473k61kfnkjgrbh5	bookies.png	image/png	{"identified":true,"width":98,"height":100,"analyzed":true}	amazon	5752	wfOvLSvui1LSi9pb9TmYQw==	2025-05-19 22:23:17.631294
76	4m29vg7mhc88nab1vjvj9xm6pjsj	collected-detroit.png	image/png	{"identified":true,"width":100,"height":45,"analyzed":true}	amazon	3339	3ZGs3HMJcLhb04JIMVI76A==	2025-05-19 22:23:18.152002
75	qzoxn4bm4cnndgeohohitao2b6fl	big-pink.png	image/png	{"identified":true,"width":100,"height":66,"analyzed":true}	amazon	6781	chjsis53A+z9pDRTwLeJyw==	2025-05-19 22:23:18.149366
77	ligugukne64k39okbju36muj5c0n	DELMAR.png	image/png	{"identified":true,"width":282,"height":346,"analyzed":true}	amazon	7336	+7QPmGp2wCVHdtEMm4z3QQ==	2025-05-19 22:32:31.863252
78	qm64lu5lfvggay4kzn20jtojs5ei	DELMAR.png	image/png	{"identified":true,"width":82,"height":100,"analyzed":true}	amazon	6298	rqqJBh/kZiui4nFpX7nS/w==	2025-05-19 22:32:32.438892
79	qdh8knwtsds3957dc7qw8dn11r5s	golden-rule.png	image/png	{"identified":true,"width":307,"height":88,"analyzed":true}	amazon	35788	jpPUKLRynyeu4oPa0GOedw==	2025-05-19 22:39:27.962066
80	qzrst3eertadniptgpit4r0xf9o6	golden-rule.png	image/png	{"identified":true,"width":100,"height":29,"analyzed":true}	amazon	5565	zp3cwdz9M3q47NudfZVemg==	2025-05-19 22:39:28.483696
81	1e67vveutkip87d569qv2loa9zj6	paramita.png	image/png	{"identified":true,"width":355,"height":63,"analyzed":true}	amazon	675	pe30/I/vHJB/EOBLxkVbUQ==	2025-05-20 17:51:29.00094
82	frxjq0arc3vtfkug6carsrci6ibi	paramita.png	image/png	{"identified":true,"width":100,"height":18,"analyzed":true}	amazon	2047	Xk0PFTeidejhZ/vZKSbcbQ==	2025-05-20 17:51:29.654881
105	20al6b34q99nfqbup0vkcotkzg9s	tj-logo.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	amazon	4774	AqNkwmF4UzZ21KD82jtTaA==	2025-05-22 00:36:51.32141
85	f2xzyuje5b1fqrspq6eqmo0mrn5b	society.png	image/png	{"identified":true,"width":886,"height":229,"analyzed":true}	amazon	306000	w6mFeyxzNUxGFgIDVpK2Nw==	2025-05-20 18:06:04.199055
86	nfib3tpi3jh5ofio5mw30pzll737	society.png	image/png	{"identified":true,"width":100,"height":26,"analyzed":true}	amazon	3744	V2bBPB078cqSseM9IrpcFg==	2025-05-20 18:06:04.935719
87	etjbkdb3bctdk8aenirh0ofcblhu	JNK.png	image/png	{"identified":true,"width":405,"height":167,"analyzed":true}	amazon	5178	Rp86qjtrOR7bz5Sxs39YgQ==	2025-05-20 18:10:37.41221
88	hojouu0g97cgtmgzhag33ov8aalq	JNK.png	image/png	{"identified":true,"width":100,"height":41,"analyzed":true}	amazon	7910	nNaoLRlgKPHNVBxVrL8u6Q==	2025-05-20 18:14:28.957891
89	iyi3slzbioomvypxpvkxzug106lf	vollmers.png	image/png	{"identified":true,"width":852,"height":142,"analyzed":true}	amazon	2583	jItpmnIUf8rv/J7WzjGDFw==	2025-05-20 18:14:40.764888
90	lgtkb3s0sdb865uk8oevh2s29e9y	vollmers.png	image/png	{"identified":true,"width":100,"height":17,"analyzed":true}	amazon	2150	25aWG/cb1f97dWNds/6TAg==	2025-05-20 18:14:41.406707
91	m7klajquzkyxy7ta5eea8j1tix2q	welldonegoods.png	image/png	{"identified":true,"width":429,"height":60,"analyzed":true}	amazon	3642	cngb09QfihZv6aOFCqnxWw==	2025-05-20 18:20:59.752167
92	2wunrn57vwazc554ejrhoq90lk26	welldonegoods.png	image/png	{"identified":true,"width":100,"height":14,"analyzed":true}	amazon	1940	qQfLWyGV2fqR9mNMMxtU2w==	2025-05-20 18:21:00.797264
93	0xybjtegrf5gjizy121lb77ssr5x	thegarage.png	image/png	{"identified":true,"width":627,"height":388,"analyzed":true}	amazon	154243	AbNrEl0za6vc/r0auYngxw==	2025-05-20 18:26:30.57853
94	f73cw3rrajsw0q1hnui6c0q74n4y	thegarage.png	image/png	{"identified":true,"width":100,"height":62,"analyzed":true}	amazon	11801	Ot6Ez29Qxexjy0GQ0aUawg==	2025-05-20 18:26:31.326914
95	whragox9x28q6ip0nyc79qyi1qoy	UPSTAIRS-WHITE_NEW.webp	image/webp	{"identified":true,"width":1507,"height":645,"analyzed":true}	amazon	18200	cKkMMKnqDPliS8bmPU80Mw==	2025-05-20 18:32:35.422277
96	g2dqxz9xp034pyd0ciwjy0cztwhq	UPSTAIRS-WHITE_NEW.webp	image/webp	{"identified":true,"width":100,"height":43,"analyzed":true}	amazon	1864	KhMUbQ4Au9oYMkg2XI1tmg==	2025-05-20 18:32:35.96322
97	8k0hhmpcq2r5kagrgi10z6pdm10x	cafeprince.png	image/png	{"identified":true,"width":219,"height":104,"analyzed":true}	amazon	1904	9Sr55PmrIF9+UST1QsNzoA==	2025-05-20 18:35:47.514246
98	itqkvkclpg7dmpsk4rbx3fkj3q7x	cafeprince.png	image/png	{"identified":true,"width":100,"height":47,"analyzed":true}	amazon	6881	oyANjcmrbAlqiZchbZxB3Q==	2025-05-20 18:35:48.133904
99	bkyglqn3g474ol8lbt8h5omvyptx	matis-avli.png	image/png	{"identified":true,"width":100,"height":21,"analyzed":true}	amazon	5355	crjoXzGQmGVy7lm+j5LxCQ==	2025-05-20 18:39:50.874059
100	uu2ppij86wqkqltq6ybuwyq5br8j	27thletter.png	image/png	{"identified":true,"width":2207,"height":1034,"analyzed":true}	amazon	16992	LrNFf8A71Vw3ieV5CEUROg==	2025-05-20 18:43:20.927229
101	53f38bciqmyv7jo3too7hlnp8zb6	27thletter.png	image/png	{"identified":true,"width":100,"height":47,"analyzed":true}	amazon	3932	wANYd2DY9w/nEyNHEJ+3OA==	2025-05-20 18:43:21.675351
102	0c8ltmmwil0pc8csbptmk2sh8a8w	delux.png	image/png	{"identified":true,"width":683,"height":544,"analyzed":true}	amazon	330214	dTLvpsTYx8yYj+Whzti04A==	2025-05-21 02:16:08.865841
103	at20rsx3uqc2o0zt3cctlbl8xeda	delux.png	image/png	{"identified":true,"width":100,"height":80,"analyzed":true}	amazon	10890	OYADNfIYUgR6blNAFY5XHw==	2025-05-21 02:16:09.533646
104	rfmmmtg5sqky8y77xuuqtaa4ieac	tj-logo.png	image/png	{"identified":true,"width":80,"height":80,"analyzed":true}	amazon	5064	Q0DQYipXLTh6vllL4Q2ulw==	2025-05-22 00:36:49.934569
106	zy6zqus0zc7ugx0405j9c2sthsho	mcdsa.png	image/png	{"identified":true,"width":300,"height":164,"analyzed":true}	amazon	27278	GovE/yhYO8rHw0U0kFPTjA==	2025-05-22 00:42:06.758008
107	te3yorqtp5kn8as6ri68q0iq6qhb	mcdsa.png	image/png	{"identified":true,"width":100,"height":55,"analyzed":true}	amazon	7501	qp2L4ghh/zEoTS0dhk8QhQ==	2025-05-22 17:38:55.027847
109	4w3c1ln1vm4x6898nh97hdqy7geq	high-dive.png	image/png	{"identified":true,"width":100,"height":99,"analyzed":true}	amazon	24480	CFuk2Z1AgX2MDwLpR2LwuQ==	2025-05-22 17:39:27.914934
110	4p63jk4kun3k2gpr1x4frvdaky96	halo.png	image/png	{"identified":true,"width":100,"height":34,"analyzed":true}	amazon	2393	R9eyKcIsa21U6bar+0RZsQ==	2025-05-22 17:39:28.080163
108	ckondbg33k2qy8c1ubw0tgzphhaa	spkrbox.png	image/png	{"identified":true,"width":100,"height":27,"analyzed":true}	amazon	4259	No8CPAbdRauGiH6cUpt5Yg==	2025-05-22 17:39:27.91155
111	ncflbiaczvvth1oyverauqrsn1sz	shadow-gallery.png	image/png	{"identified":true,"width":100,"height":72,"analyzed":true}	amazon	5029	BSCseaqvgcoA7pVDo6/sCQ==	2025-05-22 17:39:28.323626
112	d24utzlb9xsr1m6h2h0a6lj8jz89	shrek-fillmore.png	image/png	{"identified":true,"width":57,"height":100,"analyzed":true}	amazon	17777	0rSYDYNHcqJ8JlP0gMJA6w==	2025-05-22 17:39:28.538617
113	fkm87aux37lwadn5ah1jtv46mh3i	newlab.png	image/png	{"identified":true,"width":100,"height":19,"analyzed":true}	amazon	1973	t4YQqFD/1WcRakL4/SsL4g==	2025-05-22 17:39:28.761346
114	1h9c37lk2e74nn5hoxej1tj4tuu2	movement-logo.png	image/png	{"identified":true,"width":100,"height":87,"analyzed":true}	amazon	4568	gyrvVyyyWNYMmmQDRqXJzg==	2025-05-22 17:39:29.01942
115	oul9nzx0wws6vth9qiphdlms0lmr	belt.png	image/png	{"identified":true,"width":100,"height":20,"analyzed":true}	amazon	1781	KqLcRY2rnSZ1GBjjliYHIQ==	2025-05-22 17:39:29.135326
116	fys9un8y32qnfwgdl2qe3ro4pf6k	old-miami.png	image/png	{"identified":true,"width":100,"height":14,"analyzed":true}	amazon	3867	gpeE09KqvfCg1ekClDEbvg==	2025-05-22 17:39:31.02902
117	eyy2ucdb10s7bi7tpkq1i9ae93aq	Logo_Cafe-Sous-Terre_22_0120-768x651.jpg	image/jpeg	{"identified":true,"width":768,"height":651,"analyzed":true}	amazon	56147	0zNNPUsPOpZqMzLOKGBQIQ==	2025-05-22 22:41:20.998799
118	bx2g57smjwx9g1uht90iyaoar59p	Logo_Cafe-Sous-Terre_22_0120-768x651.jpg	image/jpeg	{"identified":true,"width":100,"height":85,"analyzed":true}	amazon	4154	5rXYobxhsOTWJ7COwkWxqQ==	2025-05-22 22:44:57.751151
119	72uxhr3m7oqkdj2zbntm9alftwxg	tangent_gallery.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	9338	y4VPTmC5XuHkMQxQt9PrAA==	2025-05-22 22:44:59.442205
120	178f9db4jaxwvo7j14agihammcwq	20410f_9f00cd2dc221440c81e3d799177e89ad~mv2.avif	image/avif	{"identified":true,"width":624,"height":314,"analyzed":true}	amazon	29734	/a/0mpqfRGzPh5Zqa20Djg==	2025-05-22 23:29:09.305987
121	kt6nzz8aadbmhvmcfqvwksogz3r5	timewilltell.png	image/png	{"identified":true,"width":1500,"height":1245,"analyzed":true}	amazon	1084136	L+ULs0rCRr508CEVCZ3XIg==	2025-05-22 23:36:24.379265
122	jeskugkxxdh50hojl8qb52dud751	timewilltell.png	image/png	{"identified":true,"width":1500,"height":1245,"analyzed":true}	amazon	1084136	L+ULs0rCRr508CEVCZ3XIg==	2025-05-22 23:36:24.592401
123	ysxezy4s8o3kref7xx86rolgx9ir	timewilltell.png	image/png	{"identified":true,"width":100,"height":83,"analyzed":true}	amazon	15907	g/aVuTFIfHqLGeeqQ2398w==	2025-05-22 23:36:42.726467
124	9yrib7089minavfqpciz85frdg02	13658418_1020907434689659_695155377_a.jpg	image/jpeg	{"identified":true,"width":663,"height":663,"analyzed":true}	amazon	94143	22OGt8BLc/8WORvHhOPebQ==	2025-05-22 23:43:52.232677
126	bzd0og0tlouvmcg5em7ojs833wzk	20410f_9f00cd2dc221440c81e3d799177e89ad~mv2.png	image/png	{"identified":true,"width":100,"height":50,"analyzed":true}	amazon	7659	DUU3WcFl4wZFbkLvgetAMA==	2025-05-23 00:31:03.796449
125	mbnvyd88t5k23xtdhlfofndilcyh	13658418_1020907434689659_695155377_a.jpg	image/jpeg	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	4363	Vx8phrhuAaGP0gNyYwVQqQ==	2025-05-23 00:31:03.714671
127	8y4cop9420wbcxwa1y28f9b7dr3b	timewilltell.png	image/png	{"identified":true,"width":100,"height":83,"analyzed":true}	amazon	15907	g/aVuTFIfHqLGeeqQ2398w==	2025-05-23 00:31:03.9698
128	dfcyttwabfgdfy7v5t1f716c6krm	midnight-temple.png	image/png	{"identified":true,"width":100,"height":32,"analyzed":true}	amazon	6033	ll69bXGFKlFNYLTb0Jq9XQ==	2025-05-23 19:34:47.038053
141	4ddglzinuzp8wd0elsy0h2h0pw30	tv_lounge.png	image/png	{"identified":true,"width":100,"height":61,"analyzed":true}	amazon	3416	ld3velB6bQ2OXGda8/xnZA==	2026-02-27 04:22:43.604432
142	tx3ynhw9mn64v4yn50dtwobm7i48	mcshanes.png	image/png	{"identified":true,"width":100,"height":48,"analyzed":true}	amazon	22218	DSK7+UV866cYLYnFlEqTbA==	2026-02-27 04:22:43.779217
131	ivbqy3jjyssnoaiv66jgqkovapks	temple.png	image/png	{"identified":true,"width":446,"height":108,"analyzed":true}	amazon	4914	vp/L8zY3Tdo7Vi0949ye3g==	2025-05-23 19:36:14.291593
132	h89srxexe9lc4wl7jht9cg6htjde	temple.png	image/png	{"identified":true,"width":100,"height":24,"analyzed":true}	amazon	3571	2Vmsa6qMUUYiRcLmAqrzCw==	2025-05-23 19:36:14.815101
133	ydjrcafepth0n8l8bkxu3as4xg6d	Screenshot 2026-02-25 at 11.20.58 PM.png	image/png	{"identified":true,"width":608,"height":244,"analyzed":true}	amazon	35127	ufnBZ3Vm5grsDU0dtwGE3w==	2026-02-26 04:21:57.003295
134	gp74ethbge3je0f1llsbtn722dc5	Screenshot 2026-02-25 at 11.20.58 PM.png	image/png	{"identified":true,"width":100,"height":40,"analyzed":true}	amazon	5945	QVQyzEdmlEY81nnA1tJg/g==	2026-02-26 04:22:00.110506
135	pttngl5fqec5f7qh749p9qm9lvg2	parislogo.webp	image/webp	{"identified":true,"width":1536,"height":1024,"analyzed":true}	amazon	387826	0kyUSmL+MrjamHxb7BflWA==	2026-02-26 04:29:26.410669
136	dnxisha7ysbxnl1055ywzdoq37ar	parislogo.webp	image/webp	{"identified":true,"width":100,"height":67,"analyzed":true}	amazon	2304	kRHWl+CrsRWbvlH20WeZyg==	2026-02-26 04:29:29.605268
137	swdptllh1qhn2789bpbhd463hvnt	lincoln_factory.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	9354	L0Xcy09U8KdyWOULgExtyA==	2026-02-26 04:30:43.209586
138	ecr7iyq11csz2lqooodp3cei6aph	mix-bricktown.jpg	image/jpeg	{"identified":true,"width":100,"height":66,"analyzed":true}	amazon	18269	MKb+r7iUCZhBNrMId4A3kw==	2026-02-27 04:22:42.016028
140	xdik22p2zi96k2mxyyjcyd7y7arz	marble_bar.png	image/png	{"identified":true,"width":100,"height":75,"analyzed":true}	amazon	5759	4OpKU4IlOTbc+Hn1QvTitg==	2026-02-27 04:22:42.077468
139	mezydd5i8qz3kiux97i9xalx0n4m	norwood.png	image/png	{"identified":true,"width":100,"height":31,"analyzed":true}	amazon	2928	p6yGlhleVB1CTPodn+OZdw==	2026-02-27 04:22:42.074414
143	csddw6frtzwon538jqey64xf6v67	otra.avif	image/avif	{"identified":true,"width":372,"height":266,"analyzed":true}	amazon	15844	W6hwqJhf1Om1RxKxtdR8IQ==	2026-02-27 04:24:06.406628
144	fr1948dzpprai0sctny32dkrgkwq	otra.png	image/png	{"identified":true,"width":100,"height":72,"analyzed":true}	amazon	7584	/cp9gSaA5ZPi5VN0sX9tpg==	2026-02-27 04:24:07.791819
145	fxfs8zhx0y93gagxntbfgd9bs0cf	madclub.png	image/png	{"identified":true,"width":240,"height":241,"analyzed":true}	amazon	5056	JSOKMVHKdOf/q/MiDplrDg==	2026-02-27 04:24:25.198857
146	ugo3mpapbeg09u3zol5exndtradr	madclub.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	3944	hTLA5+1UwDfrrVkufaG0Ww==	2026-02-27 04:24:26.071911
147	12res3sw07v1sgyo0f4jptsjjsnp	hialeahparkcasino-logo2021_R1.png	image/png	{"identified":true,"width":550,"height":300,"analyzed":true}	amazon	22813	+E2Lk1U39RZq6LMvGtfb8w==	2026-02-27 04:24:48.82099
148	1pm4rfwwlxnbcqfc6xpkxhu6toww	hialeahparkcasino-logo2021_R1.png	image/png	{"identified":true,"width":100,"height":55,"analyzed":true}	amazon	6574	4QJMg5tIt3Xgs/y5bkJ4ng==	2026-02-27 04:24:49.627935
149	21om404e5v1yo4fdvoezgv7mq61j	zeyzey.png	image/png	{"identified":true,"width":119,"height":70,"analyzed":true}	amazon	2037	hOY3w6NQl38Mn+d7VwTfkg==	2026-02-27 04:25:15.380285
150	bmmhaq4hnurmy26jz60jikqh6koz	zeyzey.png	image/png	{"identified":true,"width":100,"height":59,"analyzed":true}	amazon	7407	vn19skXfCaaUShyyN9REpg==	2026-02-27 04:25:16.337417
153	a4821qgr378qmf77huyisgokky8x	mazuma.png	image/avif	{"identified":true,"width":424,"height":154,"analyzed":true}	amazon	12275	FHOiQpKGLrnloXwo+PtSlw==	2026-02-27 04:29:50.095302
154	9u1dt228y0pvx49qawz0tjmemgru	mazuma.png	image/png	{"identified":true,"width":100,"height":36,"analyzed":true}	amazon	2522	tRhlI6TgPtJSZShL6uvq1g==	2026-02-27 04:29:51.098528
155	d25h2x6cnh251pxfv8ydnreh7hex	Floyd-Logo-White.webp	image/webp	{"identified":true,"width":245,"height":184,"analyzed":true}	amazon	2136	fxzY0jKuuiJnbFfPLN8E5w==	2026-02-27 04:30:14.124612
156	gvndwjg8ux0y50u4wxuyc5rgm82u	Floyd-Logo-White.webp	image/webp	{"identified":true,"width":100,"height":75,"analyzed":true}	amazon	2254	yagKawSkAnOW77fSkp5a0A==	2026-02-27 04:30:14.864582
157	tkzg574vdjeipsmiqelf6t7yx6vl	2025_MIDLINE_LOGO_LOCKUP_STACKED_WHITE.avif	image/avif	{"identified":true,"width":1320,"height":880,"analyzed":true}	amazon	20350	l0NvCGBylxiAGgbiPr4Y9g==	2026-02-27 04:30:37.624952
158	rofsxp5g0q79ss6tjzgernbsp27m	2025_MIDLINE_LOGO_LOCKUP_STACKED_WHITE.png	image/png	{"identified":true,"width":100,"height":67,"analyzed":true}	amazon	2317	ANwuGgSYZvsatzxdCzoOyQ==	2026-02-27 04:30:38.979842
159	5sdpf72r47yjl3q48mhk5r67gvu2	donotsit.png	image/png	{"identified":true,"width":330,"height":228,"analyzed":true}	amazon	19399	wXcH09T2SYP0LbNGeyCjQA==	2026-02-27 04:30:49.127777
160	csxn0xxsakjbi2my5ogrknupg9kz	donotsit.png	image/png	{"identified":true,"width":100,"height":69,"analyzed":true}	amazon	6776	ojo76bbYc16+0biEJFVNUw==	2026-02-27 04:30:50.092692
161	j8wykgmurmvrva2sdmfdmkrm4otp	6634a39f9f2462783c365ffc_ladiosa logo white.png	image/png	{"identified":true,"width":472,"height":200,"analyzed":true}	amazon	2893	VRDqFBxF6CPQT14hBCFAQA==	2026-02-27 04:31:25.934286
162	48oo7te9qjzm8oiskd22rbpwk9iq	6634a39f9f2462783c365ffc_ladiosa logo white.png	image/png	{"identified":true,"width":100,"height":42,"analyzed":true}	amazon	3649	Yy6SkcflaXuJWQUNsF0kiQ==	2026-02-27 04:31:26.697494
166	kbg86deyfp5scrcrqt27oa3799lq	factory-town-logo-vertical-filled_wht-cropped-150x75.png	image/png	{"identified":true,"width":100,"height":50,"analyzed":true}	amazon	3111	LvxMO7D92N5u24H20j/0CA==	2026-02-27 04:34:44.17559
165	ztf7rvx8741oez8aspmpftbnkrso	factory-town-logo-vertical-filled_wht-cropped-150x75.png	image/png	{"identified":true,"width":150,"height":75,"analyzed":true}	amazon	2419	isMnvPGYtoi4QbfpWH8XGA==	2026-02-27 04:34:43.325158
169	3x1wblv3ughaxm16kkut5gtqvhgq	astra.png	image/png	{"identified":true,"width":780,"height":180,"analyzed":true}	amazon	7493	EL/3MUiCH3ZU4ZAlQTjf+g==	2026-02-27 05:23:05.969431
170	h09fchgxrxt8ahysx3dtemuzhtn6	astra.png	image/png	{"identified":true,"width":100,"height":23,"analyzed":true}	amazon	3393	lYisno4MJu7/u1bKfNqGbA==	2026-02-27 05:23:06.868317
171	q0cvi7a93u0c30dmp188mgyyvszr	jolene.png	image/png	{"identified":true,"width":2033,"height":1256,"analyzed":true}	amazon	85346	2lkIkVlfR5vDHKnGTKL2CQ==	2026-02-27 05:30:01.275982
172	sao4xea5uw1gd1m1yehckjuj1snv	jolene.png	image/png	{"identified":true,"width":100,"height":62,"analyzed":true}	amazon	6558	SsG51BqrjeAC5046Hgo0hw==	2026-02-27 05:30:02.08917
175	7nqwbny5mfbts1hx38bsu6ja6jso	old-western-logo.webp	image/webp	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	5478	E2iJ5pcg2ux6821pb0k4gw==	2026-02-27 05:38:52.933671
176	l14jkcnkfdyk5r2rncd8he56kc6n	idOkkLZvY8_1772170723057.png	image/png	{"identified":true,"width":1500,"height":1500,"analyzed":true}	amazon	182315	Bb4WKGo6YX4JIeTHLQDI6w==	2026-02-27 05:39:16.743964
177	t63gawbz4jxv2ksw0caooz6af4th	idOkkLZvY8_1772170723057.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	4544	jKdIC8RlD01wqgQNbiIXPg==	2026-02-27 05:39:17.494472
185	dtkx0evkkfmdc6hzy5fktwy2vfc1	THEGROUNDLOGOTWITTER.webp	image/webp	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	26238	AhCzZC0ZpqnsUaevTjy8ZQ==	2026-02-27 06:19:42.9348
180	n8twpsivm509a5gbootpvale7x1i	logo white transparent.avif	image/avif	{"identified":true,"width":792,"height":790,"analyzed":true}	amazon	57858	In6MlTeQWaxTBOJ5vBKarw==	2026-02-27 06:02:55.702657
181	wfkyet06gx7ertytprpahb1hkdhu	logo white transparent.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	4578	jhmlLp7+PomXygoPzH6g7g==	2026-02-27 06:02:56.971988
182	b1r80m81uhdi09vfjswvec794la0	6377fe8403cd69232cd4a4f0_E11 logo.avif	image/avif	{"identified":true,"width":989,"height":274,"analyzed":true}	amazon	4107	H+IF6mLzxRFVo59YaqZNLA==	2026-02-27 06:16:41.614162
183	ky5c3387zkihfz514c3rjzd3o2nu	6377fe8403cd69232cd4a4f0_E11 logo.png	image/png	{"identified":true,"width":100,"height":28,"analyzed":true}	amazon	4786	RPMdpDcYdJp8JFtE0whX+Q==	2026-02-27 06:16:42.415103
184	l5vusdvg8u7ojhjm8a1plqtoe01n	THEGROUNDLOGOTWITTER.webp	image/webp	{"identified":true,"width":1500,"height":1500,"analyzed":true}	amazon	46744	TwBP31SA6I8v3t1IfmUcmg==	2026-02-27 06:19:42.039812
187	stqcfnxlcin828jqlbcw70uzcl92	Screenshot 2026-02-27 at 1.46.45 AM.png	image/png	{"identified":true,"width":346,"height":74,"analyzed":true}	amazon	64960	aqOZxpd64smBTOL4Erqr/g==	2026-02-27 06:48:20.894829
188	xc0hvjvldu38dnb91uyc7pwvq9zo	Screenshot 2026-02-27 at 1.46.45 AM.png	image/png	{"identified":true,"width":100,"height":21,"analyzed":true}	amazon	10087	BjknYaU2LvCMc7SWsYXUdA==	2026-02-27 06:48:21.456746
189	ofbjsetf4tr9pibta8snv7wjgsxj	ufo-bar.png	image/png	{"identified":true,"width":100,"height":59,"analyzed":true}	amazon	3597	a4GOYARTiBKDj2OcJsaMdQ==	2026-02-27 22:17:01.123609
190	93pfkjg8jz33oreerl9d57u9ikwr	whiskey-parlor.png	image/png	{"identified":true,"width":100,"height":42,"analyzed":true}	amazon	8446	Xk9kH+WLMJHUtZV5tqD5sQ==	2026-02-27 22:17:01.925403
191	v22wyiy5mlf488o0x84be5mr4qyy	third-street.png	image/png	{"identified":true,"width":100,"height":81,"analyzed":true}	amazon	14431	xw3WQA+fJnKc5jz1+W8IUQ==	2026-02-27 22:17:02.24278
192	wx7l1g23qfmntep83tgvnx6mgw00	foxglove.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	23410	dQp5I4SotsBlybcddNdulQ==	2026-02-27 22:17:54.373323
193	ata0fkrejeznap5j6di67qq3zkco	techno-5k.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	25128	Jfvy5FdModpaThtr/LxGCg==	2026-02-27 22:17:54.626021
194	maxkj7z5toqi3s1nq9oc6qy0tuwh	exodos.png	image/png	{"identified":true,"width":100,"height":33,"analyzed":true}	amazon	4336	RoyGduD5pyZ8g8uH21VtxQ==	2026-02-27 22:17:54.668161
195	zgcruhvie0wwnkrgo4tc3ao0bk0i	movement-logo.png	image/png	{"identified":true,"width":100,"height":87,"analyzed":true}	amazon	4568	gyrvVyyyWNYMmmQDRqXJzg==	2026-02-27 22:17:55.020023
197	dpcivzhx5kpmwx803nuusjsivve6	northern-lights.png	image/png	{"identified":true,"width":100,"height":72,"analyzed":true}	amazon	11749	jeCL5bV6R9c5YTY5/MdMZw==	2026-02-27 22:18:16.787578
196	nvsnhgciskwqkbtfqgm5i8m4n422	spotlite.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	6033	Cy9K5vbkcC3wpzAvU0Z30A==	2026-02-27 22:18:16.653097
198	fsio0p262fnvuwxuicmbhx5sy6ph	russell.png	image/png	{"identified":true,"width":99,"height":100,"analyzed":true}	amazon	5062	I+KsqJ9GxhyF/kbJHSQ07Q==	2026-02-27 22:18:17.465123
199	21c6e3r38vpev4p3irx4m7dm3oh4	motorcity-wine.png	image/png	{"identified":true,"width":100,"height":26,"analyzed":true}	amazon	2713	RP3x43NC9JMXcAxF9Lfpdg==	2026-02-27 22:18:25.009678
200	13g4a9k963ja0euz1975qfs7ywna	level-two.png	image/png	{"identified":true,"width":100,"height":36,"analyzed":true}	amazon	2824	elWvfxrnjT2DLbBdGby8HA==	2026-02-27 22:18:25.271029
201	9c3hzt9df1cr3fjcfro0xfrvn2zf	leland.png	image/png	{"identified":true,"width":100,"height":52,"analyzed":true}	amazon	4184	SHyTxlXPSXxMCoi6XYVaMg==	2026-02-27 22:18:25.439611
202	82rv7y35ywievg0jglm0d97q6uia	moondog.png	image/png	{"identified":true,"width":100,"height":99,"analyzed":true}	amazon	5503	rlzhwCriWKmGf2qvhcv8cg==	2026-02-27 22:18:25.93289
203	izxlp8sn38phtgxsvl90wqjgc6hp	magic-stick.png	image/png	{"identified":true,"width":100,"height":90,"analyzed":true}	amazon	6555	0O4iaRoLUFhN0XzP2hVm9w==	2026-02-27 22:18:26.344916
204	c1u7h1fdcang5qmqpipl4vxm3rfi	menjos.png	image/png	{"identified":true,"width":100,"height":41,"analyzed":true}	amazon	11359	NIoCQrx9Ycb1M0hYtf+Z/Q==	2026-02-27 22:18:26.760435
205	cht38gtc7rh90ur4iwnf8gahv3rh	uva.png	image/png	{"identified":true,"width":370,"height":308,"analyzed":true}	amazon	17287	3itb6ScxIzX6EqtfuCsgzw==	2026-02-27 22:55:08.321947
206	xatb9w4768udeyuybzdy47j8stnn	uva.png	image/png	{"identified":true,"width":100,"height":83,"analyzed":true}	amazon	4176	6jACdp8WCsYUua7zIlJTJQ==	2026-02-27 22:55:09.283198
207	yj55v2w2eeq92mgts1k80fnj9aj6	Screenshot 2026-02-27 at 6.13.34 PM.png	image/png	{"identified":true,"width":562,"height":242,"analyzed":true}	amazon	61457	X8zAcKb6EQ5tDd+x/cMmkA==	2026-02-27 23:13:43.763052
208	kk3q1r5v33zo2lpx7d65138luwfo	Screenshot 2026-02-27 at 6.13.34 PM.png	image/png	{"identified":true,"width":100,"height":43,"analyzed":true}	amazon	8598	NECJygev7+hgEYm0zMcVPA==	2026-02-27 23:13:44.310526
211	3l3a11kphxcc5zovig6xaimkyfob	Wynwood-Marketplace-Logo.png	image/png	{"identified":true,"width":650,"height":450,"analyzed":true}	amazon	22854	pZCnWJgclBwk/7woD3Yl+g==	2026-02-28 02:44:34.967667
212	5z7dstf611lvjja2rdnp5ss6z4xn	Wynwood-Marketplace-Logo.png	image/png	{"identified":true,"width":100,"height":69,"analyzed":true}	amazon	9300	oVWWuTAKyrJCeO28d9StNQ==	2026-02-28 02:44:35.435214
213	pwkfwr8oufyi86o70c1tvvtbqowt	logo-new.png	image/png	{"identified":true,"width":559,"height":269,"analyzed":true}	amazon	23842	Ymwkwv+JdpiGMl2v7ISG/w==	2026-02-28 02:51:34.466445
214	e6z5nwj849ete10qnfb9nr89wapj	logo-new.png	image/png	{"identified":true,"width":100,"height":48,"analyzed":true}	amazon	7868	Mm0dBGdy+oAAAue5u55opA==	2026-02-28 02:51:34.952104
216	0q7rh7j4gxo8f0vwsrzh0ywi3iku	manaa.png	image/png	{"identified":true,"width":2266,"height":732,"analyzed":true}	amazon	146550	/APWYiQCAoDRur/5dnp9gA==	2026-02-28 03:29:27.01775
217	azw3hr8q9tefkb5diyp2fbe3mp7g	manaa.png	image/png	{"identified":true,"width":100,"height":32,"analyzed":true}	amazon	6834	n0Ki4c3ewDPKKQ/I/nJzIQ==	2026-02-28 03:29:27.753322
248	7x2dvgas27c2fayvvb0g6cl9ujvc	1800getluckylogo.png	image/png	{"identified":true,"width":852,"height":851,"analyzed":true}	amazon	47953	b1vk7d6V9zVJaCGxUmetJQ==	2026-03-03 05:42:13.793613
220	fdf3g0d5or8s85bprk2o1rcnwp4y	Screenshot 2026-02-27 at 11.22.18 PM.png	image/png	{"identified":true,"width":1318,"height":492,"analyzed":true}	amazon	606697	yrMoqwIMt6CNkvYLD7p4jQ==	2026-02-28 04:23:57.020501
221	snkmhznubd0fyswykgq7ikvoolkl	Screenshot 2026-02-27 at 11.22.18 PM.png	image/png	{"identified":true,"width":100,"height":37,"analyzed":true}	amazon	10976	i/TvVQ+mOO1MvAVitPmdBw==	2026-02-28 04:23:57.781927
222	3my6cbw3x0kte6hpcsbgasfa4s28	barseecoo.png	image/png	{"identified":true,"width":450,"height":86,"analyzed":true}	amazon	14432	a2CvVGe8vAL1BdWHdEUTcQ==	2026-02-28 04:34:44.597554
223	3s3ejz5g5y3zjqkk0za9vws0n84q	barseecoo.png	image/png	{"identified":true,"width":100,"height":19,"analyzed":true}	amazon	4243	WtSpd/NLMLXbfWOCr1cjfA==	2026-02-28 04:34:45.153032
224	5hlj22jk9x9yq758rf72acb3312y	Screenshot 2026-02-27 at 11.52.21 PM.png	image/png	{"identified":true,"width":1140,"height":194,"analyzed":true}	amazon	166772	XxeEEDZXHbzGqJdPWZ0CmA==	2026-02-28 04:54:27.029616
225	n98tnlweso1wck4ecsa8f4w7y2o6	Screenshot 2026-02-27 at 11.52.21 PM.png	image/png	{"identified":true,"width":100,"height":17,"analyzed":true}	amazon	6070	bApUac6bWb5U4ea7BRE9cA==	2026-02-28 04:54:27.618328
226	2rp62sj2ufp65dbtbgxz1b0bw7i7	coyo.png	image/png	{"identified":true,"width":1126,"height":122,"analyzed":true}	amazon	17217	bjkXqxgH3sf5coIo4irx4Q==	2026-02-28 05:49:12.361846
227	p8ngr6r9ddextbqk3jvtha3bn2jq	coyo.png	image/png	{"identified":true,"width":100,"height":11,"analyzed":true}	amazon	2873	9Pbop+UsqztV5YpnG2H0ww==	2026-02-28 05:49:12.788174
232	jgirzq0m872yhw7eqfdwz93t5lqy	boatparty2.png	image/png	{"identified":true,"width":244,"height":136,"analyzed":true}	amazon	6069	O8/h8q0twq8zvavhStvsPQ==	2026-03-01 03:15:53.422591
233	527sjnp3f2oxx2p0bvzve0urddzn	boatparty2.png	image/png	{"identified":true,"width":100,"height":56,"analyzed":true}	amazon	8287	fAtOJh13HDuOdZdbPQlIuA==	2026-03-01 03:15:53.893848
242	ybmj4mi8gnr7mb38rhp42clgoklc	boatparty2.png	image/png	{"identified":true,"width":244,"height":136,"analyzed":true}	amazon	6069	O8/h8q0twq8zvavhStvsPQ==	2026-03-01 03:53:18.625413
243	j2ton4502le1pblc7m3gn5zwkwxl	boatparty2.png	image/png	{"identified":true,"width":244,"height":136,"analyzed":true}	amazon	6069	O8/h8q0twq8zvavhStvsPQ==	2026-03-01 03:54:43.649353
244	60f5lymybxdx0e8ykwplt5zvezdm	boatparty2.png	image/png	{"identified":true,"width":100,"height":56,"analyzed":true}	amazon	8287	fAtOJh13HDuOdZdbPQlIuA==	2026-03-01 03:54:44.126789
245	7cm99oe2gixbhk5ufzkhjdl4tk6t	boatparty2.png	image/png	{"identified":true,"width":100,"height":56,"analyzed":true}	amazon	8287	fAtOJh13HDuOdZdbPQlIuA==	2026-03-01 04:39:57.988243
249	80xk5mf67u204l2r39o056j6pd2p	1800getluckylogo.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	7300	HImXT9NZm6qHfATnKuE7YA==	2026-03-03 05:42:14.603822
250	7klobs0bzdbanx14v5hvy6abaw06	esme.webp	image/webp	{"identified":true,"width":500,"height":256,"analyzed":true}	amazon	17586	rSjzITs/zt4EJ10o7SOOvg==	2026-03-03 06:23:43.724723
251	4fi0dt8nv0xklkcradkrvxqf3ow6	esme.webp	image/webp	{"identified":true,"width":100,"height":51,"analyzed":true}	amazon	2572	PZGx1Yh9ol7CYufEWIROaw==	2026-03-03 06:23:45.026122
271	vd0exzmzot1nuixxuuqxfm0xbhe0	pool.png	image/png	{"identified":true,"width":100,"height":78,"analyzed":true}	amazon	9903	edks9WOm5/4vHIihg8IQeg==	2026-03-06 08:37:49.623246
272	hr08li6sl2vst4tu6p22bt7dooi5	pool.png	image/png	{"identified":true,"width":942,"height":731,"analyzed":true}	amazon	49741	76ocJ2MB1x8HMOM7jz0wNQ==	2026-03-06 08:37:55.336687
256	r6bqig6gaijtt0610ucbrl9l3j41	m2logo.png	image/png	{"identified":true,"width":176,"height":176,"analyzed":true}	amazon	2607	HGHcTxNoqi9hKfQMdxpYkQ==	2026-03-03 06:34:30.005993
257	6rppg049szrabq0ww15uzmbxdeso	m2logo.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	4881	Vyh7PFmrZZCkCv8ChOpdRA==	2026-03-03 06:34:30.812508
260	dn9vg2ara4wridde7z4007hfblwt	boatparty2.png	image/png	{"identified":true,"width":244,"height":136,"analyzed":true}	amazon	6069	O8/h8q0twq8zvavhStvsPQ==	2026-03-03 06:42:12.710434
261	ue8w9ccfd5xrdwwmplsxpqq4960p	boatparty2.png	image/png	{"identified":true,"width":100,"height":56,"analyzed":true}	amazon	8287	fAtOJh13HDuOdZdbPQlIuA==	2026-03-03 06:42:13.77313
264	1gu8eeu2yt6sk5n5pdwgq42vigfn	unseen.webp	image/webp	{"identified":true,"width":946,"height":817,"analyzed":true}	amazon	45478	X1aP17yOwzacQX9MExEI9w==	2026-03-04 05:26:26.806314
265	q415c6izzhq25ybcyo7eaj2r9jtb	unseen.webp	image/webp	{"identified":true,"width":100,"height":86,"analyzed":true}	amazon	4448	U51GJ4utlc1zO8Cvkwq9Ug==	2026-03-04 05:26:28.1234
266	k996s2pije5r6cyhjvesikhk32hy	mode.png	image/png	{"identified":true,"width":600,"height":600,"analyzed":true}	amazon	33559	286M4I8PsM60q0UThU00nQ==	2026-03-04 06:58:17.784862
267	0rbjx8zzfcger7iikyqb66fgfmrn	mode.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	7528	10Yn9AXQ+QWoaF+Hl3x2+w==	2026-03-04 06:58:18.582748
268	j228jy7yr2e8b25d1pwu2hrim7q8	pool.png	image/png	{"identified":true,"width":942,"height":731,"analyzed":true}	amazon	49741	76ocJ2MB1x8HMOM7jz0wNQ==	2026-03-06 08:37:40.237416
269	wmedwimz1tmzkuoqtj9vldu0c7fv	pool.png	image/png	{"identified":true,"width":100,"height":78,"analyzed":true}	amazon	9903	edks9WOm5/4vHIihg8IQeg==	2026-03-06 08:37:41.644537
270	hstfu7ht40trkbnagflear77j7t8	pool.png	image/png	{"identified":true,"width":942,"height":731,"analyzed":true}	amazon	49741	76ocJ2MB1x8HMOM7jz0wNQ==	2026-03-06 08:37:48.791812
273	tybvtcatcbpiek5kcpyrtgmtrjhr	pool.png	image/png	{"identified":true,"width":100,"height":78,"analyzed":true}	amazon	9903	edks9WOm5/4vHIihg8IQeg==	2026-03-06 08:37:56.024056
274	998he39jowo0e1glxkpttvducmit	pool.png	image/png	{"identified":true,"width":942,"height":731,"analyzed":true}	amazon	49741	76ocJ2MB1x8HMOM7jz0wNQ==	2026-03-06 08:38:01.757633
275	ow70y46xx4dsp07hsafh46dtvfca	pool.png	image/png	{"identified":true,"width":100,"height":78,"analyzed":true}	amazon	9903	edks9WOm5/4vHIihg8IQeg==	2026-03-06 08:38:02.345909
276	bdkk8qoah52rsr8rjumrbquhb5wm	mad.png	image/png	{"identified":true,"width":512,"height":512,"analyzed":true}	amazon	16487	uNaFwl1S6Sm92SzsE8U8aQ==	2026-03-06 11:33:49.68745
277	y3fpx5dkjlt483alciwxvtxm2505	mad.png	image/png	{"identified":true,"width":100,"height":100,"analyzed":true}	amazon	4648	gi6BzUTNN00oJPsAVaLL8A==	2026-03-06 11:33:50.794786
278	yikijv93pm0xg3jvmo4d4sxbhvkp	clevelander.png	image/png	{"identified":true,"width":343,"height":67,"analyzed":true}	amazon	2618	f+5Mf4ADCKzxcynYNTwauw==	2026-03-06 11:49:09.03251
279	sow37b5n0qrlv75k5iis5sfgiz2b	clevelander.png	image/png	{"identified":true,"width":100,"height":20,"analyzed":true}	amazon	1665	AdKokJPFJlVZCNQnJeUtUQ==	2026-03-06 11:49:09.512387
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
1	47	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
2	48	LnMJeSYE0fnBWLeK+AZdZ/bz42U=
3	11	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
5	54	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
6	56	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
7	58	6/MbmLdOctrj7ukuFyVm7nWShm4=
8	61	58nLvjR5lLpeOdoWw8+s844W40I=
9	63	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
10	65	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
11	42	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
12	7	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
13	16	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
14	33	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
15	34	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
16	27	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
17	18	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
18	38	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
19	32	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
20	36	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
21	77	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
22	79	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
23	81	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
25	85	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
26	87	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
27	89	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
28	91	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
29	93	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
30	95	LnMJeSYE0fnBWLeK+AZdZ/bz42U=
31	97	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
32	17	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
33	100	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
34	102	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
35	104	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
36	106	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
37	45	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
38	39	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
39	46	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
40	44	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
41	37	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
42	40	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
43	43	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
44	41	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
45	29	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
46	117	58nLvjR5lLpeOdoWw8+s844W40I=
47	1	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
48	122	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
49	124	58nLvjR5lLpeOdoWw8+s844W40I=
50	120	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
51	121	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
52	24	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
54	131	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
55	133	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
56	135	LnMJeSYE0fnBWLeK+AZdZ/bz42U=
57	9	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
58	14	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
59	26	58nLvjR5lLpeOdoWw8+s844W40I=
60	21	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
61	3	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
62	13	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
63	143	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
64	145	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
65	147	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
66	149	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
68	153	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
69	155	LnMJeSYE0fnBWLeK+AZdZ/bz42U=
70	157	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
71	159	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
72	161	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
74	165	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
76	169	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
77	171	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
79	22	LnMJeSYE0fnBWLeK+AZdZ/bz42U=
80	176	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
82	180	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
83	182	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
84	184	LnMJeSYE0fnBWLeK+AZdZ/bz42U=
85	187	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
86	23	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
87	35	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
88	30	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
89	8	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
90	28	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
91	15	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
92	12	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
93	20	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
94	6	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
95	31	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
96	2	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
97	19	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
98	4	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
99	10	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
100	5	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
101	25	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
102	205	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
103	207	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
105	211	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
106	213	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
107	216	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
109	220	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
110	222	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
111	224	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
112	226	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
115	232	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
120	243	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
121	242	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
123	248	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
124	250	LnMJeSYE0fnBWLeK+AZdZ/bz42U=
127	256	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
129	260	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
131	264	LnMJeSYE0fnBWLeK+AZdZ/bz42U=
132	266	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
133	268	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
134	270	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
135	272	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
136	274	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
137	276	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
138	278	uyx6Kcit1Aa78Mrn7bVgZ7OZn0Y=
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2025-03-15 00:34:00.893512	2025-05-09 06:05:36.120686
\.


--
-- Data for Name: artist_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.artist_events (id, artist_id, event_id, set_start_time, set_end_time, live, created_at, updated_at) FROM stdin;
1718	180	597	\N	\N	\N	2026-02-26 06:48:05.9949	2026-02-26 06:48:05.9949
2146	1410	631	\N	\N	\N	2026-03-01 04:28:20.198216	2026-03-01 04:28:20.198216
2147	1411	631	\N	\N	\N	2026-03-01 04:28:20.210159	2026-03-01 04:28:20.210159
2148	1412	631	\N	\N	\N	2026-03-01 04:28:20.220016	2026-03-01 04:28:20.220016
2149	1413	631	\N	\N	\N	2026-03-01 04:28:20.227656	2026-03-01 04:28:20.227656
2150	1414	631	\N	\N	\N	2026-03-01 04:28:20.255099	2026-03-01 04:28:20.255099
2151	1415	631	\N	\N	\N	2026-03-01 04:28:20.264335	2026-03-01 04:28:20.264335
2152	1416	631	\N	\N	\N	2026-03-01 04:28:20.272095	2026-03-01 04:28:20.272095
2153	1417	631	\N	\N	\N	2026-03-01 04:28:20.279857	2026-03-01 04:28:20.279857
2154	1418	631	\N	\N	\N	2026-03-01 04:28:20.291396	2026-03-01 04:28:20.291396
2155	1419	631	\N	\N	\N	2026-03-01 04:28:20.299135	2026-03-01 04:28:20.299135
2156	1420	631	\N	\N	\N	2026-03-01 04:28:20.31181	2026-03-01 04:28:20.31181
2157	1421	631	\N	\N	\N	2026-03-01 04:28:20.319733	2026-03-01 04:28:20.319733
2158	1422	631	\N	\N	\N	2026-03-01 04:28:20.32959	2026-03-01 04:28:20.32959
2159	1423	631	\N	\N	\N	2026-03-01 04:28:20.35897	2026-03-01 04:28:20.35897
2160	1424	631	\N	\N	\N	2026-03-01 04:28:20.364831	2026-03-01 04:28:20.364831
1719	1102	598	\N	\N	\N	2026-02-27 03:38:14.09158	2026-02-27 03:38:14.09158
1720	1103	598	\N	\N	\N	2026-02-27 03:38:14.108363	2026-02-27 03:38:14.108363
1721	1104	598	\N	\N	\N	2026-02-27 03:38:14.181648	2026-02-27 03:38:14.181648
1722	1105	598	\N	\N	\N	2026-02-27 03:38:14.197868	2026-02-27 03:38:14.197868
1723	1106	600	\N	\N	\N	2026-02-27 03:38:14.463461	2026-02-27 03:38:14.463461
1724	1107	600	\N	\N	\N	2026-02-27 03:38:14.472628	2026-02-27 03:38:14.472628
1725	564	600	\N	\N	\N	2026-02-27 03:38:14.478727	2026-02-27 03:38:14.478727
1726	1108	600	\N	\N	\N	2026-02-27 03:38:14.487526	2026-02-27 03:38:14.487526
1727	256	601	\N	\N	\N	2026-02-27 03:38:14.56642	2026-02-27 03:38:14.56642
1728	1109	601	\N	\N	\N	2026-02-27 03:38:14.581095	2026-02-27 03:38:14.581095
1729	1110	601	\N	\N	\N	2026-02-27 03:38:14.586523	2026-02-27 03:38:14.586523
1730	1111	601	\N	\N	\N	2026-02-27 03:38:14.591766	2026-02-27 03:38:14.591766
1731	1112	601	\N	\N	\N	2026-02-27 03:38:14.600497	2026-02-27 03:38:14.600497
1732	1113	603	\N	\N	\N	2026-02-27 03:38:14.699221	2026-02-27 03:38:14.699221
1733	1114	603	\N	\N	\N	2026-02-27 03:38:14.746633	2026-02-27 03:38:14.746633
1734	1115	603	\N	\N	\N	2026-02-27 03:38:14.751877	2026-02-27 03:38:14.751877
1735	1116	603	\N	\N	\N	2026-02-27 03:38:14.756755	2026-02-27 03:38:14.756755
1736	1117	603	\N	\N	\N	2026-02-27 03:38:14.763588	2026-02-27 03:38:14.763588
1737	1118	603	\N	\N	\N	2026-02-27 03:38:14.770227	2026-02-27 03:38:14.770227
1738	1119	603	\N	\N	\N	2026-02-27 03:38:14.775249	2026-02-27 03:38:14.775249
1739	1120	604	\N	\N	\N	2026-02-27 03:38:14.803819	2026-02-27 03:38:14.803819
1740	1121	604	\N	\N	\N	2026-02-27 03:38:14.847062	2026-02-27 03:38:14.847062
1741	1122	604	\N	\N	\N	2026-02-27 03:38:14.854748	2026-02-27 03:38:14.854748
1742	1123	604	\N	\N	\N	2026-02-27 03:38:14.882859	2026-02-27 03:38:14.882859
1743	1124	606	\N	\N	\N	2026-02-27 03:38:15.000766	2026-02-27 03:38:15.000766
1744	1125	606	\N	\N	\N	2026-02-27 03:38:15.006328	2026-02-27 03:38:15.006328
1745	1126	606	\N	\N	\N	2026-02-27 03:38:15.011149	2026-02-27 03:38:15.011149
1746	1127	606	\N	\N	\N	2026-02-27 03:38:15.018484	2026-02-27 03:38:15.018484
1747	1128	606	\N	\N	\N	2026-02-27 03:38:15.05352	2026-02-27 03:38:15.05352
1748	1129	608	\N	\N	\N	2026-02-27 03:38:15.09867	2026-02-27 03:38:15.09867
1749	1130	608	\N	\N	\N	2026-02-27 03:38:15.105725	2026-02-27 03:38:15.105725
1750	1131	608	\N	\N	\N	2026-02-27 03:38:15.111578	2026-02-27 03:38:15.111578
1751	1132	608	\N	\N	\N	2026-02-27 03:38:15.155775	2026-02-27 03:38:15.155775
1752	1133	608	\N	\N	\N	2026-02-27 03:38:15.163885	2026-02-27 03:38:15.163885
1753	1134	608	\N	\N	\N	2026-02-27 03:38:15.168736	2026-02-27 03:38:15.168736
1754	1135	609	\N	\N	\N	2026-02-27 03:38:15.194934	2026-02-27 03:38:15.194934
1755	1136	609	\N	\N	\N	2026-02-27 03:38:15.20929	2026-02-27 03:38:15.20929
1756	148	609	\N	\N	\N	2026-02-27 03:38:15.248905	2026-02-27 03:38:15.248905
1757	1137	609	\N	\N	\N	2026-02-27 03:38:15.25833	2026-02-27 03:38:15.25833
1758	1138	609	\N	\N	\N	2026-02-27 03:38:15.265467	2026-02-27 03:38:15.265467
1759	1139	609	\N	\N	\N	2026-02-27 03:38:15.269736	2026-02-27 03:38:15.269736
1760	1140	609	\N	\N	\N	2026-02-27 03:38:15.281437	2026-02-27 03:38:15.281437
1761	1141	610	\N	\N	\N	2026-02-27 03:38:15.354279	2026-02-27 03:38:15.354279
1762	1125	610	\N	\N	\N	2026-02-27 03:38:15.360721	2026-02-27 03:38:15.360721
1763	1142	610	\N	\N	\N	2026-02-27 03:38:15.367011	2026-02-27 03:38:15.367011
1764	1143	610	\N	\N	\N	2026-02-27 03:38:15.372862	2026-02-27 03:38:15.372862
1765	1144	610	\N	\N	\N	2026-02-27 03:38:15.396051	2026-02-27 03:38:15.396051
1766	1145	610	\N	\N	\N	2026-02-27 03:38:15.40079	2026-02-27 03:38:15.40079
1767	1146	610	\N	\N	\N	2026-02-27 03:38:15.448997	2026-02-27 03:38:15.448997
1768	1147	610	\N	\N	\N	2026-02-27 03:38:15.454976	2026-02-27 03:38:15.454976
1769	1148	610	\N	\N	\N	2026-02-27 03:38:15.459403	2026-02-27 03:38:15.459403
1770	1149	610	\N	\N	\N	2026-02-27 03:38:15.465156	2026-02-27 03:38:15.465156
1771	1150	610	\N	\N	\N	2026-02-27 03:38:15.469693	2026-02-27 03:38:15.469693
1772	183	610	\N	\N	\N	2026-02-27 03:38:15.472545	2026-02-27 03:38:15.472545
1773	1151	610	\N	\N	\N	2026-02-27 03:38:15.475964	2026-02-27 03:38:15.475964
1774	1152	610	\N	\N	\N	2026-02-27 03:38:15.479476	2026-02-27 03:38:15.479476
1775	54	610	\N	\N	\N	2026-02-27 03:38:15.481613	2026-02-27 03:38:15.481613
1776	1153	610	\N	\N	\N	2026-02-27 03:38:15.485757	2026-02-27 03:38:15.485757
1777	1154	610	\N	\N	\N	2026-02-27 03:38:15.489893	2026-02-27 03:38:15.489893
1778	1155	610	\N	\N	\N	2026-02-27 03:38:15.494917	2026-02-27 03:38:15.494917
1779	1156	610	\N	\N	\N	2026-02-27 03:38:15.499405	2026-02-27 03:38:15.499405
1780	198	610	\N	\N	\N	2026-02-27 03:38:15.531256	2026-02-27 03:38:15.531256
1781	1157	610	\N	\N	\N	2026-02-27 03:38:15.54098	2026-02-27 03:38:15.54098
1782	1158	610	\N	\N	\N	2026-02-27 03:38:15.550877	2026-02-27 03:38:15.550877
1783	1159	610	\N	\N	\N	2026-02-27 03:38:15.558741	2026-02-27 03:38:15.558741
1784	1160	610	\N	\N	\N	2026-02-27 03:38:15.566266	2026-02-27 03:38:15.566266
1785	1161	611	\N	\N	\N	2026-02-27 03:38:15.610969	2026-02-27 03:38:15.610969
1786	1149	612	\N	\N	\N	2026-02-27 03:38:15.632225	2026-02-27 03:38:15.632225
1787	1162	612	\N	\N	\N	2026-02-27 03:38:15.636625	2026-02-27 03:38:15.636625
1788	1163	612	\N	\N	\N	2026-02-27 03:38:15.646028	2026-02-27 03:38:15.646028
1789	1164	612	\N	\N	\N	2026-02-27 03:38:15.649956	2026-02-27 03:38:15.649956
1790	1165	612	\N	\N	\N	2026-02-27 03:38:15.656317	2026-02-27 03:38:15.656317
1791	1166	612	\N	\N	\N	2026-02-27 03:38:15.660084	2026-02-27 03:38:15.660084
1792	1167	612	\N	\N	\N	2026-02-27 03:38:15.663869	2026-02-27 03:38:15.663869
1793	1152	612	\N	\N	\N	2026-02-27 03:38:15.666095	2026-02-27 03:38:15.666095
1794	1151	612	\N	\N	\N	2026-02-27 03:38:15.668182	2026-02-27 03:38:15.668182
1795	1168	612	\N	\N	\N	2026-02-27 03:38:15.671882	2026-02-27 03:38:15.671882
1796	1169	612	\N	\N	\N	2026-02-27 03:38:15.675569	2026-02-27 03:38:15.675569
1797	1170	612	\N	\N	\N	2026-02-27 03:38:15.680981	2026-02-27 03:38:15.680981
1798	1171	612	\N	\N	\N	2026-02-27 03:38:15.746812	2026-02-27 03:38:15.746812
1799	1172	612	\N	\N	\N	2026-02-27 03:38:15.763577	2026-02-27 03:38:15.763577
1800	1158	612	\N	\N	\N	2026-02-27 03:38:15.782073	2026-02-27 03:38:15.782073
1801	1173	612	\N	\N	\N	2026-02-27 03:38:15.840624	2026-02-27 03:38:15.840624
1802	1159	612	\N	\N	\N	2026-02-27 03:38:15.844797	2026-02-27 03:38:15.844797
1803	1160	612	\N	\N	\N	2026-02-27 03:38:15.848996	2026-02-27 03:38:15.848996
1804	183	612	\N	\N	\N	2026-02-27 03:38:15.851835	2026-02-27 03:38:15.851835
1805	1174	612	\N	\N	\N	2026-02-27 03:38:15.857723	2026-02-27 03:38:15.857723
1806	196	612	\N	\N	\N	2026-02-27 03:38:15.860609	2026-02-27 03:38:15.860609
1807	1175	612	\N	\N	\N	2026-02-27 03:38:15.867082	2026-02-27 03:38:15.867082
1808	1176	612	\N	\N	\N	2026-02-27 03:38:15.873464	2026-02-27 03:38:15.873464
1809	1177	612	\N	\N	\N	2026-02-27 03:38:15.880857	2026-02-27 03:38:15.880857
1810	1178	612	\N	\N	\N	2026-02-27 03:38:15.885691	2026-02-27 03:38:15.885691
1811	1179	612	\N	\N	\N	2026-02-27 03:38:15.931263	2026-02-27 03:38:15.931263
1812	1180	613	\N	\N	\N	2026-02-27 03:38:15.957068	2026-02-27 03:38:15.957068
1813	1181	614	\N	\N	\N	2026-02-27 03:38:15.975481	2026-02-27 03:38:15.975481
1814	1182	615	\N	\N	\N	2026-02-27 03:38:15.998853	2026-02-27 03:38:15.998853
1815	1183	616	\N	\N	\N	2026-02-27 03:38:16.054518	2026-02-27 03:38:16.054518
1816	1184	616	\N	\N	\N	2026-02-27 03:38:16.058999	2026-02-27 03:38:16.058999
1817	1185	616	\N	\N	\N	2026-02-27 03:38:16.062844	2026-02-27 03:38:16.062844
1818	1186	616	\N	\N	\N	2026-02-27 03:38:16.132652	2026-02-27 03:38:16.132652
1819	1187	617	\N	\N	\N	2026-02-27 03:38:16.149839	2026-02-27 03:38:16.149839
1820	1188	619	\N	\N	\N	2026-02-27 03:38:16.189707	2026-02-27 03:38:16.189707
1821	1189	619	\N	\N	\N	2026-02-27 03:38:16.238533	2026-02-27 03:38:16.238533
1822	1190	619	\N	\N	\N	2026-02-27 03:38:16.248942	2026-02-27 03:38:16.248942
1823	1191	619	\N	\N	\N	2026-02-27 03:38:16.259488	2026-02-27 03:38:16.259488
1824	1192	619	\N	\N	\N	2026-02-27 03:38:16.27028	2026-02-27 03:38:16.27028
1825	1193	620	\N	\N	\N	2026-02-27 03:38:16.304715	2026-02-27 03:38:16.304715
1826	1194	621	\N	\N	\N	2026-02-27 03:38:16.335182	2026-02-27 03:38:16.335182
1827	1195	621	\N	\N	\N	2026-02-27 03:38:16.340376	2026-02-27 03:38:16.340376
1828	1196	621	\N	\N	\N	2026-02-27 03:38:16.348253	2026-02-27 03:38:16.348253
1829	1197	621	\N	\N	\N	2026-02-27 03:38:16.353278	2026-02-27 03:38:16.353278
1830	184	621	\N	\N	\N	2026-02-27 03:38:16.355775	2026-02-27 03:38:16.355775
1831	1112	621	\N	\N	\N	2026-02-27 03:38:16.358233	2026-02-27 03:38:16.358233
1832	1198	621	\N	\N	\N	2026-02-27 03:38:16.3633	2026-02-27 03:38:16.3633
1833	1199	621	\N	\N	\N	2026-02-27 03:38:16.368636	2026-02-27 03:38:16.368636
1834	843	625	\N	\N	\N	2026-02-27 03:38:16.485671	2026-02-27 03:38:16.485671
1835	256	625	\N	\N	\N	2026-02-27 03:38:16.488115	2026-02-27 03:38:16.488115
1836	1200	625	\N	\N	\N	2026-02-27 03:38:16.492716	2026-02-27 03:38:16.492716
1837	1201	625	\N	\N	\N	2026-02-27 03:38:16.533342	2026-02-27 03:38:16.533342
1838	1202	625	\N	\N	\N	2026-02-27 03:38:16.545522	2026-02-27 03:38:16.545522
1839	1203	625	\N	\N	\N	2026-02-27 03:38:16.550915	2026-02-27 03:38:16.550915
1840	1204	625	\N	\N	\N	2026-02-27 03:38:16.556348	2026-02-27 03:38:16.556348
1841	1205	625	\N	\N	\N	2026-02-27 03:38:16.563966	2026-02-27 03:38:16.563966
1842	1206	625	\N	\N	\N	2026-02-27 03:38:16.568737	2026-02-27 03:38:16.568737
1843	1207	625	\N	\N	\N	2026-02-27 03:38:16.57308	2026-02-27 03:38:16.57308
1844	1208	625	\N	\N	\N	2026-02-27 03:38:16.577337	2026-02-27 03:38:16.577337
1845	1209	625	\N	\N	\N	2026-02-27 03:38:16.585029	2026-02-27 03:38:16.585029
1846	742	625	\N	\N	\N	2026-02-27 03:38:16.633088	2026-02-27 03:38:16.633088
1847	1210	625	\N	\N	\N	2026-02-27 03:38:16.637445	2026-02-27 03:38:16.637445
1848	1211	625	\N	\N	\N	2026-02-27 03:38:16.643149	2026-02-27 03:38:16.643149
1849	1212	625	\N	\N	\N	2026-02-27 03:38:16.660959	2026-02-27 03:38:16.660959
1850	1213	626	\N	\N	\N	2026-02-27 03:38:16.852936	2026-02-27 03:38:16.852936
1851	1214	626	\N	\N	\N	2026-02-27 03:38:16.856563	2026-02-27 03:38:16.856563
1852	1215	626	\N	\N	\N	2026-02-27 03:38:16.860185	2026-02-27 03:38:16.860185
1853	1147	626	\N	\N	\N	2026-02-27 03:38:16.862335	2026-02-27 03:38:16.862335
1854	184	626	\N	\N	\N	2026-02-27 03:38:16.865425	2026-02-27 03:38:16.865425
1855	1152	626	\N	\N	\N	2026-02-27 03:38:16.868073	2026-02-27 03:38:16.868073
1856	1168	626	\N	\N	\N	2026-02-27 03:38:16.870733	2026-02-27 03:38:16.870733
1857	1153	626	\N	\N	\N	2026-02-27 03:38:16.931116	2026-02-27 03:38:16.931116
1858	1154	626	\N	\N	\N	2026-02-27 03:38:16.934174	2026-02-27 03:38:16.934174
1859	1216	626	\N	\N	\N	2026-02-27 03:38:16.93829	2026-02-27 03:38:16.93829
1860	1217	626	\N	\N	\N	2026-02-27 03:38:16.942465	2026-02-27 03:38:16.942465
1861	1218	626	\N	\N	\N	2026-02-27 03:38:16.946134	2026-02-27 03:38:16.946134
1862	1219	626	\N	\N	\N	2026-02-27 03:38:16.949855	2026-02-27 03:38:16.949855
1863	1220	626	\N	\N	\N	2026-02-27 03:38:16.953671	2026-02-27 03:38:16.953671
1864	1221	626	\N	\N	\N	2026-02-27 03:38:16.957563	2026-02-27 03:38:16.957563
1865	1222	626	\N	\N	\N	2026-02-27 03:38:16.961584	2026-02-27 03:38:16.961584
1866	1141	626	\N	\N	\N	2026-02-27 03:38:16.964003	2026-02-27 03:38:16.964003
1867	1223	626	\N	\N	\N	2026-02-27 03:38:16.967614	2026-02-27 03:38:16.967614
1868	1224	626	\N	\N	\N	2026-02-27 03:38:16.971227	2026-02-27 03:38:16.971227
1869	1225	626	\N	\N	\N	2026-02-27 03:38:17.034181	2026-02-27 03:38:17.034181
1870	1226	626	\N	\N	\N	2026-02-27 03:38:17.038922	2026-02-27 03:38:17.038922
1871	1227	626	\N	\N	\N	2026-02-27 03:38:17.047587	2026-02-27 03:38:17.047587
1872	1128	626	\N	\N	\N	2026-02-27 03:38:17.050481	2026-02-27 03:38:17.050481
1873	1112	626	\N	\N	\N	2026-02-27 03:38:17.054482	2026-02-27 03:38:17.054482
1874	1228	626	\N	\N	\N	2026-02-27 03:38:17.059299	2026-02-27 03:38:17.059299
1875	1142	626	\N	\N	\N	2026-02-27 03:38:17.061999	2026-02-27 03:38:17.061999
1876	1229	626	\N	\N	\N	2026-02-27 03:38:17.066763	2026-02-27 03:38:17.066763
1877	1176	626	\N	\N	\N	2026-02-27 03:38:17.06989	2026-02-27 03:38:17.06989
1878	1230	626	\N	\N	\N	2026-02-27 03:38:17.07534	2026-02-27 03:38:17.07534
1879	1231	626	\N	\N	\N	2026-02-27 03:38:17.132081	2026-02-27 03:38:17.132081
1880	1232	627	\N	\N	\N	2026-02-27 03:38:17.151533	2026-02-27 03:38:17.151533
1881	1233	628	\N	\N	\N	2026-02-27 03:38:17.169807	2026-02-27 03:38:17.169807
1882	214	628	\N	\N	\N	2026-02-27 03:38:17.172562	2026-02-27 03:38:17.172562
1883	1234	628	\N	\N	\N	2026-02-27 03:38:17.17682	2026-02-27 03:38:17.17682
1884	152	629	\N	\N	\N	2026-02-27 03:38:17.234795	2026-02-27 03:38:17.234795
1885	1235	629	\N	\N	\N	2026-02-27 03:38:17.239527	2026-02-27 03:38:17.239527
1886	1236	629	\N	\N	\N	2026-02-27 03:38:17.243774	2026-02-27 03:38:17.243774
1887	1237	629	\N	\N	\N	2026-02-27 03:38:17.248276	2026-02-27 03:38:17.248276
1888	1162	630	\N	\N	\N	2026-02-27 03:38:17.262612	2026-02-27 03:38:17.262612
1889	1238	630	\N	\N	\N	2026-02-27 03:38:17.267129	2026-02-27 03:38:17.267129
1890	1239	632	\N	\N	\N	2026-02-27 03:38:17.352885	2026-02-27 03:38:17.352885
1891	1138	632	\N	\N	\N	2026-02-27 03:38:17.355461	2026-02-27 03:38:17.355461
1892	1240	632	\N	\N	\N	2026-02-27 03:38:17.359376	2026-02-27 03:38:17.359376
1893	1241	633	\N	\N	\N	2026-02-27 03:38:17.431413	2026-02-27 03:38:17.431413
1894	1242	633	\N	\N	\N	2026-02-27 03:38:17.437171	2026-02-27 03:38:17.437171
1895	1219	635	\N	\N	\N	2026-02-27 03:38:17.463963	2026-02-27 03:38:17.463963
1896	1220	635	\N	\N	\N	2026-02-27 03:38:17.466131	2026-02-27 03:38:17.466131
1897	1221	635	\N	\N	\N	2026-02-27 03:38:17.468503	2026-02-27 03:38:17.468503
1898	1222	635	\N	\N	\N	2026-02-27 03:38:17.475746	2026-02-27 03:38:17.475746
1899	1243	635	\N	\N	\N	2026-02-27 03:38:17.48077	2026-02-27 03:38:17.48077
1900	1244	635	\N	\N	\N	2026-02-27 03:38:17.539143	2026-02-27 03:38:17.539143
1901	1141	635	\N	\N	\N	2026-02-27 03:38:17.542487	2026-02-27 03:38:17.542487
1902	1223	635	\N	\N	\N	2026-02-27 03:38:17.546643	2026-02-27 03:38:17.546643
1903	1245	635	\N	\N	\N	2026-02-27 03:38:17.552649	2026-02-27 03:38:17.552649
1904	1224	635	\N	\N	\N	2026-02-27 03:38:17.555546	2026-02-27 03:38:17.555546
1905	1246	636	\N	\N	\N	2026-02-27 03:38:17.578109	2026-02-27 03:38:17.578109
1906	1247	636	\N	\N	\N	2026-02-27 03:38:17.582587	2026-02-27 03:38:17.582587
1907	1248	636	\N	\N	\N	2026-02-27 03:38:17.635401	2026-02-27 03:38:17.635401
1908	1249	639	\N	\N	\N	2026-02-27 03:38:17.682758	2026-02-27 03:38:17.682758
1909	1250	639	\N	\N	\N	2026-02-27 03:38:17.688825	2026-02-27 03:38:17.688825
1910	1251	640	\N	\N	\N	2026-02-27 03:38:17.751337	2026-02-27 03:38:17.751337
1911	1252	640	\N	\N	\N	2026-02-27 03:38:17.757527	2026-02-27 03:38:17.757527
1912	1253	640	\N	\N	\N	2026-02-27 03:38:17.766743	2026-02-27 03:38:17.766743
1913	1189	644	\N	\N	\N	2026-02-27 03:38:17.889421	2026-02-27 03:38:17.889421
1914	1254	644	\N	\N	\N	2026-02-27 03:38:17.895769	2026-02-27 03:38:17.895769
1915	1255	644	\N	\N	\N	2026-02-27 03:38:17.901155	2026-02-27 03:38:17.901155
1916	1256	644	\N	\N	\N	2026-02-27 03:38:17.93323	2026-02-27 03:38:17.93323
1917	1257	645	\N	\N	\N	2026-02-27 03:38:17.950007	2026-02-27 03:38:17.950007
1918	1258	646	\N	\N	\N	2026-02-27 03:38:18.001266	2026-02-27 03:38:18.001266
1919	1259	646	\N	\N	\N	2026-02-27 03:38:18.043784	2026-02-27 03:38:18.043784
1920	214	647	\N	\N	\N	2026-02-27 03:38:18.118278	2026-02-27 03:38:18.118278
1921	1260	647	\N	\N	\N	2026-02-27 03:38:18.135945	2026-02-27 03:38:18.135945
1922	556	647	\N	\N	\N	2026-02-27 03:38:18.15679	2026-02-27 03:38:18.15679
1923	356	647	\N	\N	\N	2026-02-27 03:38:18.16996	2026-02-27 03:38:18.16996
1924	742	647	\N	\N	\N	2026-02-27 03:38:18.185116	2026-02-27 03:38:18.185116
1925	1261	647	\N	\N	\N	2026-02-27 03:38:18.206837	2026-02-27 03:38:18.206837
1926	1262	647	\N	\N	\N	2026-02-27 03:38:18.23077	2026-02-27 03:38:18.23077
1927	1263	647	\N	\N	\N	2026-02-27 03:38:18.24775	2026-02-27 03:38:18.24775
1928	1264	647	\N	\N	\N	2026-02-27 03:38:18.264038	2026-02-27 03:38:18.264038
1929	1215	648	\N	\N	\N	2026-02-27 03:38:18.322539	2026-02-27 03:38:18.322539
1930	1265	648	\N	\N	\N	2026-02-27 03:38:18.354908	2026-02-27 03:38:18.354908
1931	1116	648	\N	\N	\N	2026-02-27 03:38:18.375829	2026-02-27 03:38:18.375829
1932	556	648	\N	\N	\N	2026-02-27 03:38:18.390157	2026-02-27 03:38:18.390157
1933	1236	648	\N	\N	\N	2026-02-27 03:38:18.404122	2026-02-27 03:38:18.404122
1934	1266	648	\N	\N	\N	2026-02-27 03:38:18.431251	2026-02-27 03:38:18.431251
1935	1267	649	\N	\N	\N	2026-02-27 03:38:18.568412	2026-02-27 03:38:18.568412
1936	1268	649	\N	\N	\N	2026-02-27 03:38:18.586157	2026-02-27 03:38:18.586157
1937	1269	649	\N	\N	\N	2026-02-27 03:38:18.595453	2026-02-27 03:38:18.595453
1938	1195	649	\N	\N	\N	2026-02-27 03:38:18.602182	2026-02-27 03:38:18.602182
1939	1270	649	\N	\N	\N	2026-02-27 03:38:18.60888	2026-02-27 03:38:18.60888
1940	1271	649	\N	\N	\N	2026-02-27 03:38:18.6163	2026-02-27 03:38:18.6163
1941	1272	649	\N	\N	\N	2026-02-27 03:38:18.623754	2026-02-27 03:38:18.623754
1942	1273	649	\N	\N	\N	2026-02-27 03:38:18.629652	2026-02-27 03:38:18.629652
1943	1274	649	\N	\N	\N	2026-02-27 03:38:18.635421	2026-02-27 03:38:18.635421
1944	1275	649	\N	\N	\N	2026-02-27 03:38:18.644982	2026-02-27 03:38:18.644982
1945	1232	651	\N	\N	\N	2026-02-27 03:38:18.688405	2026-02-27 03:38:18.688405
1946	1276	651	\N	\N	\N	2026-02-27 03:38:18.696468	2026-02-27 03:38:18.696468
1947	1277	651	\N	\N	\N	2026-02-27 03:38:18.705744	2026-02-27 03:38:18.705744
1948	1278	651	\N	\N	\N	2026-02-27 03:38:18.735614	2026-02-27 03:38:18.735614
1949	1279	651	\N	\N	\N	2026-02-27 03:38:18.743964	2026-02-27 03:38:18.743964
1950	1280	652	\N	\N	\N	2026-02-27 03:38:19.031875	2026-02-27 03:38:19.031875
1951	1281	652	\N	\N	\N	2026-02-27 03:38:19.036304	2026-02-27 03:38:19.036304
1952	1282	652	\N	\N	\N	2026-02-27 03:38:19.0407	2026-02-27 03:38:19.0407
1953	1283	652	\N	\N	\N	2026-02-27 03:38:19.047427	2026-02-27 03:38:19.047427
1954	1284	653	\N	\N	\N	2026-02-27 03:38:19.253986	2026-02-27 03:38:19.253986
1955	1285	653	\N	\N	\N	2026-02-27 03:38:19.335434	2026-02-27 03:38:19.335434
1956	843	653	\N	\N	\N	2026-02-27 03:38:19.340734	2026-02-27 03:38:19.340734
1957	1195	653	\N	\N	\N	2026-02-27 03:38:19.345599	2026-02-27 03:38:19.345599
1958	1286	653	\N	\N	\N	2026-02-27 03:38:19.351116	2026-02-27 03:38:19.351116
1959	509	653	\N	\N	\N	2026-02-27 03:38:19.431019	2026-02-27 03:38:19.431019
1960	1287	653	\N	\N	\N	2026-02-27 03:38:19.437678	2026-02-27 03:38:19.437678
1961	256	653	\N	\N	\N	2026-02-27 03:38:19.442158	2026-02-27 03:38:19.442158
1962	1288	653	\N	\N	\N	2026-02-27 03:38:19.448567	2026-02-27 03:38:19.448567
1963	1148	654	\N	\N	\N	2026-02-27 03:38:19.541456	2026-02-27 03:38:19.541456
1964	1150	654	\N	\N	\N	2026-02-27 03:38:19.5445	2026-02-27 03:38:19.5445
1965	198	654	\N	\N	\N	2026-02-27 03:38:19.547312	2026-02-27 03:38:19.547312
1966	1289	654	\N	\N	\N	2026-02-27 03:38:19.552764	2026-02-27 03:38:19.552764
1967	1226	654	\N	\N	\N	2026-02-27 03:38:19.556186	2026-02-27 03:38:19.556186
1968	1290	654	\N	\N	\N	2026-02-27 03:38:19.561334	2026-02-27 03:38:19.561334
1969	1291	654	\N	\N	\N	2026-02-27 03:38:19.565837	2026-02-27 03:38:19.565837
1970	1292	654	\N	\N	\N	2026-02-27 03:38:19.570697	2026-02-27 03:38:19.570697
1971	1163	654	\N	\N	\N	2026-02-27 03:38:19.573394	2026-02-27 03:38:19.573394
1972	150	654	\N	\N	\N	2026-02-27 03:38:19.57627	2026-02-27 03:38:19.57627
1973	1293	654	\N	\N	\N	2026-02-27 03:38:19.634945	2026-02-27 03:38:19.634945
1974	1294	654	\N	\N	\N	2026-02-27 03:38:19.638776	2026-02-27 03:38:19.638776
1975	1295	654	\N	\N	\N	2026-02-27 03:38:19.649489	2026-02-27 03:38:19.649489
1976	1296	654	\N	\N	\N	2026-02-27 03:38:19.654366	2026-02-27 03:38:19.654366
1977	1297	654	\N	\N	\N	2026-02-27 03:38:19.658406	2026-02-27 03:38:19.658406
1978	1298	654	\N	\N	\N	2026-02-27 03:38:19.66236	2026-02-27 03:38:19.66236
1979	1230	654	\N	\N	\N	2026-02-27 03:38:19.664705	2026-02-27 03:38:19.664705
1980	190	654	\N	\N	\N	2026-02-27 03:38:19.700789	2026-02-27 03:38:19.700789
1981	1229	654	\N	\N	\N	2026-02-27 03:38:19.703712	2026-02-27 03:38:19.703712
1982	1299	654	\N	\N	\N	2026-02-27 03:38:19.749713	2026-02-27 03:38:19.749713
1983	1300	654	\N	\N	\N	2026-02-27 03:38:19.754287	2026-02-27 03:38:19.754287
1984	96	654	\N	\N	\N	2026-02-27 03:38:19.756878	2026-02-27 03:38:19.756878
1985	1116	654	\N	\N	\N	2026-02-27 03:38:19.760299	2026-02-27 03:38:19.760299
1986	1155	654	\N	\N	\N	2026-02-27 03:38:19.762687	2026-02-27 03:38:19.762687
1987	1119	654	\N	\N	\N	2026-02-27 03:38:19.765088	2026-02-27 03:38:19.765088
1988	244	654	\N	\N	\N	2026-02-27 03:38:19.767551	2026-02-27 03:38:19.767551
1989	1301	655	\N	\N	\N	2026-02-27 03:38:19.781792	2026-02-27 03:38:19.781792
1990	1302	656	\N	\N	\N	2026-02-27 03:38:19.796234	2026-02-27 03:38:19.796234
1991	155	657	\N	\N	\N	2026-02-27 03:38:19.843854	2026-02-27 03:38:19.843854
1992	1303	657	\N	\N	\N	2026-02-27 03:38:19.84892	2026-02-27 03:38:19.84892
1993	1304	661	\N	\N	\N	2026-02-27 03:38:19.947127	2026-02-27 03:38:19.947127
1994	1305	661	\N	\N	\N	2026-02-27 03:38:19.953623	2026-02-27 03:38:19.953623
1995	1171	661	\N	\N	\N	2026-02-27 03:38:19.961529	2026-02-27 03:38:19.961529
1996	1306	663	\N	\N	\N	2026-02-27 03:38:20.002037	2026-02-27 03:38:20.002037
1997	1307	664	\N	\N	\N	2026-02-27 03:38:20.046839	2026-02-27 03:38:20.046839
1998	1308	664	\N	\N	\N	2026-02-27 03:38:20.053021	2026-02-27 03:38:20.053021
1999	1309	665	\N	\N	\N	2026-02-27 03:38:20.06553	2026-02-27 03:38:20.06553
2000	1310	666	\N	\N	\N	2026-02-27 03:38:20.138037	2026-02-27 03:38:20.138037
2001	1311	666	\N	\N	\N	2026-02-27 03:38:20.145585	2026-02-27 03:38:20.145585
2002	1135	667	\N	\N	\N	2026-02-27 03:38:20.157006	2026-02-27 03:38:20.157006
2003	1312	667	\N	\N	\N	2026-02-27 03:38:20.163594	2026-02-27 03:38:20.163594
2004	1313	667	\N	\N	\N	2026-02-27 03:38:20.17307	2026-02-27 03:38:20.17307
2005	1314	667	\N	\N	\N	2026-02-27 03:38:20.180121	2026-02-27 03:38:20.180121
2006	1315	668	\N	\N	\N	2026-02-27 03:38:20.238083	2026-02-27 03:38:20.238083
2007	130	668	\N	\N	\N	2026-02-27 03:38:20.24183	2026-02-27 03:38:20.24183
2008	1316	668	\N	\N	\N	2026-02-27 03:38:20.247635	2026-02-27 03:38:20.247635
2009	1317	668	\N	\N	\N	2026-02-27 03:38:20.251548	2026-02-27 03:38:20.251548
2010	1318	669	\N	\N	\N	2026-02-27 03:38:20.273096	2026-02-27 03:38:20.273096
2011	1319	669	\N	\N	\N	2026-02-27 03:38:20.282611	2026-02-27 03:38:20.282611
2012	1320	669	\N	\N	\N	2026-02-27 03:38:20.331534	2026-02-27 03:38:20.331534
2013	1321	669	\N	\N	\N	2026-02-27 03:38:20.336603	2026-02-27 03:38:20.336603
2014	1322	669	\N	\N	\N	2026-02-27 03:38:20.340928	2026-02-27 03:38:20.340928
2015	1323	671	\N	\N	\N	2026-02-27 03:38:20.541864	2026-02-27 03:38:20.541864
2016	1156	673	\N	\N	\N	2026-02-27 03:38:20.563236	2026-02-27 03:38:20.563236
2017	1324	673	\N	\N	\N	2026-02-27 03:38:20.569	2026-02-27 03:38:20.569
2018	1225	673	\N	\N	\N	2026-02-27 03:38:20.572029	2026-02-27 03:38:20.572029
2019	1325	673	\N	\N	\N	2026-02-27 03:38:20.579943	2026-02-27 03:38:20.579943
2020	1326	673	\N	\N	\N	2026-02-27 03:38:20.586146	2026-02-27 03:38:20.586146
2021	1327	673	\N	\N	\N	2026-02-27 03:38:20.637186	2026-02-27 03:38:20.637186
2022	1125	673	\N	\N	\N	2026-02-27 03:38:20.643569	2026-02-27 03:38:20.643569
2023	1170	673	\N	\N	\N	2026-02-27 03:38:20.648815	2026-02-27 03:38:20.648815
2024	1127	673	\N	\N	\N	2026-02-27 03:38:20.657605	2026-02-27 03:38:20.657605
2025	1164	673	\N	\N	\N	2026-02-27 03:38:20.661087	2026-02-27 03:38:20.661087
2026	1143	673	\N	\N	\N	2026-02-27 03:38:20.672156	2026-02-27 03:38:20.672156
2027	1328	673	\N	\N	\N	2026-02-27 03:38:20.680355	2026-02-27 03:38:20.680355
2028	1223	673	\N	\N	\N	2026-02-27 03:38:20.687171	2026-02-27 03:38:20.687171
2029	1329	673	\N	\N	\N	2026-02-27 03:38:20.697648	2026-02-27 03:38:20.697648
2030	1157	673	\N	\N	\N	2026-02-27 03:38:20.733767	2026-02-27 03:38:20.733767
2031	1330	673	\N	\N	\N	2026-02-27 03:38:20.738637	2026-02-27 03:38:20.738637
2032	1331	673	\N	\N	\N	2026-02-27 03:38:20.743919	2026-02-27 03:38:20.743919
2033	1114	673	\N	\N	\N	2026-02-27 03:38:20.747552	2026-02-27 03:38:20.747552
2034	1113	673	\N	\N	\N	2026-02-27 03:38:20.750102	2026-02-27 03:38:20.750102
2035	1305	673	\N	\N	\N	2026-02-27 03:38:20.752998	2026-02-27 03:38:20.752998
2036	1332	673	\N	\N	\N	2026-02-27 03:38:20.757667	2026-02-27 03:38:20.757667
2037	1137	675	\N	\N	\N	2026-02-27 03:38:20.846625	2026-02-27 03:38:20.846625
2038	256	675	\N	\N	\N	2026-02-27 03:38:20.848998	2026-02-27 03:38:20.848998
2039	1333	676	\N	\N	\N	2026-02-27 03:38:20.865154	2026-02-27 03:38:20.865154
2040	1334	676	\N	\N	\N	2026-02-27 03:38:20.869474	2026-02-27 03:38:20.869474
2041	1335	678	\N	\N	\N	2026-02-27 03:38:20.950479	2026-02-27 03:38:20.950479
2042	1335	679	\N	\N	\N	2026-02-27 03:38:20.964015	2026-02-27 03:38:20.964015
2043	1336	680	\N	\N	\N	2026-02-27 03:38:20.982982	2026-02-27 03:38:20.982982
2044	1337	681	\N	\N	\N	2026-02-27 03:38:21.043114	2026-02-27 03:38:21.043114
2045	1338	681	\N	\N	\N	2026-02-27 03:38:21.051233	2026-02-27 03:38:21.051233
2046	1339	682	\N	\N	\N	2026-02-27 03:38:21.069151	2026-02-27 03:38:21.069151
2047	1340	682	\N	\N	\N	2026-02-27 03:38:21.073825	2026-02-27 03:38:21.073825
2048	1341	683	\N	\N	\N	2026-02-27 03:38:21.144152	2026-02-27 03:38:21.144152
2049	1342	683	\N	\N	\N	2026-02-27 03:38:21.148535	2026-02-27 03:38:21.148535
2050	1343	683	\N	\N	\N	2026-02-27 03:38:21.15333	2026-02-27 03:38:21.15333
2051	1344	683	\N	\N	\N	2026-02-27 03:38:21.158266	2026-02-27 03:38:21.158266
2052	1345	683	\N	\N	\N	2026-02-27 03:38:21.164019	2026-02-27 03:38:21.164019
2053	1346	683	\N	\N	\N	2026-02-27 03:38:21.16906	2026-02-27 03:38:21.16906
2054	1347	683	\N	\N	\N	2026-02-27 03:38:21.174008	2026-02-27 03:38:21.174008
2055	1348	683	\N	\N	\N	2026-02-27 03:38:21.233408	2026-02-27 03:38:21.233408
2056	1349	685	\N	\N	\N	2026-02-27 03:38:21.267921	2026-02-27 03:38:21.267921
2057	1163	690	\N	\N	\N	2026-02-27 03:38:21.360678	2026-02-27 03:38:21.360678
2058	1350	690	\N	\N	\N	2026-02-27 03:38:21.364649	2026-02-27 03:38:21.364649
2059	255	690	\N	\N	\N	2026-02-27 03:38:21.367316	2026-02-27 03:38:21.367316
2060	1235	690	\N	\N	\N	2026-02-27 03:38:21.369574	2026-02-27 03:38:21.369574
2061	1351	690	\N	\N	\N	2026-02-27 03:38:21.435504	2026-02-27 03:38:21.435504
2062	1352	690	\N	\N	\N	2026-02-27 03:38:21.441738	2026-02-27 03:38:21.441738
2063	1353	693	\N	\N	\N	2026-02-27 03:38:21.532502	2026-02-27 03:38:21.532502
2064	1354	693	\N	\N	\N	2026-02-27 03:38:21.540891	2026-02-27 03:38:21.540891
2065	1301	693	\N	\N	\N	2026-02-27 03:38:21.544773	2026-02-27 03:38:21.544773
2066	1355	693	\N	\N	\N	2026-02-27 03:38:21.554532	2026-02-27 03:38:21.554532
2067	1199	693	\N	\N	\N	2026-02-27 03:38:21.557873	2026-02-27 03:38:21.557873
2068	196	693	\N	\N	\N	2026-02-27 03:38:21.561411	2026-02-27 03:38:21.561411
2069	213	693	\N	\N	\N	2026-02-27 03:38:21.568169	2026-02-27 03:38:21.568169
2070	1356	693	\N	\N	\N	2026-02-27 03:38:21.578131	2026-02-27 03:38:21.578131
2071	1357	693	\N	\N	\N	2026-02-27 03:38:21.585337	2026-02-27 03:38:21.585337
2072	1358	693	\N	\N	\N	2026-02-27 03:38:21.593595	2026-02-27 03:38:21.593595
2073	1145	693	\N	\N	\N	2026-02-27 03:38:21.634015	2026-02-27 03:38:21.634015
2074	1146	693	\N	\N	\N	2026-02-27 03:38:21.637314	2026-02-27 03:38:21.637314
2075	1144	693	\N	\N	\N	2026-02-27 03:38:21.640132	2026-02-27 03:38:21.640132
2076	271	693	\N	\N	\N	2026-02-27 03:38:21.642653	2026-02-27 03:38:21.642653
2077	1359	693	\N	\N	\N	2026-02-27 03:38:21.647443	2026-02-27 03:38:21.647443
2078	1319	693	\N	\N	\N	2026-02-27 03:38:21.650437	2026-02-27 03:38:21.650437
2079	54	693	\N	\N	\N	2026-02-27 03:38:21.653441	2026-02-27 03:38:21.653441
2080	1360	693	\N	\N	\N	2026-02-27 03:38:21.65837	2026-02-27 03:38:21.65837
2081	1236	693	\N	\N	\N	2026-02-27 03:38:21.661389	2026-02-27 03:38:21.661389
2082	1361	693	\N	\N	\N	2026-02-27 03:38:21.66606	2026-02-27 03:38:21.66606
2083	1362	693	\N	\N	\N	2026-02-27 03:38:21.670279	2026-02-27 03:38:21.670279
2084	1273	693	\N	\N	\N	2026-02-27 03:38:21.672947	2026-02-27 03:38:21.672947
2085	1213	693	\N	\N	\N	2026-02-27 03:38:21.732698	2026-02-27 03:38:21.732698
2086	1363	693	\N	\N	\N	2026-02-27 03:38:21.737141	2026-02-27 03:38:21.737141
2087	1289	693	\N	\N	\N	2026-02-27 03:38:21.739514	2026-02-27 03:38:21.739514
2088	1364	693	\N	\N	\N	2026-02-27 03:38:21.743439	2026-02-27 03:38:21.743439
2089	1181	693	\N	\N	\N	2026-02-27 03:38:21.745623	2026-02-27 03:38:21.745623
2090	1365	693	\N	\N	\N	2026-02-27 03:38:21.749534	2026-02-27 03:38:21.749534
2091	1366	693	\N	\N	\N	2026-02-27 03:38:21.753261	2026-02-27 03:38:21.753261
2092	1367	693	\N	\N	\N	2026-02-27 03:38:21.757366	2026-02-27 03:38:21.757366
2093	1368	693	\N	\N	\N	2026-02-27 03:38:21.76087	2026-02-27 03:38:21.76087
2094	1369	694	\N	\N	\N	2026-02-27 03:38:21.845118	2026-02-27 03:38:21.845118
2095	1370	694	\N	\N	\N	2026-02-27 03:38:21.855718	2026-02-27 03:38:21.855718
2096	1371	694	\N	\N	\N	2026-02-27 03:38:21.862733	2026-02-27 03:38:21.862733
2097	1291	696	\N	\N	\N	2026-02-27 03:38:21.901893	2026-02-27 03:38:21.901893
2099	1373	704	\N	\N	\N	2026-02-27 03:38:22.144317	2026-02-27 03:38:22.144317
2100	1374	706	\N	\N	\N	2026-02-27 03:38:22.164347	2026-02-27 03:38:22.164347
2101	1259	706	\N	\N	\N	2026-02-27 03:38:22.16709	2026-02-27 03:38:22.16709
2102	1375	706	\N	\N	\N	2026-02-27 03:38:22.171713	2026-02-27 03:38:22.171713
2161	105	709	\N	\N	\N	2026-03-02 20:31:24.983794	2026-03-02 20:31:24.983794
2162	1425	709	\N	\N	\N	2026-03-02 20:31:25.038412	2026-03-02 20:31:25.038412
2163	1426	709	\N	\N	\N	2026-03-02 20:31:25.052964	2026-03-02 20:31:25.052964
2164	403	709	\N	\N	\N	2026-03-02 20:31:25.059933	2026-03-02 20:31:25.059933
2103	1376	619	\N	\N	\N	2026-02-27 05:42:42.47399	2026-02-27 05:42:42.47399
2104	1377	619	\N	\N	\N	2026-02-27 05:42:42.483263	2026-02-27 05:42:42.483263
2105	452	619	\N	\N	\N	2026-02-27 05:42:42.4895	2026-02-27 05:42:42.4895
2106	1378	619	\N	\N	\N	2026-02-27 05:42:42.499315	2026-02-27 05:42:42.499315
2107	1379	619	\N	\N	\N	2026-02-27 05:42:42.506219	2026-02-27 05:42:42.506219
2108	1380	619	\N	\N	\N	2026-02-27 05:42:42.514098	2026-02-27 05:42:42.514098
2109	1381	619	\N	\N	\N	2026-02-27 05:42:42.523959	2026-02-27 05:42:42.523959
2110	1382	605	\N	\N	\N	2026-02-27 05:49:32.365989	2026-02-27 05:49:32.365989
2111	1383	605	\N	\N	\N	2026-02-27 05:49:32.37463	2026-02-27 05:49:32.37463
2112	1384	605	\N	\N	\N	2026-02-27 05:49:32.380983	2026-02-27 05:49:32.380983
2113	1385	605	\N	\N	\N	2026-02-27 05:49:32.38887	2026-02-27 05:49:32.38887
2114	1386	605	\N	\N	\N	2026-02-27 05:49:32.396016	2026-02-27 05:49:32.396016
2115	1387	605	\N	\N	\N	2026-02-27 05:49:32.402133	2026-02-27 05:49:32.402133
2116	656	602	\N	\N	\N	2026-02-27 05:52:51.471975	2026-02-27 05:52:51.471975
2165	675	712	\N	\N	\N	2026-03-03 06:50:09.55814	2026-03-03 06:50:09.55814
2166	155	712	\N	\N	\N	2026-03-03 06:50:09.567273	2026-03-03 06:50:09.567273
2167	545	712	\N	\N	\N	2026-03-03 06:50:09.572759	2026-03-03 06:50:09.572759
2168	1106	712	\N	\N	\N	2026-03-03 06:50:09.576458	2026-03-03 06:50:09.576458
2169	1358	712	\N	\N	\N	2026-03-03 06:50:09.580852	2026-03-03 06:50:09.580852
2170	1427	713	\N	\N	\N	2026-03-03 06:50:09.811469	2026-03-03 06:50:09.811469
2171	1428	713	\N	\N	\N	2026-03-03 06:50:09.83258	2026-03-03 06:50:09.83258
2172	1207	714	\N	\N	\N	2026-03-03 06:50:09.905911	2026-03-03 06:50:09.905911
2173	1429	714	\N	\N	\N	2026-03-03 06:50:09.912798	2026-03-03 06:50:09.912798
2174	1430	714	\N	\N	\N	2026-03-03 06:50:09.933428	2026-03-03 06:50:09.933428
2175	1417	714	\N	\N	\N	2026-03-03 06:50:09.935938	2026-03-03 06:50:09.935938
2176	1431	714	\N	\N	\N	2026-03-03 06:50:09.954043	2026-03-03 06:50:09.954043
2177	1432	714	\N	\N	\N	2026-03-03 06:50:09.960405	2026-03-03 06:50:09.960405
2178	1433	714	\N	\N	\N	2026-03-03 06:50:09.965662	2026-03-03 06:50:09.965662
2179	1434	627	\N	\N	\N	2026-03-03 06:50:10.374776	2026-03-03 06:50:10.374776
2180	1136	715	\N	\N	\N	2026-03-03 06:50:10.773923	2026-03-03 06:50:10.773923
2181	1375	715	\N	\N	\N	2026-03-03 06:50:10.777419	2026-03-03 06:50:10.777419
2182	1435	716	\N	\N	\N	2026-03-03 06:50:10.945314	2026-03-03 06:50:10.945314
2183	96	716	\N	\N	\N	2026-03-03 06:50:10.948651	2026-03-03 06:50:10.948651
2184	1436	716	\N	\N	\N	2026-03-03 06:50:10.956158	2026-03-03 06:50:10.956158
2185	1437	716	\N	\N	\N	2026-03-03 06:50:10.962681	2026-03-03 06:50:10.962681
2186	1126	716	\N	\N	\N	2026-03-03 06:50:10.966299	2026-03-03 06:50:10.966299
2187	1438	716	\N	\N	\N	2026-03-03 06:50:10.970772	2026-03-03 06:50:10.970772
2188	1439	716	\N	\N	\N	2026-03-03 06:50:10.974929	2026-03-03 06:50:10.974929
2189	1440	716	\N	\N	\N	2026-03-03 06:50:10.97992	2026-03-03 06:50:10.97992
2190	1441	716	\N	\N	\N	2026-03-03 06:50:10.987141	2026-03-03 06:50:10.987141
2191	728	716	\N	\N	\N	2026-03-03 06:50:11.034348	2026-03-03 06:50:11.034348
2192	564	716	\N	\N	\N	2026-03-03 06:50:11.037989	2026-03-03 06:50:11.037989
2193	1155	716	\N	\N	\N	2026-03-03 06:50:11.131961	2026-03-03 06:50:11.131961
2194	1442	716	\N	\N	\N	2026-03-03 06:50:11.136688	2026-03-03 06:50:11.136688
2195	200	716	\N	\N	\N	2026-03-03 06:50:11.139989	2026-03-03 06:50:11.139989
2196	621	716	\N	\N	\N	2026-03-03 06:50:11.142067	2026-03-03 06:50:11.142067
2197	1443	716	\N	\N	\N	2026-03-03 06:50:11.146266	2026-03-03 06:50:11.146266
2198	244	716	\N	\N	\N	2026-03-03 06:50:11.148748	2026-03-03 06:50:11.148748
2199	1444	716	\N	\N	\N	2026-03-03 06:50:11.152926	2026-03-03 06:50:11.152926
2200	1445	716	\N	\N	\N	2026-03-03 06:50:11.156608	2026-03-03 06:50:11.156608
2201	1446	717	\N	\N	\N	2026-03-03 06:50:11.340305	2026-03-03 06:50:11.340305
2202	1447	717	\N	\N	\N	2026-03-03 06:50:11.345435	2026-03-03 06:50:11.345435
2203	1201	717	\N	\N	\N	2026-03-03 06:50:11.347824	2026-03-03 06:50:11.347824
2204	1210	717	\N	\N	\N	2026-03-03 06:50:11.351124	2026-03-03 06:50:11.351124
2205	1448	717	\N	\N	\N	2026-03-03 06:50:11.355466	2026-03-03 06:50:11.355466
2206	1449	718	\N	\N	\N	2026-03-03 06:50:11.376464	2026-03-03 06:50:11.376464
2207	1139	655	\N	\N	\N	2026-03-03 06:50:11.770556	2026-03-03 06:50:11.770556
2208	1357	655	\N	\N	\N	2026-03-03 06:50:11.773416	2026-03-03 06:50:11.773416
2209	1375	655	\N	\N	\N	2026-03-03 06:50:11.776589	2026-03-03 06:50:11.776589
2210	1337	719	\N	\N	\N	2026-03-03 06:50:11.986786	2026-03-03 06:50:11.986786
2211	94	719	\N	\N	\N	2026-03-03 06:50:11.990216	2026-03-03 06:50:11.990216
2212	1450	719	\N	\N	\N	2026-03-03 06:50:12.034187	2026-03-03 06:50:12.034187
2213	1451	720	\N	\N	\N	2026-03-03 06:50:12.186114	2026-03-03 06:50:12.186114
2214	1452	720	\N	\N	\N	2026-03-03 06:50:12.230915	2026-03-03 06:50:12.230915
2215	1453	720	\N	\N	\N	2026-03-03 06:50:12.237589	2026-03-03 06:50:12.237589
2216	1454	721	\N	\N	\N	2026-03-03 06:50:12.87501	2026-03-03 06:50:12.87501
2217	1455	721	\N	\N	\N	2026-03-03 06:50:12.879226	2026-03-03 06:50:12.879226
2218	1456	721	\N	\N	\N	2026-03-03 06:50:12.88581	2026-03-03 06:50:12.88581
2219	1457	723	\N	\N	\N	2026-03-03 06:50:13.639939	2026-03-03 06:50:13.639939
2220	1458	723	\N	\N	\N	2026-03-03 06:50:13.644458	2026-03-03 06:50:13.644458
2221	1459	723	\N	\N	\N	2026-03-03 06:50:13.735997	2026-03-03 06:50:13.735997
2222	1460	723	\N	\N	\N	2026-03-03 06:50:13.835395	2026-03-03 06:50:13.835395
2223	1332	723	\N	\N	\N	2026-03-03 06:50:13.931814	2026-03-03 06:50:13.931814
2117	1388	579	\N	\N	\N	2026-02-27 20:31:21.921173	2026-02-27 20:31:21.921173
2118	717	587	\N	\N	\N	2026-02-27 20:31:22.374558	2026-02-27 20:31:22.374558
2119	1389	587	\N	\N	\N	2026-02-27 20:31:22.396524	2026-02-27 20:31:22.396524
2120	86	587	\N	\N	\N	2026-02-27 20:31:22.40936	2026-02-27 20:31:22.40936
2224	552	724	\N	\N	\N	2026-03-03 20:31:25.548915	2026-03-03 20:31:25.548915
2225	620	724	\N	\N	\N	2026-03-03 20:31:25.561733	2026-03-03 20:31:25.561733
2226	625	724	\N	\N	\N	2026-03-03 20:31:25.571162	2026-03-03 20:31:25.571162
2227	1461	724	\N	\N	\N	2026-03-03 20:31:25.590528	2026-03-03 20:31:25.590528
2228	1462	724	\N	\N	\N	2026-03-03 20:31:25.624526	2026-03-03 20:31:25.624526
2229	728	724	\N	\N	\N	2026-03-03 20:31:25.628292	2026-03-03 20:31:25.628292
2230	727	724	\N	\N	\N	2026-03-03 20:31:25.631412	2026-03-03 20:31:25.631412
2121	1390	633	\N	\N	\N	2026-02-27 23:12:03.323587	2026-02-27 23:12:03.323587
2231	1463	592	\N	\N	\N	2026-03-05 20:31:18.572849	2026-03-05 20:31:18.572849
2232	1464	592	\N	\N	\N	2026-03-05 20:31:18.584386	2026-03-05 20:31:18.584386
2233	526	592	\N	\N	\N	2026-03-05 20:31:18.588855	2026-03-05 20:31:18.588855
2234	166	592	\N	\N	\N	2026-03-05 20:31:18.592295	2026-03-05 20:31:18.592295
2235	1465	592	\N	\N	\N	2026-03-05 20:31:18.598588	2026-03-05 20:31:18.598588
2236	545	592	\N	\N	\N	2026-03-05 20:31:18.603677	2026-03-05 20:31:18.603677
2237	337	592	\N	\N	\N	2026-03-05 20:31:18.631939	2026-03-05 20:31:18.631939
2238	620	592	\N	\N	\N	2026-03-05 20:31:18.636366	2026-03-05 20:31:18.636366
2239	625	592	\N	\N	\N	2026-03-05 20:31:18.639692	2026-03-05 20:31:18.639692
2240	1466	592	\N	\N	\N	2026-03-05 20:31:18.646155	2026-03-05 20:31:18.646155
2241	1467	592	\N	\N	\N	2026-03-05 20:31:18.652873	2026-03-05 20:31:18.652873
2122	1391	645	\N	\N	\N	2026-02-28 02:37:48.930928	2026-02-28 02:37:48.930928
2123	1392	645	\N	\N	\N	2026-02-28 02:37:49.131586	2026-02-28 02:37:49.131586
2124	1393	645	\N	\N	\N	2026-02-28 02:37:49.143635	2026-02-28 02:37:49.143635
2125	1394	645	\N	\N	\N	2026-02-28 02:37:49.152563	2026-02-28 02:37:49.152563
2126	1395	645	\N	\N	\N	2026-02-28 02:37:49.160814	2026-02-28 02:37:49.160814
2242	1409	656	\N	\N	\N	2026-03-06 11:51:05.598448	2026-03-06 11:51:05.598448
2243	1408	656	\N	\N	\N	2026-03-06 11:51:05.605771	2026-03-06 11:51:05.605771
2244	1468	656	\N	\N	\N	2026-03-06 11:51:05.614928	2026-03-06 11:51:05.614928
2245	1469	656	\N	\N	\N	2026-03-06 11:51:05.622906	2026-03-06 11:51:05.622906
2246	1470	656	\N	\N	\N	2026-03-06 11:51:05.637736	2026-03-06 11:51:05.637736
2247	1471	656	\N	\N	\N	2026-03-06 11:51:05.646077	2026-03-06 11:51:05.646077
2248	1472	672	\N	\N	\N	2026-03-06 11:59:13.135192	2026-03-06 11:59:13.135192
2249	1473	672	\N	\N	\N	2026-03-06 11:59:13.24277	2026-03-06 11:59:13.24277
2250	1474	672	\N	\N	\N	2026-03-06 11:59:13.33555	2026-03-06 11:59:13.33555
2251	1475	672	\N	\N	\N	2026-03-06 11:59:13.34478	2026-03-06 11:59:13.34478
2252	1476	672	\N	\N	\N	2026-03-06 11:59:13.429289	2026-03-06 11:59:13.429289
2253	1477	672	\N	\N	\N	2026-03-06 11:59:13.440705	2026-03-06 11:59:13.440705
2254	1478	672	\N	\N	\N	2026-03-06 11:59:13.631264	2026-03-06 11:59:13.631264
2255	1479	672	\N	\N	\N	2026-03-06 11:59:13.730799	2026-03-06 11:59:13.730799
2256	1480	722	\N	\N	\N	2026-03-06 12:04:08.153392	2026-03-06 12:04:08.153392
2257	1481	722	\N	\N	\N	2026-03-06 12:04:08.164264	2026-03-06 12:04:08.164264
2258	1482	722	\N	\N	\N	2026-03-06 12:04:08.172086	2026-03-06 12:04:08.172086
2259	1483	722	\N	\N	\N	2026-03-06 12:04:08.180036	2026-03-06 12:04:08.180036
2260	1484	722	\N	\N	\N	2026-03-06 12:04:08.188642	2026-03-06 12:04:08.188642
2261	431	704	\N	\N	\N	2026-03-06 12:08:51.362079	2026-03-06 12:08:51.362079
2262	1485	704	\N	\N	\N	2026-03-06 12:08:51.364229	2026-03-06 12:08:51.364229
2263	1486	704	\N	\N	\N	2026-03-06 12:08:51.365553	2026-03-06 12:08:51.365553
2127	1124	637	\N	\N	\N	2026-02-28 03:43:04.794378	2026-02-28 03:43:04.794378
2264	826	726	\N	\N	\N	2026-03-06 20:31:31.086	2026-03-06 20:31:31.086
2265	1487	726	\N	\N	\N	2026-03-06 20:31:31.168815	2026-03-06 20:31:31.168815
2266	325	726	\N	\N	\N	2026-03-06 20:31:31.183572	2026-03-06 20:31:31.183572
2267	1488	726	\N	\N	\N	2026-03-06 20:31:31.239917	2026-03-06 20:31:31.239917
2268	93	726	\N	\N	\N	2026-03-06 20:31:31.25198	2026-03-06 20:31:31.25198
2269	717	571	\N	\N	\N	2026-03-06 20:31:31.372272	2026-03-06 20:31:31.372272
2270	1489	571	\N	\N	\N	2026-03-06 20:31:31.382872	2026-03-06 20:31:31.382872
2271	1490	571	\N	\N	\N	2026-03-06 20:31:31.433276	2026-03-06 20:31:31.433276
2272	221	571	\N	\N	\N	2026-03-06 20:31:31.44223	2026-03-06 20:31:31.44223
2273	1491	571	\N	\N	\N	2026-03-06 20:31:31.46136	2026-03-06 20:31:31.46136
2274	1492	571	\N	\N	\N	2026-03-06 20:31:31.530386	2026-03-06 20:31:31.530386
2275	1493	571	\N	\N	\N	2026-03-06 20:31:31.540007	2026-03-06 20:31:31.540007
2276	718	571	\N	\N	\N	2026-03-06 20:31:31.545497	2026-03-06 20:31:31.545497
2277	14	579	\N	\N	\N	2026-03-06 20:31:31.980089	2026-03-06 20:31:31.980089
2278	157	579	\N	\N	\N	2026-03-06 20:31:31.987832	2026-03-06 20:31:31.987832
2279	1494	579	\N	\N	\N	2026-03-06 20:31:32.040875	2026-03-06 20:31:32.040875
2280	617	592	\N	\N	\N	2026-03-06 20:31:32.810143	2026-03-06 20:31:32.810143
2128	1366	662	\N	\N	\N	2026-02-28 03:58:04.83823	2026-02-28 03:58:04.83823
2129	1396	662	\N	\N	\N	2026-02-28 03:58:04.913374	2026-02-28 03:58:04.913374
2130	1397	662	\N	\N	\N	2026-02-28 03:58:04.959894	2026-02-28 03:58:04.959894
2281	252	728	\N	\N	\N	2026-03-07 20:31:30.000275	2026-03-07 20:31:30.000275
2282	253	728	\N	\N	\N	2026-03-07 20:31:30.010014	2026-03-07 20:31:30.010014
2283	251	728	\N	\N	\N	2026-03-07 20:31:30.049891	2026-03-07 20:31:30.049891
1524	8	568	\N	\N	\N	2026-02-26 04:13:36.216689	2026-02-26 04:13:36.216689
1525	9	568	\N	\N	\N	2026-02-26 04:13:36.274241	2026-02-26 04:13:36.274241
1526	1053	568	\N	\N	\N	2026-02-26 04:13:36.292485	2026-02-26 04:13:36.292485
1527	13	568	\N	\N	\N	2026-02-26 04:13:36.299087	2026-02-26 04:13:36.299087
1528	1054	568	\N	\N	\N	2026-02-26 04:13:36.318714	2026-02-26 04:13:36.318714
1529	1055	568	\N	\N	\N	2026-02-26 04:13:36.389419	2026-02-26 04:13:36.389419
1530	679	568	\N	\N	\N	2026-02-26 04:13:36.399552	2026-02-26 04:13:36.399552
1572	1056	573	\N	\N	\N	2026-02-26 04:13:37.368491	2026-02-26 04:13:37.368491
1573	50	573	\N	\N	\N	2026-02-26 04:13:37.372785	2026-02-26 04:13:37.372785
2131	1398	687	\N	\N	\N	2026-02-28 04:39:26.232935	2026-02-28 04:39:26.232935
2132	1399	677	\N	\N	\N	2026-02-28 04:50:11.632326	2026-02-28 04:50:11.632326
2133	1400	677	\N	\N	\N	2026-02-28 04:50:11.639059	2026-02-28 04:50:11.639059
2134	631	689	\N	\N	\N	2026-02-28 04:57:28.006308	2026-02-28 04:57:28.006308
2135	1401	689	\N	\N	\N	2026-02-28 04:57:28.017081	2026-02-28 04:57:28.017081
2136	1402	689	\N	\N	\N	2026-02-28 04:57:28.028484	2026-02-28 04:57:28.028484
2137	1403	689	\N	\N	\N	2026-02-28 04:57:28.035358	2026-02-28 04:57:28.035358
2138	1404	689	\N	\N	\N	2026-02-28 04:57:28.040253	2026-02-28 04:57:28.040253
2139	1405	674	\N	\N	\N	2026-02-28 05:10:03.468796	2026-02-28 05:10:03.468796
2140	1406	697	\N	\N	\N	2026-02-28 05:18:05.704677	2026-02-28 05:18:05.704677
2284	1495	729	\N	\N	\N	2026-03-08 20:31:31.080108	2026-03-08 20:31:31.080108
2285	96	729	\N	\N	\N	2026-03-08 20:31:31.087531	2026-03-08 20:31:31.087531
2286	145	729	\N	\N	\N	2026-03-08 20:31:31.09174	2026-03-08 20:31:31.09174
2287	1496	729	\N	\N	\N	2026-03-08 20:31:31.0975	2026-03-08 20:31:31.0975
2288	37	729	\N	\N	\N	2026-03-08 20:31:31.100672	2026-03-08 20:31:31.100672
2289	219	729	\N	\N	\N	2026-03-08 20:31:31.105308	2026-03-08 20:31:31.105308
2290	1497	729	\N	\N	\N	2026-03-08 20:31:31.10983	2026-03-08 20:31:31.10983
2291	628	729	\N	\N	\N	2026-03-08 20:31:31.114368	2026-03-08 20:31:31.114368
2292	1498	729	\N	\N	\N	2026-03-08 20:31:31.120938	2026-03-08 20:31:31.120938
2293	1499	729	\N	\N	\N	2026-03-08 20:31:31.131943	2026-03-08 20:31:31.131943
2294	1445	729	\N	\N	\N	2026-03-08 20:31:31.133974	2026-03-08 20:31:31.133974
2295	365	729	\N	\N	\N	2026-03-08 20:31:31.136409	2026-03-08 20:31:31.136409
2296	1500	729	\N	\N	\N	2026-03-08 20:31:31.141355	2026-03-08 20:31:31.141355
2297	103	729	\N	\N	\N	2026-03-08 20:31:31.176408	2026-03-08 20:31:31.176408
2298	1501	729	\N	\N	\N	2026-03-08 20:31:31.184242	2026-03-08 20:31:31.184242
2299	321	730	\N	\N	\N	2026-03-08 20:31:31.222703	2026-03-08 20:31:31.222703
1574	1057	573	\N	\N	\N	2026-02-26 04:13:37.379134	2026-02-26 04:13:37.379134
1575	61	573	\N	\N	\N	2026-02-26 04:13:37.383	2026-02-26 04:13:37.383
1576	1058	573	\N	\N	\N	2026-02-26 04:13:37.38577	2026-02-26 04:13:37.38577
1577	92	573	\N	\N	\N	2026-02-26 04:13:37.389732	2026-02-26 04:13:37.389732
1578	1059	573	\N	\N	\N	2026-02-26 04:13:37.395225	2026-02-26 04:13:37.395225
1579	169	573	\N	\N	\N	2026-02-26 04:13:37.398948	2026-02-26 04:13:37.398948
1580	1060	573	\N	\N	\N	2026-02-26 04:13:37.402335	2026-02-26 04:13:37.402335
1581	393	573	\N	\N	\N	2026-02-26 04:13:37.404991	2026-02-26 04:13:37.404991
1582	1061	573	\N	\N	\N	2026-02-26 04:13:37.407363	2026-02-26 04:13:37.407363
1583	65	573	\N	\N	\N	2026-02-26 04:13:37.41035	2026-02-26 04:13:37.41035
1584	713	574	\N	\N	\N	2026-02-26 04:13:37.426338	2026-02-26 04:13:37.426338
1585	1070	574	\N	\N	\N	2026-02-26 04:13:37.470438	2026-02-26 04:13:37.470438
1586	125	574	\N	\N	\N	2026-02-26 04:13:37.472876	2026-02-26 04:13:37.472876
1587	36	574	\N	\N	\N	2026-02-26 04:13:37.475102	2026-02-26 04:13:37.475102
1588	1071	574	\N	\N	\N	2026-02-26 04:13:37.480061	2026-02-26 04:13:37.480061
1589	75	574	\N	\N	\N	2026-02-26 04:13:37.482305	2026-02-26 04:13:37.482305
1590	592	574	\N	\N	\N	2026-02-26 04:13:37.484348	2026-02-26 04:13:37.484348
1591	1072	574	\N	\N	\N	2026-02-26 04:13:37.488462	2026-02-26 04:13:37.488462
1592	1073	574	\N	\N	\N	2026-02-26 04:13:37.492691	2026-02-26 04:13:37.492691
1593	203	574	\N	\N	\N	2026-02-26 04:13:37.494965	2026-02-26 04:13:37.494965
1594	103	574	\N	\N	\N	2026-02-26 04:13:37.497039	2026-02-26 04:13:37.497039
1595	102	574	\N	\N	\N	2026-02-26 04:13:37.499217	2026-02-26 04:13:37.499217
1596	121	574	\N	\N	\N	2026-02-26 04:13:37.505261	2026-02-26 04:13:37.505261
1597	713	575	\N	\N	\N	2026-02-26 04:13:37.517018	2026-02-26 04:13:37.517018
1598	1070	575	\N	\N	\N	2026-02-26 04:13:37.519532	2026-02-26 04:13:37.519532
1599	125	575	\N	\N	\N	2026-02-26 04:13:37.521962	2026-02-26 04:13:37.521962
1600	36	575	\N	\N	\N	2026-02-26 04:13:37.524659	2026-02-26 04:13:37.524659
1601	1071	575	\N	\N	\N	2026-02-26 04:13:37.565503	2026-02-26 04:13:37.565503
1602	75	575	\N	\N	\N	2026-02-26 04:13:37.572181	2026-02-26 04:13:37.572181
1603	592	575	\N	\N	\N	2026-02-26 04:13:37.574865	2026-02-26 04:13:37.574865
1604	1072	575	\N	\N	\N	2026-02-26 04:13:37.577079	2026-02-26 04:13:37.577079
1605	1073	575	\N	\N	\N	2026-02-26 04:13:37.579204	2026-02-26 04:13:37.579204
1606	203	575	\N	\N	\N	2026-02-26 04:13:37.581578	2026-02-26 04:13:37.581578
1607	103	575	\N	\N	\N	2026-02-26 04:13:37.584031	2026-02-26 04:13:37.584031
1608	102	575	\N	\N	\N	2026-02-26 04:13:37.586186	2026-02-26 04:13:37.586186
1609	121	575	\N	\N	\N	2026-02-26 04:13:37.592931	2026-02-26 04:13:37.592931
1610	1074	575	\N	\N	\N	2026-02-26 04:13:37.609015	2026-02-26 04:13:37.609015
1611	1075	575	\N	\N	\N	2026-02-26 04:13:37.612836	2026-02-26 04:13:37.612836
1612	1076	575	\N	\N	\N	2026-02-26 04:13:37.680527	2026-02-26 04:13:37.680527
1613	1077	575	\N	\N	\N	2026-02-26 04:13:37.685771	2026-02-26 04:13:37.685771
1614	1078	575	\N	\N	\N	2026-02-26 04:13:37.691092	2026-02-26 04:13:37.691092
1615	1079	575	\N	\N	\N	2026-02-26 04:13:37.695719	2026-02-26 04:13:37.695719
1616	1080	575	\N	\N	\N	2026-02-26 04:13:37.701137	2026-02-26 04:13:37.701137
1617	1081	575	\N	\N	\N	2026-02-26 04:13:37.707285	2026-02-26 04:13:37.707285
1618	1082	575	\N	\N	\N	2026-02-26 04:13:37.711972	2026-02-26 04:13:37.711972
1619	1083	575	\N	\N	\N	2026-02-26 04:13:37.716662	2026-02-26 04:13:37.716662
1620	825	576	\N	\N	\N	2026-02-26 04:13:37.812237	2026-02-26 04:13:37.812237
1621	399	576	\N	\N	\N	2026-02-26 04:13:37.814731	2026-02-26 04:13:37.814731
1622	1084	576	\N	\N	\N	2026-02-26 04:13:37.818714	2026-02-26 04:13:37.818714
1623	1085	576	\N	\N	\N	2026-02-26 04:13:37.866512	2026-02-26 04:13:37.866512
1624	1086	576	\N	\N	\N	2026-02-26 04:13:37.871538	2026-02-26 04:13:37.871538
1625	1087	576	\N	\N	\N	2026-02-26 04:13:37.876463	2026-02-26 04:13:37.876463
1626	1088	576	\N	\N	\N	2026-02-26 04:13:37.882178	2026-02-26 04:13:37.882178
1627	359	578	\N	\N	\N	2026-02-26 04:13:37.908587	2026-02-26 04:13:37.908587
1628	260	578	\N	\N	\N	2026-02-26 04:13:37.911695	2026-02-26 04:13:37.911695
1629	360	578	\N	\N	\N	2026-02-26 04:13:37.914351	2026-02-26 04:13:37.914351
1630	1089	579	\N	\N	\N	2026-02-26 04:13:37.936898	2026-02-26 04:13:37.936898
1631	448	579	\N	\N	\N	2026-02-26 04:13:37.971838	2026-02-26 04:13:37.971838
2141	1302	659	\N	\N	\N	2026-02-28 05:56:57.98258	2026-02-28 05:56:57.98258
2142	1407	659	\N	\N	\N	2026-02-28 05:56:57.992312	2026-02-28 05:56:57.992312
2143	1408	659	\N	\N	\N	2026-02-28 05:56:57.997474	2026-02-28 05:56:57.997474
2144	1409	659	\N	\N	\N	2026-02-28 05:56:58.002566	2026-02-28 05:56:58.002566
1632	630	579	\N	\N	\N	2026-02-26 04:13:37.976875	2026-02-26 04:13:37.976875
1633	311	579	\N	\N	\N	2026-02-26 04:13:37.98055	2026-02-26 04:13:37.98055
1634	943	580	\N	\N	\N	2026-02-26 04:13:37.999635	2026-02-26 04:13:37.999635
1635	151	580	\N	\N	\N	2026-02-26 04:13:38.004236	2026-02-26 04:13:38.004236
1636	122	580	\N	\N	\N	2026-02-26 04:13:38.009416	2026-02-26 04:13:38.009416
1637	944	580	\N	\N	\N	2026-02-26 04:13:38.012618	2026-02-26 04:13:38.012618
1638	758	580	\N	\N	\N	2026-02-26 04:13:38.014971	2026-02-26 04:13:38.014971
1639	1090	580	\N	\N	\N	2026-02-26 04:13:38.019022	2026-02-26 04:13:38.019022
1640	1091	580	\N	\N	\N	2026-02-26 04:13:38.034666	2026-02-26 04:13:38.034666
1641	925	581	\N	\N	\N	2026-02-26 04:13:38.067791	2026-02-26 04:13:38.067791
1642	66	583	\N	\N	\N	2026-02-26 04:13:38.253948	2026-02-26 04:13:38.253948
1643	67	583	\N	\N	\N	2026-02-26 04:13:38.258052	2026-02-26 04:13:38.258052
1644	53	583	\N	\N	\N	2026-02-26 04:13:38.266491	2026-02-26 04:13:38.266491
1645	83	583	\N	\N	\N	2026-02-26 04:13:38.269641	2026-02-26 04:13:38.269641
1646	68	583	\N	\N	\N	2026-02-26 04:13:38.272789	2026-02-26 04:13:38.272789
1647	69	583	\N	\N	\N	2026-02-26 04:13:38.275943	2026-02-26 04:13:38.275943
1648	9	583	\N	\N	\N	2026-02-26 04:13:38.278655	2026-02-26 04:13:38.278655
1649	70	583	\N	\N	\N	2026-02-26 04:13:38.281258	2026-02-26 04:13:38.281258
1650	72	583	\N	\N	\N	2026-02-26 04:13:38.331232	2026-02-26 04:13:38.331232
1651	1062	583	\N	\N	\N	2026-02-26 04:13:38.333934	2026-02-26 04:13:38.333934
1652	1057	583	\N	\N	\N	2026-02-26 04:13:38.336424	2026-02-26 04:13:38.336424
1653	1063	583	\N	\N	\N	2026-02-26 04:13:38.340365	2026-02-26 04:13:38.340365
1654	1064	583	\N	\N	\N	2026-02-26 04:13:38.342598	2026-02-26 04:13:38.342598
1655	1065	583	\N	\N	\N	2026-02-26 04:13:38.345015	2026-02-26 04:13:38.345015
1656	75	583	\N	\N	\N	2026-02-26 04:13:38.347359	2026-02-26 04:13:38.347359
1657	688	585	\N	\N	\N	2026-02-26 04:13:38.366361	2026-02-26 04:13:38.366361
1658	1074	586	\N	\N	\N	2026-02-26 04:13:38.374024	2026-02-26 04:13:38.374024
2145	765	579	\N	\N	\N	2026-02-28 20:31:29.86462	2026-02-28 20:31:29.86462
1659	1075	586	\N	\N	\N	2026-02-26 04:13:38.432703	2026-02-26 04:13:38.432703
1660	1076	586	\N	\N	\N	2026-02-26 04:13:38.434839	2026-02-26 04:13:38.434839
1661	1077	586	\N	\N	\N	2026-02-26 04:13:38.437029	2026-02-26 04:13:38.437029
1662	1078	586	\N	\N	\N	2026-02-26 04:13:38.439193	2026-02-26 04:13:38.439193
1663	1079	586	\N	\N	\N	2026-02-26 04:13:38.441508	2026-02-26 04:13:38.441508
1664	1080	586	\N	\N	\N	2026-02-26 04:13:38.443736	2026-02-26 04:13:38.443736
1665	1081	586	\N	\N	\N	2026-02-26 04:13:38.445879	2026-02-26 04:13:38.445879
1666	1082	586	\N	\N	\N	2026-02-26 04:13:38.447912	2026-02-26 04:13:38.447912
1667	1083	586	\N	\N	\N	2026-02-26 04:13:38.450069	2026-02-26 04:13:38.450069
1668	709	588	\N	\N	\N	2026-02-26 04:13:38.574146	2026-02-26 04:13:38.574146
1669	962	588	\N	\N	\N	2026-02-26 04:13:38.577114	2026-02-26 04:13:38.577114
1670	230	588	\N	\N	\N	2026-02-26 04:13:38.63176	2026-02-26 04:13:38.63176
1671	580	588	\N	\N	\N	2026-02-26 04:13:38.634239	2026-02-26 04:13:38.634239
1672	711	588	\N	\N	\N	2026-02-26 04:13:38.636684	2026-02-26 04:13:38.636684
1673	1092	589	\N	\N	\N	2026-02-26 04:13:38.942365	2026-02-26 04:13:38.942365
1674	42	589	\N	\N	\N	2026-02-26 04:13:39.033327	2026-02-26 04:13:39.033327
1675	49	589	\N	\N	\N	2026-02-26 04:13:39.035473	2026-02-26 04:13:39.035473
1676	221	589	\N	\N	\N	2026-02-26 04:13:39.037689	2026-02-26 04:13:39.037689
1677	243	589	\N	\N	\N	2026-02-26 04:13:39.131077	2026-02-26 04:13:39.131077
1678	1093	589	\N	\N	\N	2026-02-26 04:13:39.234288	2026-02-26 04:13:39.234288
1679	328	589	\N	\N	\N	2026-02-26 04:13:39.237641	2026-02-26 04:13:39.237641
1680	238	589	\N	\N	\N	2026-02-26 04:13:39.2441	2026-02-26 04:13:39.2441
1681	1094	589	\N	\N	\N	2026-02-26 04:13:39.250979	2026-02-26 04:13:39.250979
1682	1095	589	\N	\N	\N	2026-02-26 04:13:39.260111	2026-02-26 04:13:39.260111
1683	61	590	\N	\N	\N	2026-02-26 04:13:39.283877	2026-02-26 04:13:39.283877
1684	69	590	\N	\N	\N	2026-02-26 04:13:39.286195	2026-02-26 04:13:39.286195
1685	8	590	\N	\N	\N	2026-02-26 04:13:39.331799	2026-02-26 04:13:39.331799
1686	894	590	\N	\N	\N	2026-02-26 04:13:39.33593	2026-02-26 04:13:39.33593
1687	355	590	\N	\N	\N	2026-02-26 04:13:39.338471	2026-02-26 04:13:39.338471
1688	678	590	\N	\N	\N	2026-02-26 04:13:39.340834	2026-02-26 04:13:39.340834
1689	70	590	\N	\N	\N	2026-02-26 04:13:39.36916	2026-02-26 04:13:39.36916
1690	257	590	\N	\N	\N	2026-02-26 04:13:39.377111	2026-02-26 04:13:39.377111
1691	87	590	\N	\N	\N	2026-02-26 04:13:39.379262	2026-02-26 04:13:39.379262
1692	36	590	\N	\N	\N	2026-02-26 04:13:39.381585	2026-02-26 04:13:39.381585
1693	90	590	\N	\N	\N	2026-02-26 04:13:39.384173	2026-02-26 04:13:39.384173
1694	46	590	\N	\N	\N	2026-02-26 04:13:39.387086	2026-02-26 04:13:39.387086
1695	1063	590	\N	\N	\N	2026-02-26 04:13:39.432103	2026-02-26 04:13:39.432103
1696	1068	590	\N	\N	\N	2026-02-26 04:13:39.434787	2026-02-26 04:13:39.434787
1697	1069	590	\N	\N	\N	2026-02-26 04:13:39.436994	2026-02-26 04:13:39.436994
1698	67	590	\N	\N	\N	2026-02-26 04:13:39.439271	2026-02-26 04:13:39.439271
1699	344	591	\N	\N	\N	2026-02-26 04:13:39.465167	2026-02-26 04:13:39.465167
1700	1066	591	\N	\N	\N	2026-02-26 04:13:39.467882	2026-02-26 04:13:39.467882
1701	1067	591	\N	\N	\N	2026-02-26 04:13:39.473197	2026-02-26 04:13:39.473197
1702	378	591	\N	\N	\N	2026-02-26 04:13:39.483275	2026-02-26 04:13:39.483275
1703	1096	593	\N	\N	\N	2026-02-26 04:13:39.570022	2026-02-26 04:13:39.570022
1704	288	593	\N	\N	\N	2026-02-26 04:13:39.577093	2026-02-26 04:13:39.577093
1705	289	593	\N	\N	\N	2026-02-26 04:13:39.580125	2026-02-26 04:13:39.580125
1706	1097	593	\N	\N	\N	2026-02-26 04:13:39.633418	2026-02-26 04:13:39.633418
1707	1098	593	\N	\N	\N	2026-02-26 04:13:39.639541	2026-02-26 04:13:39.639541
1708	904	593	\N	\N	\N	2026-02-26 04:13:39.64247	2026-02-26 04:13:39.64247
1709	298	593	\N	\N	\N	2026-02-26 04:13:39.644792	2026-02-26 04:13:39.644792
1710	1099	593	\N	\N	\N	2026-02-26 04:13:39.649135	2026-02-26 04:13:39.649135
1711	295	593	\N	\N	\N	2026-02-26 04:13:39.651966	2026-02-26 04:13:39.651966
1712	466	593	\N	\N	\N	2026-02-26 04:13:39.654629	2026-02-26 04:13:39.654629
1713	1100	593	\N	\N	\N	2026-02-26 04:13:39.659724	2026-02-26 04:13:39.659724
1714	300	593	\N	\N	\N	2026-02-26 04:13:39.662947	2026-02-26 04:13:39.662947
1715	297	593	\N	\N	\N	2026-02-26 04:13:39.665557	2026-02-26 04:13:39.665557
1716	1101	593	\N	\N	\N	2026-02-26 04:13:39.670401	2026-02-26 04:13:39.670401
1717	299	593	\N	\N	\N	2026-02-26 04:13:39.673081	2026-02-26 04:13:39.673081
\.


--
-- Data for Name: artists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.artists (id, name, genre_id, description, created_at, updated_at, ra_followers) FROM stdin;
92	DJ Etta (US)	8	\N	2025-03-15 04:10:37.404065	2025-03-15 04:10:37.404065	\N
93	Sugar (4)	8	\N	2025-03-15 04:10:37.412385	2025-03-15 04:10:37.412385	\N
101	Data Plan	8	\N	2025-03-15 04:10:37.443855	2025-03-15 04:10:37.443855	\N
102	sts (US)	8	\N	2025-03-15 04:10:37.447018	2025-03-15 04:10:37.447018	\N
31	AK (US)	8	\N	2025-03-15 04:10:37.08723	2025-03-15 04:10:37.08723	8
124	BeatLoaf	8	\N	2025-03-15 04:10:37.547398	2025-03-26 05:19:31.753559	14
132	Chaos In The CBD	8	\N	2025-03-15 04:10:37.573176	2025-03-26 05:22:16.076949	29245
140	DeepChord	8	\N	2025-03-15 04:10:37.597421	2025-03-26 05:22:26.717703	4378
139	D.Dan	8	\N	2025-03-15 04:10:37.594787	2025-03-15 04:10:37.594787	5684
50	DJ SPHiNX	8	\N	2025-03-15 04:10:37.168287	2025-03-26 05:17:59.349318	45
159	Fullbodydurag	8	\N	2025-03-15 04:10:37.657628	2025-03-26 05:22:51.82911	99
168	horsegiirL	8	\N	2025-03-15 04:10:37.688871	2025-03-26 05:23:03.905848	8248
158	FJAAK	8	\N	2025-03-15 04:10:37.653726	2025-03-26 05:22:50.881847	27125
182	KlangKuenstler	8	\N	2025-03-15 04:10:37.737813	2025-03-26 05:23:20.633511	21380
219	LADYMONIX	8	\N	2025-03-15 04:10:37.873927	2025-03-26 05:24:19.428087	956
191	Mike Agent X Clark	8	\N	2025-03-15 04:10:37.773441	2025-03-26 05:23:32.738464	252
199	RAEDY LEX	8	\N	2025-03-15 04:10:37.803941	2025-03-26 05:23:44.775394	7
204	salute	8	\N	2025-03-15 04:10:37.821559	2025-03-26 05:23:53.159881	16931
212	sillygirlcarmen	8	\N	2025-03-15 04:10:37.849844	2025-03-26 05:24:07.833572	66
114	Whodat	8	\N	2025-03-15 04:10:37.505293	2025-03-26 05:19:19.260355	281
71	Mozhgan	8	\N	2025-03-15 04:10:37.288134	2025-04-25 18:06:48.626409	430
225	AADJA	8	\N	2025-03-15 04:10:38.01543	2025-04-25 18:07:47.730223	2100
171	JEM (USA)	8	\N	2025-03-15 04:10:37.699011	2025-03-15 04:10:37.699011	\N
173	JMT (2)	8	\N	2025-03-15 04:10:37.705712	2025-03-15 04:10:37.705712	\N
201	Rimarkable	8	\N	2025-03-15 04:10:37.810881	2025-03-15 04:10:37.810881	\N
221	Rødhåd	8	\N	2025-03-15 04:10:38.000461	2025-03-15 04:10:38.000461	\N
264	ANNĒ	8	\N	2025-03-15 04:10:38.508476	2025-03-15 04:10:38.508476	1620
153	Chloé Caillet	8	\N	2025-03-15 04:10:37.636646	2025-03-26 05:27:06.100989	3493
134	Chase & Status	8	\N	2025-03-15 04:10:37.57828	2025-03-26 05:22:18.843994	50147
270	Ø [Phase]	8	\N	2025-03-15 04:10:38.528622	2025-03-15 04:10:38.528622	7698
257	Shaun J. Wright	8	\N	2025-03-15 04:10:38.394528	2025-03-15 04:10:38.394528	430
299	SPEEDŸ	8	\N	2025-03-15 04:10:38.95283	2025-03-15 04:10:38.95283	30
258	Titonton Duvanté	8	\N	2025-03-15 04:10:38.397718	2025-03-15 04:10:38.397718	584
220	Walker & Royce	8	\N	2025-03-15 04:10:37.877188	2025-03-26 05:24:20.342473	8337
260	OMO (US)	8	\N	2025-03-15 04:10:38.417811	2025-04-25 18:05:56.932921	4
712	Haute to Death	\N	\N	2025-04-29 21:46:10.414615	2025-04-29 21:46:10.414615	\N
713	Anthony Rother	\N	\N	2025-04-29 21:46:11.091459	2025-04-29 21:46:11.091459	\N
714	Dasha Rush	\N	\N	2025-04-29 21:46:11.104353	2025-04-29 21:46:11.104353	\N
715	Disruptive Pattern Material	\N	\N	2025-04-29 21:46:11.112954	2025-04-29 21:46:11.112954	\N
716	DJ Pete	\N	\N	2025-04-29 21:46:11.121216	2025-04-29 21:46:11.121216	\N
717	DVS1	\N	\N	2025-04-29 21:46:11.132046	2025-04-29 21:46:11.132046	\N
718	Traxx	\N	\N	2025-04-29 21:46:11.141344	2025-04-29 21:46:11.141344	\N
719	Ayesha	\N	\N	2025-04-29 21:46:11.869203	2025-04-29 21:46:11.869203	\N
720	Map.ache	\N	\N	2025-04-29 21:46:11.985225	2025-04-29 21:46:11.985225	\N
721	Dandy Jack	\N	\N	2025-04-29 21:46:11.99536	2025-04-29 21:46:11.99536	\N
722	Move D	\N	\N	2025-04-29 21:46:12.071518	2025-04-29 21:46:12.071518	\N
723	Eduardo de la Calle	\N	\N	2025-04-29 21:46:12.115918	2025-04-29 21:46:12.115918	\N
724	Konstantin	\N	\N	2025-04-29 21:46:12.136405	2025-04-29 21:46:12.136405	\N
725	Edward	\N	\N	2025-04-29 21:46:12.21674	2025-04-29 21:46:12.21674	\N
726	Tau Car	\N	\N	2025-04-29 21:46:12.226246	2025-04-29 21:46:12.226246	\N
727	Sibil (1)	\N	\N	2025-04-29 21:46:12.235061	2025-04-29 21:46:12.235061	\N
728	Mayell	\N	\N	2025-04-29 21:46:12.24348	2025-04-29 21:46:12.24348	\N
729	Cosmo	\N	\N	2025-04-29 21:46:12.30796	2025-04-29 21:46:12.30796	\N
730	Bézier	\N	\N	2025-04-29 21:46:12.483668	2025-04-29 21:46:12.483668	\N
731	Bouffant Bouffant	\N	\N	2025-04-29 21:46:12.498209	2025-04-29 21:46:12.498209	\N
732	Stallone The Reducer	\N	\N	2025-04-29 21:46:12.5312	2025-04-29 21:46:12.5312	\N
733	Milan Ariel	\N	\N	2025-04-29 21:46:12.650302	2025-04-29 21:46:12.650302	\N
734	Jeremiah Green	\N	\N	2025-04-29 21:46:12.668717	2025-04-29 21:46:12.668717	\N
735	Gary Martin	\N	\N	2025-04-29 21:46:12.870806	2025-04-29 21:46:12.870806	\N
736	Jus-Ed	\N	\N	2025-04-29 21:46:13.035426	2025-04-29 21:46:13.035426	\N
737	Irfan Rainy	\N	\N	2025-04-29 21:46:13.047266	2025-04-29 21:46:13.047266	\N
738	E-Man	\N	\N	2025-04-29 21:46:13.083833	2025-04-29 21:46:13.083833	\N
739	Ron Allen	\N	\N	2025-04-29 21:46:13.202515	2025-04-29 21:46:13.202515	\N
740	Navid Navbox	\N	\N	2025-04-29 21:46:13.371601	2025-04-29 21:46:13.371601	\N
741	DJ Nola	\N	\N	2025-04-29 21:46:13.470455	2025-04-29 21:46:13.470455	\N
742	Devon James	\N	\N	2025-04-29 21:46:13.578752	2025-04-29 21:46:13.578752	\N
743	Raphael Carrau	\N	\N	2025-04-29 21:46:15.269616	2025-04-29 21:46:15.269616	\N
744	Voodoos and Taboos	\N	\N	2025-04-29 21:46:15.282994	2025-04-29 21:46:15.282994	\N
745	Sammir	\N	\N	2025-04-29 21:46:15.298618	2025-04-29 21:46:15.298618	\N
746	Jorge Escribano	\N	\N	2025-04-29 21:46:15.307217	2025-04-29 21:46:15.307217	\N
747	Bernat	\N	\N	2025-04-29 21:46:15.315887	2025-04-29 21:46:15.315887	\N
748	PETER GUY	\N	\N	2025-04-29 21:46:15.326114	2025-04-29 21:46:15.326114	\N
749	I-R (US)	\N	\N	2025-04-29 21:46:16.070353	2025-04-29 21:46:16.070353	\N
750	Chris Cruse	\N	\N	2025-04-29 21:46:16.110324	2025-04-29 21:46:16.110324	\N
751	Massimiliano Pagliara	\N	\N	2025-04-29 21:46:16.118663	2025-04-29 21:46:16.118663	\N
752	Juheun	\N	\N	2025-04-29 21:46:17.110479	2025-04-29 21:46:17.110479	\N
753	Claus Bachor	\N	\N	2025-04-29 21:46:17.122653	2025-04-29 21:46:17.122653	\N
754	Antonio Lombardo	\N	\N	2025-04-29 21:46:17.17054	2025-04-29 21:46:17.17054	\N
755	Pjay	\N	\N	2025-04-29 21:46:17.184695	2025-04-29 21:46:17.184695	\N
756	Dutch Mike	\N	\N	2025-04-29 21:46:17.193501	2025-04-29 21:46:17.193501	\N
757	Cody Hammer	\N	\N	2025-04-29 21:46:17.20172	2025-04-29 21:46:17.20172	\N
758	DJ-FIXED	\N	\N	2025-04-29 21:46:17.216584	2025-04-29 21:46:17.216584	\N
759	MAXIMILIANO (US)	\N	\N	2025-04-29 21:46:17.23053	2025-04-29 21:46:17.23053	\N
760	Michelle Sparks	\N	\N	2025-04-29 21:46:17.24001	2025-04-29 21:46:17.24001	\N
761	Geneva (2)	\N	\N	2025-04-29 21:46:17.515189	2025-04-29 21:46:17.515189	\N
762	Sassmouth	\N	\N	2025-04-29 21:46:17.529219	2025-04-29 21:46:17.529219	\N
763	Overland	\N	\N	2025-04-29 21:46:17.574141	2025-04-29 21:46:17.574141	\N
764	Wild Cherry	\N	\N	2025-04-29 21:46:17.587458	2025-04-29 21:46:17.587458	\N
765	Garrison XR	\N	\N	2025-04-29 21:46:17.601041	2025-04-29 21:46:17.601041	\N
766	jamea.	\N	\N	2025-04-29 21:46:17.795715	2025-04-29 21:46:17.795715	\N
205	Sama' Abdulhadi	8	4200	2025-03-15 04:10:37.824766	2025-03-26 05:27:31.575014	4300
235	Echoføn	8	\N	2025-03-15 04:10:38.049167	2025-03-15 04:10:38.049167	\N
272	VIL (PT)	8	\N	2025-03-15 04:10:38.536766	2025-03-15 04:10:38.536766	\N
275	PLEASURES (US)	8	\N	2025-03-15 04:10:38.548872	2025-03-15 04:10:38.548872	\N
291	Axkan	8	\N	2025-03-15 04:10:38.924352	2025-03-15 04:10:38.924352	\N
120	Annicka	8	\N	2025-03-15 04:10:37.537016	2025-03-26 05:19:26.73638	12
305	E.R.P.	\N	\N	2025-04-02 00:04:59.288766	2025-04-02 00:04:59.288766	920
767	Julius the Mad Thinker	\N	\N	2025-05-05 20:22:32.52592	2025-05-05 20:22:32.52592	\N
768	Eli Escobar	\N	\N	2025-05-05 20:22:33.128965	2025-05-05 20:22:33.128965	\N
769	Dee Diggs	\N	\N	2025-05-05 20:22:33.138991	2025-05-05 20:22:33.138991	\N
770	A Guy Called Gerald	\N	\N	2025-05-05 20:22:33.253204	2025-05-05 20:22:33.253204	\N
771	Chez Damier	\N	\N	2025-05-05 20:22:33.271867	2025-05-05 20:22:33.271867	\N
772	David Berrie	\N	\N	2025-05-05 20:22:33.316559	2025-05-05 20:22:33.316559	\N
773	CQQCHiFRUIT	\N	\N	2025-05-05 20:22:33.900529	2025-05-05 20:22:33.900529	\N
774	La Spacer	\N	\N	2025-05-05 20:22:33.909852	2025-05-05 20:22:33.909852	\N
775	fleet.dreams	\N	\N	2025-05-05 20:22:33.918074	2025-05-05 20:22:33.918074	\N
776	Alejandro Marenco	\N	\N	2025-05-05 20:22:33.92645	2025-05-05 20:22:33.92645	\N
777	DykeChow	\N	\N	2025-05-05 20:22:33.934418	2025-05-05 20:22:33.934418	\N
778	Dose & Echo	\N	\N	2025-05-05 20:22:33.951643	2025-05-05 20:22:33.951643	\N
779	Yamah	\N	\N	2025-05-05 20:22:33.9661	2025-05-05 20:22:33.9661	\N
780	Ty-Jones	\N	\N	2025-05-05 20:22:34.021529	2025-05-05 20:22:34.021529	\N
781	Loqum	\N	\N	2025-05-05 20:22:34.030402	2025-05-05 20:22:34.030402	\N
782	DE ALMA	\N	\N	2025-05-05 20:22:34.04426	2025-05-05 20:22:34.04426	\N
783	Todd Osborn	\N	\N	2025-05-05 20:22:34.397988	2025-05-05 20:22:34.397988	\N
784	Cosmo (KR)	\N	\N	2025-05-05 20:22:34.526255	2025-05-05 20:22:34.526255	\N
785	Austen van der Bleek	\N	\N	2025-05-05 20:22:35.268602	2025-05-05 20:22:35.268602	\N
786	DJ Ronnie Rave	\N	\N	2025-05-05 20:22:35.399529	2025-05-05 20:22:35.399529	\N
787	Cymek	\N	\N	2025-05-05 20:22:35.408623	2025-05-05 20:22:35.408623	\N
788	Milieu	\N	\N	2025-05-05 20:22:35.58089	2025-05-05 20:22:35.58089	\N
789	Marshall Applewhite	\N	\N	2025-05-05 20:22:35.589964	2025-05-05 20:22:35.589964	\N
790	trevor.f	\N	\N	2025-05-05 20:22:36.49193	2025-05-05 20:22:36.49193	\N
791	DJ Three	\N	\N	2025-05-05 20:22:36.700715	2025-05-05 20:22:36.700715	\N
792	The Bernabela Project	\N	\N	2025-05-05 20:22:36.713515	2025-05-05 20:22:36.713515	\N
793	Medallion Man	\N	\N	2025-05-05 20:22:36.72167	2025-05-05 20:22:36.72167	\N
794	Rob Lloyd	\N	\N	2025-05-05 20:22:36.734449	2025-05-05 20:22:36.734449	\N
795	Mr. Murray	\N	\N	2025-05-05 20:22:36.800398	2025-05-05 20:22:36.800398	\N
796	Lapilli	\N	\N	2025-05-05 20:22:36.808447	2025-05-05 20:22:36.808447	\N
797	Mr. Twista	\N	\N	2025-05-05 20:22:36.816204	2025-05-05 20:22:36.816204	\N
798	Christopher Mohn	\N	\N	2025-05-05 20:22:37.133813	2025-05-05 20:22:37.133813	\N
799	Igor Vicente	\N	\N	2025-05-05 20:22:37.186108	2025-05-05 20:22:37.186108	\N
800	Jus Nowhere	\N	\N	2025-05-05 20:22:37.194622	2025-05-05 20:22:37.194622	\N
801	Edo	\N	\N	2025-05-05 20:22:37.20265	2025-05-05 20:22:37.20265	\N
802	Lee Curtiss	\N	\N	2025-05-05 20:22:37.217455	2025-05-05 20:22:37.217455	\N
803	Roni Amitai	\N	\N	2025-05-05 20:22:37.282005	2025-05-05 20:22:37.282005	\N
804	Lee Foss	\N	\N	2025-05-05 20:22:37.990848	2025-05-05 20:22:37.990848	\N
421	Atom™	\N	\N	2025-04-04 23:17:35.712141	2025-04-04 23:17:35.712141	2954
317	Andrés	\N	\N	2025-04-02 00:04:59.388649	2025-04-02 00:04:59.388649	3625
364	DISCOBOT	\N	\N	2025-04-02 00:04:59.886676	2025-04-02 00:04:59.886676	0
332	EREZ.JPG	\N	\N	2025-04-02 00:04:59.469943	2025-04-02 00:04:59.469943	5
312	Body Mechanic	\N	\N	2025-04-02 00:04:59.340688	2025-04-02 00:04:59.340688	\N
343	Kornél Kovács	\N	\N	2025-04-02 00:04:59.596071	2025-04-02 00:04:59.596071	11126
374	Nick León	\N	\N	2025-04-02 00:05:00.419075	2025-04-02 00:05:00.419075	2623
315	Aboudi Issa	\N	\N	2025-04-02 00:04:59.382715	2025-04-02 00:04:59.382715	\N
325	John Collins (US)	\N	\N	2025-04-02 00:04:59.417564	2025-04-25 18:02:28.502258	47
328	The AM/AMX	\N	\N	2025-04-02 00:04:59.434569	2025-04-25 18:02:48.456564	141
335	Innercity (BE)	\N	\N	2025-04-02 00:04:59.562604	2025-04-25 18:05:20.842502	16
368	Ciel	\N	\N	2025-04-02 00:05:00.397428	2025-04-25 18:06:26.579496	2800
805	TekNoNo	\N	\N	2025-05-08 21:44:49.826737	2025-05-08 21:44:49.826737	\N
806	RN ISMO	\N	\N	2025-05-08 21:44:49.893867	2025-05-08 21:44:49.893867	\N
323	ERNO (US)	\N	\N	2025-04-02 00:04:59.410992	2025-04-02 00:04:59.410992	\N
807	Jeffrey Sfire	\N	\N	2025-05-08 21:44:50.76816	2025-05-08 21:44:50.76816	\N
808	Andy Toth	\N	\N	2025-05-08 21:44:50.807282	2025-05-08 21:44:50.807282	\N
809	CoveLove	\N	\N	2025-05-08 21:44:51.826903	2025-05-08 21:44:51.826903	\N
810	Julian Abel	\N	\N	2025-05-08 21:44:51.846702	2025-05-08 21:44:51.846702	\N
811	Martin Bogado	\N	\N	2025-05-08 21:44:51.869952	2025-05-08 21:44:51.869952	\N
812	Ryan Dahl	\N	\N	2025-05-08 21:44:51.884314	2025-05-08 21:44:51.884314	\N
813	Eric Yaz	\N	\N	2025-05-08 21:44:52.766265	2025-05-08 21:44:52.766265	\N
814	SPCL.K	\N	\N	2025-05-08 21:44:52.773443	2025-05-08 21:44:52.773443	\N
815	Stagira	\N	\N	2025-05-08 21:44:52.777609	2025-05-08 21:44:52.777609	\N
816	AleXander Gentil	\N	\N	2025-05-08 21:44:52.782141	2025-05-08 21:44:52.782141	\N
817	EZGrüüv	\N	\N	2025-05-08 21:44:52.78778	2025-05-08 21:44:52.78778	\N
818	MÖSEE	\N	\N	2025-05-08 21:44:52.796448	2025-05-08 21:44:52.796448	\N
819	Mona Black	\N	\N	2025-05-08 21:44:53.035762	2025-05-08 21:44:53.035762	\N
820	Population One	\N	\N	2025-05-08 21:44:53.046064	2025-05-08 21:44:53.046064	\N
821	Komprezzor	\N	\N	2025-05-08 21:44:53.285742	2025-05-08 21:44:53.285742	\N
822	DJ Cleo	\N	\N	2025-05-08 21:44:53.493707	2025-05-08 21:44:53.493707	\N
823	DJ Hemlok	\N	\N	2025-05-08 21:44:53.503928	2025-05-08 21:44:53.503928	\N
824	Adi (CO)	\N	\N	2025-05-08 21:44:53.996729	2025-05-08 21:44:53.996729	\N
825	999ADJ	\N	\N	2025-05-08 21:44:54.666995	2025-05-08 21:44:54.666995	\N
348	dreamcastmoe	\N	\N	2025-04-02 00:04:59.654248	2025-04-02 00:04:59.654248	\N
826	Niyah West	\N	\N	2025-05-08 21:44:54.673885	2025-05-08 21:44:54.673885	\N
827	Ahya Simone	\N	\N	2025-05-08 21:44:54.768595	2025-05-08 21:44:54.768595	\N
828	SABETYE	\N	\N	2025-05-08 21:44:54.869361	2025-05-08 21:44:54.869361	\N
829	Djsync	\N	\N	2025-05-08 21:44:55.184465	2025-05-08 21:44:55.184465	\N
830	Sanctuary	\N	\N	2025-05-08 21:44:55.189877	2025-05-08 21:44:55.189877	\N
831	Derrick May	\N	\N	2025-05-08 21:44:56.665912	2025-05-08 21:44:56.665912	\N
832	Buzz Goree	\N	\N	2025-05-08 21:44:56.674487	2025-05-08 21:44:56.674487	\N
833	Dylan Payne	\N	\N	2025-05-08 21:44:56.794516	2025-05-08 21:44:56.794516	\N
834	Jake Mora	\N	\N	2025-05-08 21:44:56.865587	2025-05-08 21:44:56.865587	\N
835	Taimur	\N	\N	2025-05-08 21:44:56.873665	2025-05-08 21:44:56.873665	\N
836	Czboogie	\N	\N	2025-05-08 21:44:56.995671	2025-05-08 21:44:56.995671	\N
837	Ryan Sadorus	\N	\N	2025-05-08 21:44:56.999328	2025-05-08 21:44:56.999328	\N
838	Gregboi	\N	\N	2025-05-08 21:44:57.062954	2025-05-08 21:44:57.062954	\N
371	Loidis	\N	\N	2025-04-02 00:05:00.408306	2025-04-02 00:05:00.408306	\N
392	DJ Chelle	\N	\N	2025-04-02 06:00:27.081433	2025-04-02 06:00:27.081433	\N
394	Simon Black	\N	\N	2025-04-02 06:01:30.450591	2025-04-02 06:01:30.450591	\N
397	ADULT.	\N	\N	2025-04-03 04:29:26.547813	2025-04-03 04:29:26.547813	\N
403	YASMEENAH (2)	\N	\N	2025-04-03 04:29:26.888127	2025-04-03 04:29:26.888127	\N
409	Dabura	\N	\N	2025-04-03 04:40:26.248255	2025-04-03 04:40:26.248255	\N
410	Adam Rostek	\N	\N	2025-04-03 04:40:39.032939	2025-04-03 04:40:39.032939	\N
426	Players Club	\N	\N	2025-04-05 01:14:46.989428	2025-04-05 01:14:46.989428	\N
430	Tom T	\N	\N	2025-04-05 01:15:51.282337	2025-04-05 01:15:51.282337	\N
432	PWDR Blu	\N	\N	2025-04-05 04:23:43.736497	2025-04-05 04:23:43.736497	\N
433	Rachael Parker	\N	\N	2025-04-05 04:23:43.746017	2025-04-05 04:23:43.746017	\N
434	Vase	\N	\N	2025-04-05 05:29:29.484914	2025-04-05 05:29:29.484914	\N
435	Andy Garcia	\N	\N	2025-04-05 05:51:40.442201	2025-04-05 05:51:40.442201	\N
436	DJ Spade: The Specialist	\N	\N	2025-04-05 05:51:40.631848	2025-04-05 05:51:40.631848	\N
437	Hari & Rishi	\N	\N	2025-04-05 05:54:18.847571	2025-04-05 05:54:18.847571	\N
438	Lola B	\N	\N	2025-04-05 05:54:18.933821	2025-04-05 05:54:18.933821	\N
439	Mathew Scot	\N	\N	2025-04-05 05:54:18.93991	2025-04-05 05:54:18.93991	\N
440	Nat Black	\N	\N	2025-04-05 05:54:18.945822	2025-04-05 05:54:18.945822	\N
441	Timothy Getz	\N	\N	2025-04-05 05:54:18.952901	2025-04-05 05:54:18.952901	\N
444	Mutual Heaven	\N	\N	2025-04-05 05:55:59.036907	2025-04-05 05:55:59.036907	\N
445	Martha Quezada	\N	\N	2025-04-05 05:55:59.043937	2025-04-05 05:55:59.043937	\N
447	Nate Graham	\N	\N	2025-04-05 05:55:59.057142	2025-04-05 05:55:59.057142	\N
449	Ted Krisko	\N	\N	2025-04-05 05:57:32.73964	2025-04-05 05:57:32.73964	\N
450	Stevie	\N	\N	2025-04-05 05:58:25.7309	2025-04-05 05:58:25.7309	\N
451	Qlank	\N	\N	2025-04-05 06:00:36.995172	2025-04-05 06:00:36.995172	\N
452	Basura Boyz	\N	\N	2025-04-05 06:00:37.033013	2025-04-05 06:00:37.033013	\N
453	Dino Munaco	\N	\N	2025-04-05 06:00:37.039428	2025-04-05 06:00:37.039428	\N
454	Versace James	\N	\N	2025-04-05 06:00:37.044934	2025-04-05 06:00:37.044934	\N
455	SIMIO	\N	\N	2025-04-05 06:00:37.050249	2025-04-05 06:00:37.050249	\N
456	Jun Wilder	\N	\N	2025-04-05 06:00:37.055257	2025-04-05 06:00:37.055257	\N
457	Miss Belles	\N	\N	2025-04-05 06:00:37.060932	2025-04-05 06:00:37.060932	\N
460	Ali	\N	\N	2025-04-05 06:02:03.039519	2025-04-05 06:02:03.039519	\N
550	DJ Di'jital	\N	\N	2025-04-11 22:50:09.51015	2025-04-11 22:50:09.51015	203
475	Glitter Magik	\N	\N	2025-04-05 06:03:47.53217	2025-04-05 06:03:47.53217	0
463	Tris Tiffany	\N	\N	2025-04-05 06:03:47.139518	2025-04-05 06:03:47.139518	\N
464	Dik Richie	\N	\N	2025-04-05 06:03:47.146744	2025-04-05 06:03:47.146744	\N
465	Xenaa	\N	\N	2025-04-05 06:03:47.154597	2025-04-05 06:03:47.154597	\N
467	The RaveMan	\N	\N	2025-04-05 06:03:47.246195	2025-04-05 06:03:47.246195	\N
468	Koruptid	\N	\N	2025-04-05 06:03:47.254822	2025-04-05 06:03:47.254822	\N
469	Lykan	\N	\N	2025-04-05 06:03:47.260782	2025-04-05 06:03:47.260782	\N
470	Sotech	\N	\N	2025-04-05 06:03:47.268866	2025-04-05 06:03:47.268866	\N
471	Adjust	\N	\N	2025-04-05 06:03:47.333635	2025-04-05 06:03:47.333635	\N
472	Marq Moro	\N	\N	2025-04-05 06:03:47.341039	2025-04-05 06:03:47.341039	\N
473	Chancellor	\N	\N	2025-04-05 06:03:47.347891	2025-04-05 06:03:47.347891	\N
466	Nikkie Nocturnal	\N	\N	2025-04-05 06:03:47.238188	2025-04-05 06:03:47.238188	1
476	DJ Tyrone Peso	\N	\N	2025-04-05 06:03:47.542275	2025-04-05 06:03:47.542275	\N
477	PCP USB	\N	\N	2025-04-05 06:05:13.146586	2025-04-05 06:05:13.146586	\N
478	Maxxx2Unholy	\N	\N	2025-04-05 06:06:12.444462	2025-04-05 06:06:12.444462	\N
479	Nobody Famous	\N	\N	2025-04-05 06:06:12.531285	2025-04-05 06:06:12.531285	\N
480	DJ Renz	\N	\N	2025-04-05 06:06:12.54223	2025-04-05 06:06:12.54223	\N
481	Driving MissHazy	\N	\N	2025-04-05 06:06:12.551241	2025-04-05 06:06:12.551241	\N
482	SIKTUNE	\N	\N	2025-04-05 06:06:12.635283	2025-04-05 06:06:12.635283	\N
483	Mj Bleezie	\N	\N	2025-04-05 06:06:12.649035	2025-04-05 06:06:12.649035	\N
484	dominga	\N	\N	2025-04-05 06:07:11.535879	2025-04-05 06:07:11.535879	\N
485	Cybotron	\N	\N	2025-04-05 06:08:06.446057	2025-04-05 06:08:06.446057	\N
486	NAP	\N	\N	2025-04-05 06:08:47.158673	2025-04-05 06:08:47.158673	\N
487	Colin Barrett	\N	\N	2025-04-05 06:10:12.124288	2025-04-05 06:10:12.124288	\N
488	Simplicity	\N	\N	2025-04-05 06:10:12.134551	2025-04-05 06:10:12.134551	\N
489	Sutter	\N	\N	2025-04-05 06:10:12.144603	2025-04-05 06:10:12.144603	\N
518	Mx. Blaire	\N	\N	2025-04-11 22:49:07.562186	2025-04-11 22:49:07.562186	39
491	Xav	\N	\N	2025-04-05 06:10:51.719192	2025-04-05 06:10:51.719192	\N
458	Ro Low	\N	\N	2025-04-05 06:00:37.065466	2025-04-05 06:00:37.065466	0
493	Pretty Positive	\N	\N	2025-04-05 06:12:12.413034	2025-04-05 06:12:12.413034	\N
494	Dom Shbeats	\N	\N	2025-04-05 06:12:12.426894	2025-04-05 06:12:12.426894	\N
495	lOYOl	\N	\N	2025-04-05 06:12:12.434452	2025-04-05 06:12:12.434452	\N
496	Oktaform	\N	\N	2025-04-05 06:13:26.534768	2025-04-05 06:13:26.534768	\N
497	Eli Soul Clap	\N	\N	2025-04-05 06:15:34.693585	2025-04-05 06:15:34.693585	\N
498	Miztah Lex	\N	\N	2025-04-05 06:15:34.732416	2025-04-05 06:15:34.732416	\N
548	S'aint Panic	\N	\N	2025-04-11 22:50:06.849835	2025-04-11 22:50:06.849835	62
500	DJ Kemet	\N	\N	2025-04-05 06:16:46.821258	2025-04-05 06:16:46.821258	\N
546	Sedef Adasï	\N	\N	2025-04-11 22:50:04.767181	2025-04-11 22:50:04.767181	2125
502	DJ Duane Powell	\N	\N	2025-04-05 06:16:46.850842	2025-04-05 06:16:46.850842	\N
503	Diviniti	\N	\N	2025-04-05 06:16:46.859182	2025-04-05 06:16:46.859182	\N
504	jessica Care moore	\N	\N	2025-04-05 06:16:46.86655	2025-04-05 06:16:46.86655	\N
505	Vern English	\N	\N	2025-04-05 06:16:46.87279	2025-04-05 06:16:46.87279	\N
506	Organic Dial	\N	\N	2025-04-05 06:17:55.843238	2025-04-05 06:17:55.843238	\N
507	Wanjira Makena	\N	\N	2025-04-05 06:17:55.855755	2025-04-05 06:17:55.855755	\N
508	Iyengar Yoga Detroit	\N	\N	2025-04-05 06:17:55.865562	2025-04-05 06:17:55.865562	\N
509	Mike Nervous	\N	\N	2025-04-05 06:19:00.412852	2025-04-05 06:19:00.412852	\N
510	Robin Groulx	\N	\N	2025-04-05 06:19:43.600883	2025-04-05 06:19:43.600883	\N
511	Tanglegarden	\N	\N	2025-04-05 06:33:56.137419	2025-04-05 06:33:56.137419	\N
512	DJ ZC	\N	\N	2025-04-05 06:33:56.14661	2025-04-05 06:33:56.14661	\N
519	Sinéad	\N	\N	2025-04-11 22:49:07.76525	2025-04-11 22:49:07.76525	71
429	Lynda Carter	\N	\N	2025-04-05 01:15:37.441418	2025-04-25 18:07:27.044691	0
521	Rahaan	\N	\N	2025-04-11 22:49:10.029943	2025-04-11 22:49:10.029943	\N
665	Fiona	\N	\N	2025-04-18 05:02:46.12391	2025-04-18 05:02:46.12391	199
628	Mark Grusane	\N	\N	2025-04-18 00:31:22.443487	2025-04-18 00:31:22.443487	276
629	Max Daley	\N	\N	2025-04-18 00:31:22.874702	2025-04-18 00:31:22.874702	0
555	OPEN DECKS 6-9PM\r\nBRING A USB AND HEADPHONES\r\nSIGN UP FORM IN DIRT ROOM IG BIO	\N	\N	2025-04-18 00:11:52.02239	2025-04-18 00:11:52.02239	\N
656	John Summit	\N	\N	2025-04-18 02:23:31.506539	2025-04-18 02:23:31.506539	34483
619	m.O.N.R.O.E.	\N	\N	2025-04-18 00:31:09.132993	2025-04-18 00:31:09.132993	370
622	Ryan Crosson	\N	\N	2025-04-18 00:31:10.696618	2025-04-18 00:31:10.696618	3540
630	Ryan Spencer	\N	\N	2025-04-18 00:31:24.165944	2025-04-18 00:31:24.165944	42
601	Pablo R. Ruiz	\N	\N	2025-04-18 00:30:36.804311	2025-04-18 00:30:36.804311	90
639	Sama’ Abdulhadi	\N	\N	2025-04-18 01:59:11.245573	2025-04-18 01:59:11.245573	4237
621	Shaun Reeves	\N	\N	2025-04-18 00:31:10.311391	2025-04-18 00:31:10.311391	2002
623	Sonja Moonear	\N	\N	2025-04-18 00:31:11.088658	2025-04-18 00:31:11.088658	5836
625	Tomas Station	\N	\N	2025-04-18 00:31:11.840291	2025-04-18 00:31:11.840291	434
565	Gino (2)	\N	\N	2025-04-18 00:29:19.584583	2025-04-18 00:29:19.584583	\N
576	Werkout Plan	\N	\N	2025-04-18 00:29:58.492972	2025-04-18 00:29:58.492972	0
663	Zack Fox	\N	\N	2025-04-18 02:23:31.722	2025-04-18 02:23:31.722	3585
575	Tommaso (IT)	\N	\N	2025-04-18 00:29:56.515618	2025-04-25 18:05:40.755297	0
585	Sunjay	\N	\N	2025-04-18 00:30:06.211647	2025-04-18 00:30:06.211647	\N
626	Bileebob	\N	\N	2025-04-18 00:31:21.440704	2025-04-18 00:31:21.440704	67
627	Bill Spencer	\N	\N	2025-04-18 00:31:21.826134	2025-04-18 00:31:21.826134	14
577	Coco & Breezy	\N	\N	2025-04-18 00:29:59.921938	2025-04-18 00:29:59.921938	2327
551	DJ Moppy	\N	\N	2025-04-11 22:50:09.96502	2025-04-11 22:50:09.96502	0
611	DJ Tom T	\N	\N	2025-04-18 00:30:48.864989	2025-04-18 00:30:48.864989	0
593	Kia (AU)	\N	\N	2025-04-18 00:30:22.965074	2025-04-18 00:30:22.965074	\N
615	Elizabëth	\N	\N	2025-04-18 00:31:06.788417	2025-04-18 00:31:06.788417	93
595	RHR	\N	\N	2025-04-18 00:30:23.92175	2025-04-18 00:30:23.92175	\N
596	Nono Gigsta	\N	\N	2025-04-18 00:30:24.401759	2025-04-18 00:30:24.401759	\N
602	Arianna Danae	\N	\N	2025-04-18 00:30:39.624758	2025-04-18 00:30:39.624758	\N
605	Nadia (US)	\N	\N	2025-04-18 00:30:41.042089	2025-04-18 00:30:41.042089	\N
620	O.BEE	\N	\N	2025-04-18 00:31:09.780398	2025-04-18 00:31:09.780398	\N
624	Stretch (DET)	\N	\N	2025-04-18 00:31:11.461604	2025-04-18 00:31:11.461604	\N
174	John Slummit	8	\N	2025-03-15 04:10:37.709053	2025-04-18 00:55:50.098835	32200
631	Odd Mob	\N	\N	2025-04-18 01:05:02.423706	2025-04-18 01:05:02.423706	\N
638	MK	\N	\N	2025-04-18 01:59:11.204184	2025-04-18 01:59:11.204184	\N
640	Shigeto Live Ensemble	\N	\N	2025-04-18 01:59:11.264103	2025-04-18 01:59:11.264103	\N
642	Skepta Más Tiempo	\N	\N	2025-04-18 01:59:11.305663	2025-04-18 01:59:11.305663	\N
644	Armani Reign	\N	\N	2025-04-18 02:22:11.821585	2025-04-18 02:22:11.821585	\N
647	Ember LafiAMMA	\N	\N	2025-04-18 02:22:11.978033	2025-04-18 02:22:11.978033	\N
654	Ferg	\N	\N	2025-04-18 02:23:31.458047	2025-04-18 02:23:31.458047	\N
659	QURL	\N	\N	2025-04-18 02:23:31.627633	2025-04-18 02:23:31.627633	\N
660	Sarena Tyler	\N	\N	2025-04-18 02:23:31.656013	2025-04-18 02:23:31.656013	\N
661	Theresa Hill	\N	\N	2025-04-18 02:23:31.688773	2025-04-18 02:23:31.688773	\N
664	Shrek	\N	\N	2025-04-18 05:02:33.10969	2025-04-18 05:02:33.10969	\N
666	Lord Farquad	\N	\N	2025-04-18 05:02:53.064261	2025-04-18 05:02:53.064261	\N
667	The Gingerbread Man	\N	\N	2025-04-18 05:03:09.496085	2025-04-18 05:03:09.496085	\N
668	Shef	\N	\N	2025-04-18 12:03:18.378528	2025-04-18 12:03:18.378528	\N
669	Dre Lorenz	\N	\N	2025-04-18 12:03:18.394218	2025-04-18 12:03:18.394218	\N
670	Legwrk	\N	\N	2025-04-18 12:03:18.41008	2025-04-18 12:03:18.41008	\N
671	Green Velvet	\N	\N	2025-04-18 12:05:16.524577	2025-04-18 12:05:16.524577	32561
673	Lynda Cart	\N	\N	2025-04-18 12:13:39.089429	2025-04-18 12:13:39.089429	\N
674	ROCKYYVR	\N	\N	2025-04-18 12:13:39.101921	2025-04-18 12:13:39.101921	\N
677	DJ Shiver	\N	\N	2025-04-18 16:49:06.977192	2025-04-18 16:49:06.977192	\N
676	M3	\N	\N	2025-04-18 16:49:06.949427	2025-04-18 16:51:48.52208	10000
681	Sabré (US)	\N	\N	2025-04-21 19:10:57.534441	2025-04-21 19:10:57.534441	\N
683	Obi-Wan Shinobi	\N	\N	2025-04-21 19:10:57.603478	2025-04-21 19:10:57.603478	\N
693	B. Bonds	\N	\N	2025-04-24 00:18:44.657167	2025-04-24 00:18:44.657167	\N
695	Adriel Fantastique!	\N	\N	2025-04-24 00:18:45.551918	2025-04-24 00:18:45.551918	\N
710	Kobe Dupree	\N	\N	2025-04-24 00:18:47.460282	2025-04-24 00:18:47.460282	\N
705	Adam Jeffrey	\N	\N	2025-04-24 00:18:46.573109	2025-04-24 00:18:46.573109	3
696	Alvin Hill	\N	\N	2025-04-24 00:18:45.567808	2025-04-24 00:18:45.567808	2
704	Bethany Shorb	\N	\N	2025-04-24 00:18:46.564584	2025-04-24 00:18:46.564584	2
10	BEIGE	8	\N	2025-03-15 04:10:36.958042	2025-03-26 05:17:12.170319	298
679	Amino	\N	\N	2025-04-21 19:10:57.168587	2025-04-21 19:10:57.168587	18
699	caitlin c. harvey	\N	\N	2025-04-24 00:18:45.59877	2025-04-24 00:18:45.59877	4
711	Construct	\N	\N	2025-04-24 00:18:47.47	2025-04-24 00:18:47.47	46
700	Decompiler	\N	\N	2025-04-24 00:18:45.608173	2025-04-24 00:18:45.608173	0
701	DistantLover	\N	\N	2025-04-24 00:18:45.656772	2025-04-24 00:18:45.656772	1
684	DJ Fleg	\N	\N	2025-04-21 19:10:57.725884	2025-04-21 19:10:57.725884	72
682	DON 614	\N	\N	2025-04-21 19:10:57.53998	2025-04-21 19:10:57.53998	14
691	insane who sane	\N	\N	2025-04-24 00:18:43.764358	2025-04-24 00:18:43.764358	4
694	Guidewire	\N	\N	2025-04-24 00:18:45.456876	2025-04-24 00:18:45.456876	71
692	Keith Tucker	\N	\N	2025-04-24 00:18:44.648567	2025-04-24 00:18:44.648567	321
709	Materielle	\N	\N	2025-04-24 00:18:47.446998	2025-04-24 00:18:47.446998	20
707	Mor Elian	\N	\N	2025-04-24 00:18:46.768095	2025-04-24 00:18:46.768095	2058
708	Mickey Perez	\N	\N	2025-04-24 00:18:47.229647	2025-04-24 00:18:47.229647	39
680	Olly Junglist	\N	\N	2025-04-21 19:10:57.526409	2025-04-21 19:10:57.526409	2
706	Omnitel	\N	\N	2025-04-24 00:18:46.601671	2025-04-24 00:18:46.601671	0
703	Rootsin	\N	\N	2025-04-24 00:18:46.556395	2025-04-24 00:18:46.556395	7
678	Scotia	\N	\N	2025-04-21 19:10:57.139036	2025-04-21 19:10:57.139036	28
690	Scott Grooves	\N	\N	2025-04-24 00:18:43.748954	2025-04-24 00:18:43.748954	3550
675	Richie Hawtin	\N	\N	2025-04-18 12:14:47.104113	2025-04-18 12:14:47.104113	45242
689	Stacey Hale	\N	\N	2025-04-24 00:18:43.711348	2025-04-24 00:18:43.711348	43
698	Stevano	\N	\N	2025-04-24 00:18:45.589598	2025-04-24 00:18:45.589598	3
702	The Monumental	\N	\N	2025-04-24 00:18:46.548293	2025-04-24 00:18:46.548293	5
687	Three Chairs	\N	\N	2025-04-21 19:10:59.434878	2025-04-21 19:10:59.434878	428
685	Tom McBride	\N	\N	2025-04-21 19:10:57.730187	2025-04-21 19:10:57.730187	3
688	Theo Parrish	\N	\N	2025-04-21 19:10:59.43776	2025-04-21 19:10:59.43776	19938
686	Venn Diagramm	\N	\N	2025-04-21 19:10:57.749604	2025-04-21 19:10:57.749604	6
9	Eris Drew	8	\N	2025-03-15 04:10:36.95476	2025-03-26 05:17:10.881514	6800
12	CCL	8	\N	2025-03-15 04:10:36.964434	2025-03-26 05:17:14.809591	1500
13	ADAB	8	\N	2025-03-15 04:10:36.979204	2025-03-26 05:17:15.987267	185
14	Duck Trash	8	\N	2025-03-15 04:10:36.983205	2025-03-26 05:17:17.134173	72
17	Uun	8	\N	2025-03-15 04:10:37.017688	2025-03-26 05:17:21.192569	1100
18	Trovarsi	8	\N	2025-03-15 04:10:37.021084	2025-03-26 05:17:22.444306	61
20	Amnesiac Host	8	\N	2025-03-15 04:10:37.028431	2025-03-26 05:17:24.794114	16
21	Secret Raver	8	\N	2025-03-15 04:10:37.031939	2025-03-26 05:17:25.741255	92
22	Eddie Fowlkes	8	\N	2025-03-15 04:10:37.047828	2025-03-26 05:17:27.043173	2100
23	Delano Smith	8	\N	2025-03-15 04:10:37.05125	2025-03-26 05:17:28.190061	6600
24	Ash Lauryn	8	\N	2025-03-15 04:10:37.059077	2025-03-26 05:17:29.327299	1300
26	Rick Wilhite	8	\N	2025-03-15 04:10:37.066296	2025-03-26 05:17:31.594159	2700
27	Mister Joshooa	8	\N	2025-03-15 04:10:37.069403	2025-03-26 05:17:32.665929	222
28	Marcellus Pittman	8	\N	2025-03-15 04:10:37.072544	2025-03-26 05:17:33.920888	5300
29	Jon Dixon	8	\N	2025-03-15 04:10:37.075707	2025-03-26 05:17:34.895354	716
30	Deeper Waters	8	\N	2025-03-15 04:10:37.078723	2025-03-26 05:17:35.868866	24
32	Blackmoonchild	8	\N	2025-03-15 04:10:37.09064	2025-03-26 05:17:37.287755	63
33	dej.y	8	\N	2025-03-15 04:10:37.093743	2025-03-26 05:17:38.32066	11
35	Fabiola	8	\N	2025-03-15 04:10:37.09982	2025-03-26 05:17:40.470407	48
36	Juliana Huxtable	8	\N	2025-03-15 04:10:37.105817	2025-03-26 05:17:41.675269	1400
37	Kiernan Laveaux	8	\N	2025-03-15 04:10:37.109531	2025-03-26 05:17:42.71713	330
38	Terrell Brooke	8	\N	2025-03-15 04:10:37.112672	2025-03-26 05:17:43.646609	12
39	Altinbas	8	\N	2025-03-15 04:10:37.124897	2025-03-26 05:17:44.851501	2000
41	Dustin Zahn	8	\N	2025-03-15 04:10:37.134365	2025-03-26 05:17:47.178592	5600
42	Ignez	8	\N	2025-03-15 04:10:37.137612	2025-03-26 05:17:48.364195	2100
43	jay york	8	\N	2025-03-15 04:10:37.140806	2025-03-26 05:17:50.319076	260
697	Tylr	\N	\N	2025-04-24 00:18:45.577823	2025-04-24 00:18:45.577823	85
44	Kameliia	8	\N	2025-03-15 04:10:37.143929	2025-03-26 05:17:51.338086	429
45	Lonefront	8	\N	2025-03-15 04:10:37.149064	2025-03-26 05:17:52.426016	143
46	Max Watts	8	\N	2025-03-15 04:10:37.152371	2025-03-26 05:17:53.59341	228
48	Rrose	8	\N	2025-03-15 04:10:37.161812	2025-03-26 05:17:56.714701	8200
49	Polygonia	8	\N	2025-03-15 04:10:37.164746	2025-03-26 05:17:58.098124	2100
51	Savannah G	8	\N	2025-03-15 04:10:37.176468	2025-03-26 05:18:00.397668	19
52	Donna Gardner	8	\N	2025-03-15 04:10:37.180243	2025-03-26 05:18:01.997118	14
54	Max Styler	8	\N	2025-03-15 04:10:37.191826	2025-03-26 05:18:05.154007	2600
55	Ginger Snap	8	\N	2025-03-15 04:10:37.21075	2025-03-26 05:18:06.080406	6
56	DJ Candor	8	\N	2025-03-15 04:10:37.215781	2025-03-26 05:18:07.191498	21
57	Clarisa Kimskii	8	\N	2025-03-15 04:10:37.228837	2025-03-26 05:18:08.566723	593
58	Kerrie	8	\N	2025-03-15 04:10:37.232193	2025-03-26 05:18:09.79129	513
59	Neel	8	\N	2025-03-15 04:10:37.235223	2025-03-26 05:18:11.36694	2300
60	Shawescape Renegade	8	\N	2025-03-15 04:10:37.238231	2025-03-26 05:18:12.58493	51
61	Surgeon	8	\N	2025-03-15 04:10:37.241602	2025-03-26 05:18:14.029482	14900
63	Mark Ernestus	8	\N	2025-03-15 04:10:37.249576	2025-03-26 05:18:17.79699	1200
64	Objekt	8	\N	2025-03-15 04:10:37.255983	2025-03-26 05:18:19.323068	14300
65	Daniel Bell	8	\N	2025-03-15 04:10:37.260055	2025-03-26 05:18:21.238319	3200
66	BMG	8	\N	2025-03-15 04:10:37.263353	2025-03-26 05:18:22.371077	567
67	Bryan Kasenic	8	\N	2025-03-15 04:10:37.266551	2025-03-26 05:18:23.768915	374
68	Derek Plaslaiko	8	\N	2025-03-15 04:10:37.271404	2025-03-26 05:18:24.8297	1500
70	Mike Servito	8	\N	2025-03-15 04:10:37.284993	2025-03-26 05:18:27.406571	3000
72	Patrick Russell	8	\N	2025-03-15 04:10:37.294058	2025-03-26 05:18:29.669577	1100
73	Sarah Wreath	8	\N	2025-03-15 04:10:37.312637	2025-03-26 05:18:30.624204	50
74	The Transcendence Orchestra	8	\N	2025-03-15 04:10:37.31643	2025-03-26 05:18:31.632409	120
75	Scott Zacharias	8	\N	2025-03-15 04:10:37.320978	2025-03-26 05:18:33.005813	237
77	Willow	8	\N	2025-03-15 04:10:37.329464	2025-03-26 05:18:35.141373	35300
78	Gay Marvine	8	\N	2025-03-15 04:10:37.332609	2025-03-26 05:18:36.167728	1200
79	Baronhawk Poitier	8	\N	2025-03-15 04:10:37.335421	2025-03-26 05:18:37.295424	309
80	Joyce Lim	8	\N	2025-03-15 04:10:37.33827	2025-03-26 05:18:38.313815	45
81	GiGi FM	8	\N	2025-03-15 04:10:37.342854	2025-03-26 05:18:39.647164	1300
82	Haruka	8	\N	2025-03-15 04:10:37.346715	2025-03-26 05:18:41.168166	760
84	JADALAREIGN	8	\N	2025-03-15 04:10:37.352998	2025-03-26 05:18:43.546075	316
85	Lakuti	8	\N	2025-03-15 04:10:37.35609	2025-03-26 05:18:44.746519	1400
86	Tama Sumo	8	\N	2025-03-15 04:10:37.358692	2025-03-26 05:18:46.266459	5400
87	Nita Aviance	8	\N	2025-03-15 04:10:37.362406	2025-03-26 05:18:47.429908	181
88	Kilopatrah Jones	8	\N	2025-03-15 04:10:37.36577	2025-03-26 05:18:48.592887	277
89	Laura BCR	8	\N	2025-03-15 04:10:37.370317	2025-03-26 05:18:49.657814	387
91	Detroit In Effect	8	\N	2025-03-15 04:10:37.400685	2025-03-26 05:18:51.89968	2400
94	Toribio	8	\N	2025-03-15 04:10:37.416263	2025-03-26 05:18:53.205839	515
95	DJ Sprinkles	8	\N	2025-03-15 04:10:37.423691	2025-03-26 05:18:54.285455	4300
96	Danny Daze	8	\N	2025-03-15 04:10:37.427324	2025-03-26 05:18:55.67885	8500
97	Lena Willikens	8	\N	2025-03-15 04:10:37.430355	2025-03-26 05:18:56.930821	4200
98	Elena Colombi	8	\N	2025-03-15 04:10:37.433282	2025-03-26 05:18:58.06813	1000
100	2Lanes	8	\N	2025-03-15 04:10:37.440306	2025-03-26 05:19:00.091871	201
103	Jacob Park	8	\N	2025-03-15 04:10:37.450409	2025-03-26 05:19:02.859393	26
104	Glenn Underground	8	\N	2025-03-15 04:10:37.458436	2025-03-26 05:19:04.091699	4800
105	Kai Alce	8	\N	2025-03-15 04:10:37.4614	2025-03-26 05:19:05.168432	1400
106	CTRLZORA	8	\N	2025-03-15 04:10:37.464253	2025-03-26 05:19:06.091131	74
107	Deon Jamar	8	\N	2025-03-15 04:10:37.466756	2025-03-26 05:19:07.267529	244
109	Zenker Brothers	8	\N	2025-03-15 04:10:37.484956	2025-03-26 05:19:10.093298	4600
110	Scuba	8	\N	2025-03-15 04:10:37.487692	2025-03-26 05:19:11.222698	16800
15	Nørbak	8	\N	2025-03-15 04:10:37.009611	2025-04-24 19:23:14.271916	2000
111	Terrence Dixon	8	\N	2025-03-15 04:10:37.490321	2025-03-26 05:19:12.979035	3600
112	Patrice Scott	8	\N	2025-03-15 04:10:37.498298	2025-03-26 05:19:14.155388	2800
113	Gari Romalis	8	\N	2025-03-15 04:10:37.502572	2025-03-26 05:19:15.229234	306
116	Nick Speed	8	\N	2025-03-15 04:10:37.510679	2025-03-26 05:19:21.566381	20
118	ADMN	8	\N	2025-03-15 04:10:37.529732	2025-03-26 05:19:23.984571	88
121	Ashton Swinton	8	\N	2025-03-15 04:10:37.539571	2025-03-26 05:19:28.263901	34
122	Augustus Williams	8	\N	2025-03-15 04:10:37.542024	2025-03-26 05:19:29.232606	55
123	Avalon Emerson	8	\N	2025-03-15 04:10:37.544652	2025-03-26 05:19:30.700047	13800
125	Ben UFO	8	\N	2025-03-15 04:10:37.552505	2025-03-26 05:19:33.210644	18000
127	Boys Noize	8	\N	2025-03-15 04:10:37.560358	2025-03-26 05:22:08.51787	22000
128	Brian Kage	8	\N	2025-03-15 04:10:37.562893	2025-03-26 05:22:09.651003	296
129	Carl Craig	8	\N	2025-03-15 04:10:37.565426	2025-03-26 05:22:11.377558	24500
130	Moodymann	8	\N	2025-03-15 04:10:37.568	2025-03-26 05:22:13.595366	35300
131	Mike Banks	8	\N	2025-03-15 04:10:37.57077	2025-03-26 05:22:14.602829	685
135	Chris Liebing	8	\N	2025-03-15 04:10:37.580901	2025-03-26 05:22:20.755758	22000
136	Chuck Daniels	8	\N	2025-03-15 04:10:37.584486	2025-03-26 05:22:22.513773	237
137	Claude VonStroke	8	\N	2025-03-15 04:10:37.587593	2025-03-26 05:22:23.743608	22600
138	Cobblestone Jazz	8	\N	2025-03-15 04:10:37.590486	2025-03-26 05:22:24.786762	5500
141	Dennis Ferrer	8	\N	2025-03-15 04:10:37.599961	2025-03-26 05:22:28.00315	22600
143	DJ Cent	8	\N	2025-03-15 04:10:37.605488	2025-03-26 05:22:31.652138	38
144	DJ Gigola	8	\N	2025-03-15 04:10:37.608062	2025-03-26 05:22:33.197945	12100
145	DJ Godfather	8	\N	2025-03-15 04:10:37.610771	2025-03-26 05:22:34.246203	2000
146	DJ Holographic	8	\N	2025-03-15 04:10:37.613468	2025-03-26 05:22:35.784248	938
147	DJ I.V.	8	\N	2025-03-15 04:10:37.617604	2025-03-26 05:22:36.789561	15
148	DJ Minx	8	\N	2025-03-15 04:10:37.620916	2025-03-26 05:22:38.032768	2600
149	DJ Nobu	8	\N	2025-03-15 04:10:37.6236	2025-03-26 05:22:39.756433	6200
151	DJ Seoul	8	\N	2025-03-15 04:10:37.629412	2025-03-26 05:22:42.008472	202
152	DJ Tennis	8	\N	2025-03-15 04:10:37.633604	2025-03-26 05:22:43.589032	15300
154	Donavan Glover	8	\N	2025-03-15 04:10:37.63945	2025-03-26 05:22:45.393477	13
155	Dubfire	8	\N	2025-03-15 04:10:37.642277	2025-03-26 05:22:46.737778	24200
156	Ela Minus	8	\N	2025-03-15 04:10:37.645162	2025-03-26 05:22:48.102663	3900
157	Father Dukes	8	\N	2025-03-15 04:10:37.650772	2025-03-26 05:22:49.050125	92
160	Goldie	8	\N	2025-03-15 04:10:37.662461	2025-03-26 05:22:53.137895	13800
161	Photek	8	\N	2025-03-15 04:10:37.665478	2025-03-26 05:22:54.20901	7000
162	HAAi	8	\N	2025-03-15 04:10:37.668372	2025-03-26 05:22:56.164203	10500
163	Hamdi	8	\N	2025-03-15 04:10:37.671518	2025-03-26 05:22:57.21525	7200
165	Henry Brooks	8	\N	2025-03-15 04:10:37.677309	2025-03-26 05:23:00.273836	135
166	Hiroko Yamamura	8	\N	2025-03-15 04:10:37.681556	2025-03-26 05:23:01.575128	1600
16	P.E.A.R.L.	8	\N	2025-03-15 04:10:37.013841	2025-04-24 19:23:42.109423	91
167	HiTech	8	\N	2025-03-15 04:10:37.684859	2025-03-26 05:23:02.779866	1800
169	Huey Mnemonic	8	\N	2025-03-15 04:10:37.692399	2025-03-26 05:23:04.965202	542
170	Jamie xx	8	\N	2025-03-15 04:10:37.696007	2025-03-26 05:23:06.126564	78000
175	Joris Voorn	8	\N	2025-03-15 04:10:37.713965	2025-03-26 05:23:10.053355	34500
176	Joseph Capriati	8	\N	2025-03-15 04:10:37.71706	2025-03-26 05:23:11.754045	24200
177	Junior Sanchez	8	\N	2025-03-15 04:10:37.720018	2025-03-26 05:23:12.774553	2400
178	Keith Worthy	8	\N	2025-03-15 04:10:37.72445	2025-03-26 05:23:13.932443	634
179	Kevin Reynolds	8	\N	2025-03-15 04:10:37.728101	2025-03-26 05:23:15.157294	306
181	The Saunderson Brothers	8	\N	2025-03-15 04:10:37.734641	2025-03-26 05:23:18.98808	48
183	Layton Giordani	8	\N	2025-03-15 04:10:37.744872	2025-03-26 05:23:21.636211	12000
184	Loco Dice	8	\N	2025-03-15 04:10:37.749087	2025-03-26 05:23:22.887781	34000
185	Vintage Culture	8	\N	2025-03-15 04:10:37.752359	2025-03-26 05:23:24.172529	21200
186	Loren	8	\N	2025-03-15 04:10:37.755796	2025-03-26 05:23:25.009442	17
187	Marcel Dettmann	8	\N	2025-03-15 04:10:37.759065	2025-03-26 05:23:26.83628	31500
189	Mau P	8	\N	2025-03-15 04:10:37.766437	2025-03-26 05:23:29.905632	14900
190	MCR-T	8	\N	2025-03-15 04:10:37.770045	2025-03-26 05:23:31.351993	21900
192	Mike Schommer	8	\N	2025-03-15 04:10:37.776806	2025-03-26 05:23:33.864032	125
193	Nina Kraviz	8	\N	2025-03-15 04:10:37.783384	2025-03-26 05:23:35.570888	62500
194	Norm Talley	8	\N	2025-03-15 04:10:37.786741	2025-03-26 05:23:36.681298	1900
196	Patrick Topping	8	\N	2025-03-15 04:10:37.793057	2025-03-26 05:23:40.895625	34300
197	Peter Croce	8	\N	2025-03-15 04:10:37.79625	2025-03-26 05:23:41.907003	357
198	Prospa	8	\N	2025-03-15 04:10:37.800365	2025-03-26 05:23:43.589263	10900
200	Ricardo Villalobos	8	\N	2025-03-15 04:10:37.807386	2025-03-26 05:23:46.196044	43800
202	Riva Starr	8	\N	2025-03-15 04:10:37.814846	2025-03-26 05:23:47.958954	12200
206	Sammy Virji	8	\N	2025-03-15 04:10:37.827715	2025-03-26 05:23:54.383621	23500
207	Sara Landry	8	\N	2025-03-15 04:10:37.830664	2025-03-26 05:23:57.483131	17700
208	Seth Troxler	8	\N	2025-03-15 04:10:37.834607	2025-03-26 05:24:01.789443	37600
209	Shawn Rudiman	8	\N	2025-03-15 04:10:37.840075	2025-03-26 05:24:03.06006	734
210	Shigeto	8	\N	2025-03-15 04:10:37.843233	2025-03-26 05:24:05.082211	6800
213	Sonny Fodera	8	\N	2025-03-15 04:10:37.852978	2025-03-26 05:24:09.157887	37000
214	Soul Clap	8	\N	2025-03-15 04:10:37.856768	2025-03-26 05:24:10.811751	14100
215	Stacey Hotwaxx Hale	8	\N	2025-03-15 04:10:37.859734	2025-03-26 05:24:13.252706	219
216	Stacey Pullen	8	\N	2025-03-15 04:10:37.862816	2025-03-26 05:24:14.730796	4500
217	TSHA	8	\N	2025-03-15 04:10:37.865936	2025-03-26 05:24:16.033513	15900
222	Pfirter	8	\N	2025-03-15 04:10:38.004806	2025-03-26 05:24:22.401527	4600
223	Temudo	8	\N	2025-03-15 04:10:38.008417	2025-03-26 05:24:23.628839	1800
8	Octo Octa	8	\N	2025-03-15 04:10:36.942599	2025-03-26 05:17:08.253446	13400
11	sold	8	\N	2025-03-15 04:10:36.961273	2025-03-26 05:17:13.232363	134
19	Monix	8	\N	2025-03-15 04:10:37.024975	2025-03-26 05:17:23.760862	138
25	Bruce Bailey	8	\N	2025-03-15 04:10:37.062807	2025-03-26 05:17:30.543332	79
34	DJ Shannon	8	\N	2025-03-15 04:10:37.096798	2025-03-26 05:17:39.445839	53
40	Centrific	8	\N	2025-03-15 04:10:37.131351	2025-03-26 05:17:45.999558	142
47	Project 313	8	\N	2025-03-15 04:10:37.158171	2025-03-26 05:17:54.705258	147
53	Carlos Souffront	8	\N	2025-03-15 04:10:37.183484	2025-03-26 05:18:03.956135	1000
62	livwutang	8	\N	2025-03-15 04:10:37.24469	2025-03-26 05:18:16.663247	632
69	Erika	8	\N	2025-03-15 04:10:37.276502	2025-03-26 05:18:25.943771	1500
76	Johnny Zoloft	8	\N	2025-03-15 04:10:37.326312	2025-03-26 05:18:33.962872	2
83	Craig Gonzalez	8	\N	2025-03-15 04:10:37.350096	2025-03-26 05:18:42.159087	52
90	1morning	8	\N	2025-03-15 04:10:37.396773	2025-03-26 05:18:50.782918	499
99	Succubass	8	\N	2025-03-15 04:10:37.436042	2025-03-26 05:18:59.07606	124
108	Skee Mask	8	\N	2025-03-15 04:10:37.480488	2025-03-26 05:19:08.583314	12200
115	DJ Skurge	8	\N	2025-03-15 04:10:37.508035	2025-03-26 05:19:20.285684	306
117	Isaac Prieto	8	\N	2025-03-15 04:10:37.51471	2025-03-26 05:19:22.848399	63
119	Anfisa Letyago	8	\N	2025-03-15 04:10:37.533963	2025-03-26 05:19:25.405213	7400
126	The Blessed Madonna	8	\N	2025-03-15 04:10:37.557647	2025-03-26 05:22:05.398229	31200
133	Charlotte de Witte	8	\N	2025-03-15 04:10:37.575802	2025-03-26 05:22:17.860582	46100
142	Disc Jockey George	8	\N	2025-03-15 04:10:37.602934	2025-03-26 05:22:30.043324	9
150	DJ Seinfeld	8	\N	2025-03-15 04:10:37.626666	2025-03-26 05:22:41.010326	34600
164	Helena Hauff	8	\N	2025-03-15 04:10:37.674388	2025-03-26 05:22:58.769057	17300
172	Jeff Mills	8	\N	2025-03-15 04:10:37.702336	2025-03-26 05:23:07.401768	32000
180	Kevin Saunderson	8	\N	2025-03-15 04:10:37.73127	2025-03-26 05:23:17.922696	11400
188	Mark Broom	8	\N	2025-03-15 04:10:37.762201	2025-03-26 05:23:28.15015	10000
195	Octave One	8	\N	2025-03-15 04:10:37.789862	2025-03-26 05:23:38.521171	16200
203	Salar Ansari	8	\N	2025-03-15 04:10:37.818381	2025-03-26 05:23:48.962762	135
211	Shimza	8	\N	2025-03-15 04:10:37.846627	2025-03-26 05:24:06.779421	2800
227	Truncate	8	\N	2025-03-15 04:10:38.022015	2025-03-26 05:24:28.887672	9300
228	Kyle Geiger	8	\N	2025-03-15 04:10:38.024907	2025-03-26 05:24:29.928896	1300
230	Dru Ruiz	8	\N	2025-03-15 04:10:38.032508	2025-03-26 05:24:32.201357	66
231	Luis Flores	8	\N	2025-03-15 04:10:38.035734	2025-03-26 05:24:33.319249	1100
232	Drumcell	8	\N	2025-03-15 04:10:38.039354	2025-03-26 05:24:34.451597	3400
233	Decoder	8	\N	2025-03-15 04:10:38.042498	2025-03-26 05:24:35.569907	743
234	Annika Wolfe	8	\N	2025-03-15 04:10:38.045835	2025-03-26 05:24:46.835954	238
236	Negative Affect	8	\N	2025-03-15 04:10:38.052385	2025-03-26 05:24:48.847656	2
238	Alarico	8	\N	2025-03-15 04:10:38.066559	2025-03-26 05:24:51.535991	4000
239	DJ T-1000	8	\N	2025-03-15 04:10:38.069713	2025-03-26 05:24:54.107162	1600
240	Elli Acula	8	\N	2025-03-15 04:10:38.073029	2025-03-26 05:24:55.483708	1200
241	Perc	8	\N	2025-03-15 04:10:38.07793	2025-03-26 05:24:56.823191	12100
242	Cirqet	8	\N	2025-03-15 04:10:38.081687	2025-03-26 05:24:59.191317	9
244	tINI	8	\N	2025-03-15 04:10:38.10089	2025-03-26 05:25:02.803584	17800
245	Antwon Faulkner	8	\N	2025-03-15 04:10:38.108949	2025-03-26 05:25:03.910307	315
246	DJ Heather	8	\N	2025-03-15 04:10:38.112073	2025-03-26 05:25:05.059712	772
247	DJ Spinna	8	\N	2025-03-15 04:10:38.115108	2025-03-26 05:25:06.215793	2800
248	Joshua Iz	8	\N	2025-03-15 04:10:38.118894	2025-03-26 05:25:07.313182	255
249	Anthony Nicholson	8	\N	2025-03-15 04:10:38.136465	2025-03-26 05:25:08.269097	343
250	Coflo	8	\N	2025-03-15 04:10:38.139899	2025-03-26 05:25:09.847428	237
252	Cordell Johnson	8	\N	2025-03-15 04:10:38.146735	2025-03-26 05:25:11.78143	80
253	James Vincent	8	\N	2025-03-15 04:10:38.150296	2025-03-26 05:25:12.70853	95
254	Analog Soul	8	\N	2025-03-15 04:10:38.384358	2025-03-26 05:25:14.586244	649
255	Derrick Carter	8	\N	2025-03-15 04:10:38.387818	2025-03-26 05:25:15.830225	7000
256	DJ Sneak	8	\N	2025-03-15 04:10:38.391372	2025-03-26 05:25:17.251132	9100
259	Silent Conversation	8	\N	2025-03-15 04:10:38.41346	2025-03-26 05:25:20.243907	3
261	Kuuma	8	\N	2025-03-15 04:10:38.42085	2025-03-26 05:25:21.244715	6
262	RETCON	8	\N	2025-03-15 04:10:38.423893	2025-03-26 05:25:22.131632	12
265	Chontane	8	\N	2025-03-15 04:10:38.511938	2025-03-26 05:25:25.76285	1300
266	Dax J	8	\N	2025-03-15 04:10:38.515478	2025-03-26 05:25:27.213086	17500
267	Grace Dahl	8	\N	2025-03-15 04:10:38.518597	2025-03-26 05:25:28.42637	964
268	Lars Huismann	8	\N	2025-03-15 04:10:38.522012	2025-03-26 05:25:29.446579	2600
269	Measure Divide	8	\N	2025-03-15 04:10:38.52531	2025-03-26 05:25:30.568845	518
271	SHDW	8	\N	2025-03-15 04:10:38.53317	2025-03-26 05:25:32.505286	4400
274	Lindsey Herbert	8	\N	2025-03-15 04:10:38.543276	2025-03-26 05:25:34.55118	718
276	Secus	8	\N	2025-03-15 04:10:38.551826	2025-03-26 05:25:35.620958	99
277	Timmy Regisford	8	\N	2025-03-15 04:10:38.630906	2025-03-26 05:25:36.75739	1700
278	DJ Spen	8	\N	2025-03-15 04:10:38.634726	2025-03-26 05:25:38.563832	2200
279	Teddy Douglas	8	\N	2025-03-15 04:10:38.637733	2025-03-26 05:25:39.513516	191
280	Vivian Wang	8	\N	2025-03-15 04:10:38.642664	2025-03-26 05:25:40.517593	79
281	Meftah	8	\N	2025-03-15 04:10:38.651009	2025-03-26 05:25:41.785777	291
283	Javonntte	8	\N	2025-03-15 04:10:38.657231	2025-03-26 05:25:44.083413	667
284	Yukiko	8	\N	2025-03-15 04:10:38.670841	2025-03-26 05:25:45.103969	10
285	Rob Alahn	8	\N	2025-03-15 04:10:38.67571	2025-03-26 05:25:46.127766	16
286	Whyteout	8	\N	2025-03-15 04:10:38.683294	2025-03-26 05:25:47.455308	11
288	Frankie Bones	8	\N	2025-03-15 04:10:38.911779	2025-03-26 05:25:51.163893	1900
289	Alexander Technique	8	\N	2025-03-15 04:10:38.915972	2025-03-26 05:25:52.239731	102
290	Sonico	8	\N	2025-03-15 04:10:38.920668	2025-03-26 05:25:53.227393	111
292	Microdot	8	\N	2025-03-15 04:10:38.92749	2025-03-26 05:25:54.941488	96
293	DJ Roach	8	\N	2025-03-15 04:10:38.93094	2025-03-26 05:25:55.963201	23
294	Drivetrain	8	\N	2025-03-15 04:10:38.934101	2025-03-26 05:25:57.256805	181
295	Brent Shay	8	\N	2025-03-15 04:10:38.937176	2025-03-26 05:25:58.152814	7
296	DEMEN-TEK	8	\N	2025-03-15 04:10:38.941523	2025-03-26 05:25:59.030483	1000
298	Dj Disc	8	\N	2025-03-15 04:10:38.949731	2025-03-26 05:26:01.550309	34
300	Terry James	8	\N	2025-03-15 04:10:38.956289	2025-03-26 05:26:03.501259	10
218	Waajeed	8	\N	2025-03-15 04:10:37.870017	2025-03-26 05:24:17.138083	2300
224	Julia Govor	8	\N	2025-03-15 04:10:38.011541	2025-03-26 05:24:24.78961	1900
226	Black Lotus	8	\N	2025-03-15 04:10:38.018583	2025-03-26 05:24:27.704278	2
229	DJ Hyperactive	8	\N	2025-03-15 04:10:38.02853	2025-03-26 05:24:31.144471	3100
237	999999999	8	\N	2025-03-15 04:10:38.062622	2025-03-26 05:24:50.160987	19500
243	David Castellani	8	\N	2025-03-15 04:10:38.084814	2025-03-26 05:25:01.075267	321
251	Lorenzo Dewberry	8	\N	2025-03-15 04:10:38.143282	2025-03-26 05:25:10.788678	2
263	nels the operator	8	\N	2025-03-15 04:10:38.426895	2025-03-26 05:25:23.18931	5
273	Adrian Hex	8	\N	2025-03-15 04:10:38.539935	2025-03-26 05:25:33.537226	63
282	Crate Digga	8	\N	2025-03-15 04:10:38.653882	2025-03-26 05:25:42.724278	5
287	Detroit Techno Militia 2x4	8	\N	2025-03-15 04:10:38.90768	2025-03-26 05:25:50.101153	82
297	Destro187	8	\N	2025-03-15 04:10:38.944702	2025-03-26 05:26:00.038711	8
302	Freddy K	\N	\N	2025-04-02 00:04:59.276063	2025-04-02 00:04:59.276063	4400
303	Mike Parker	\N	\N	2025-04-02 00:04:59.282254	2025-04-02 00:04:59.282254	3400
304	Convextion	\N	\N	2025-04-02 00:04:59.285556	2025-04-02 00:04:59.285556	1700
306	Eric Cloutier	\N	\N	2025-04-02 00:04:59.292026	2025-04-02 00:04:59.292026	2100
307	Night Sea	\N	\N	2025-04-02 00:04:59.295078	2025-04-02 00:04:59.295078	62
308	Kudeki	\N	\N	2025-04-02 00:04:59.298354	2025-04-02 00:04:59.298354	140
309	Torsion	\N	\N	2025-04-02 00:04:59.30133	2025-04-02 00:04:59.30133	6
310	monosym	\N	\N	2025-04-02 00:04:59.309105	2025-04-02 00:04:59.309105	9
311	wetdogg	\N	\N	2025-04-02 00:04:59.329896	2025-04-02 00:04:59.329896	5
313	Suburban Knight	\N	\N	2025-04-02 00:04:59.343895	2025-04-02 00:04:59.343895	1200
314	Human Robot	\N	\N	2025-04-02 00:04:59.346858	2025-04-02 00:04:59.346858	38
316	Al Ester	\N	\N	2025-04-02 00:04:59.385861	2025-04-02 00:04:59.385861	126
318	Ataxia	\N	\N	2025-04-02 00:04:59.392955	2025-04-02 00:04:59.392955	1100
319	David A-P	\N	\N	2025-04-02 00:04:59.39714	2025-04-02 00:04:59.39714	1
320	DJ RIGHTEOUS	\N	\N	2025-04-02 00:04:59.40121	2025-04-02 00:04:59.40121	7
321	DJ Skeez	\N	\N	2025-04-02 00:04:59.40388	2025-04-02 00:04:59.40388	6
322	Eastside Jon	\N	\N	2025-04-02 00:04:59.407999	2025-04-02 00:04:59.407999	6
324	Jesse Cory	\N	\N	2025-04-02 00:04:59.414349	2025-04-02 00:04:59.414349	16
326	MIKE RANSOM	\N	\N	2025-04-02 00:04:59.423	2025-04-02 00:04:59.423	7
327	RIRKIN	\N	\N	2025-04-02 00:04:59.430247	2025-04-02 00:04:59.430247	19
329	Tony Foster	\N	\N	2025-04-02 00:04:59.4373	2025-04-02 00:04:59.4373	33
330	Botez	\N	\N	2025-04-02 00:04:59.463728	2025-04-02 00:04:59.463728	40
331	Dalton Taylor	\N	\N	2025-04-02 00:04:59.467237	2025-04-02 00:04:59.467237	53
333	shantymane	\N	\N	2025-04-02 00:04:59.472692	2025-04-02 00:04:59.472692	3
334	Michael Nigro	\N	\N	2025-04-02 00:04:59.475439	2025-04-02 00:04:59.475439	3
336	JKriv	\N	\N	2025-04-02 00:04:59.566796	2025-04-02 00:04:59.566796	1300
337	Mathew Jonson	\N	\N	2025-04-02 00:04:59.571307	2025-04-02 00:04:59.571307	12300
338	Matthew Dear	\N	\N	2025-04-02 00:04:59.574098	2025-04-02 00:04:59.574098	12200
339	Roy Davis Jr	\N	\N	2025-04-02 00:04:59.57999	2025-04-02 00:04:59.57999	1100
340	Shanti Celeste	\N	\N	2025-04-02 00:04:59.582581	2025-04-02 00:04:59.582581	10400
341	DJ Lady D	\N	\N	2025-04-02 00:04:59.588255	2025-04-02 00:04:59.588255	90
342	Axel Boman	\N	\N	2025-04-02 00:04:59.59233	2025-04-02 00:04:59.59233	17700
344	Tammy Lakkis	\N	\N	2025-04-02 00:04:59.600766	2025-04-02 00:04:59.600766	378
345	Trip Report	\N	\N	2025-04-02 00:04:59.605426	2025-04-02 00:04:59.605426	24
346	Dam Swindle	\N	\N	2025-04-02 00:04:59.646056	2025-04-02 00:04:59.646056	23300
347	Dastardly Kids	\N	\N	2025-04-02 00:04:59.649394	2025-04-02 00:04:59.649394	11
349	Inner City	\N	\N	2025-04-02 00:04:59.660464	2025-04-02 00:04:59.660464	16700
350	Jacques Greene	\N	\N	2025-04-02 00:04:59.663383	2025-04-02 00:04:59.663383	16000
351	Nosaj Thing	\N	\N	2025-04-02 00:04:59.666396	2025-04-02 00:04:59.666396	16300
352	Joe Claussell	\N	\N	2025-04-02 00:04:59.674087	2025-04-02 00:04:59.674087	2900
353	Juliet Mendoza	\N	\N	2025-04-02 00:04:59.676882	2025-04-02 00:04:59.676882	167
354	Jyoty	\N	\N	2025-04-02 00:04:59.679694	2025-04-02 00:04:59.679694	1800
355	Lauren Flax	\N	\N	2025-04-02 00:04:59.683905	2025-04-02 00:04:59.683905	1600
356	Life on Planets	\N	\N	2025-04-02 00:04:59.687508	2025-04-02 00:04:59.687508	3000
357	Paranoid London	\N	\N	2025-04-02 00:04:59.695871	2025-04-02 00:04:59.695871	6600
358	Silverdome Boyz	\N	\N	2025-04-02 00:04:59.703346	2025-04-02 00:04:59.703346	2
359	Babies R Stupid	\N	\N	2025-04-02 00:04:59.860701	2025-04-02 00:04:59.860701	7
360	YxFF	\N	\N	2025-04-02 00:04:59.866004	2025-04-02 00:04:59.866004	1
361	SJOD	\N	\N	2025-04-02 00:04:59.869576	2025-04-02 00:04:59.869576	1
362	easygoingtech	\N	\N	2025-04-02 00:04:59.872797	2025-04-02 00:04:59.872797	17
363	Seanni B	\N	\N	2025-04-02 00:04:59.876111	2025-04-02 00:04:59.876111	24
365	Atnarko	\N	\N	2025-04-02 00:05:00.042284	2025-04-02 00:05:00.042284	315
366	Francois K	\N	\N	2025-04-02 00:05:00.051807	2025-04-02 00:05:00.051807	4700
367	Aux 88	\N	\N	2025-04-02 00:05:00.394066	2025-04-02 00:05:00.394066	2800
369	James Bangura	\N	\N	2025-04-02 00:05:00.400561	2025-04-02 00:05:00.400561	611
370	Jonny From Space	\N	\N	2025-04-02 00:05:00.403568	2025-04-02 00:05:00.403568	531
372	Luca Lozano	\N	\N	2025-04-02 00:05:00.411348	2025-04-02 00:05:00.411348	2900
373	Mr. Ho	\N	\N	2025-04-02 00:05:00.41454	2025-04-02 00:05:00.41454	2900
375	OK Williams	\N	\N	2025-04-02 00:05:00.423995	2025-04-02 00:05:00.423995	987
376	PLO Man	\N	\N	2025-04-02 00:05:00.428684	2025-04-02 00:05:00.428684	1100
377	Powder	\N	\N	2025-04-02 00:05:00.432777	2025-04-02 00:05:00.432777	3000
378	Solar	\N	\N	2025-04-02 00:05:00.435849	2025-04-02 00:05:00.435849	1700
379	Vlada	\N	\N	2025-04-02 00:05:00.438646	2025-04-02 00:05:00.438646	1400
380	Psy-Chick	\N	\N	2025-04-02 00:05:00.442998	2025-04-02 00:05:00.442998	29
381	Decliner	\N	\N	2025-04-02 00:05:00.446295	2025-04-02 00:05:00.446295	23
382	Jeff Garcia	\N	\N	2025-04-02 00:05:00.449839	2025-04-02 00:05:00.449839	13
383	Carl Bottles	\N	\N	2025-04-02 00:05:00.453397	2025-04-02 00:05:00.453397	4
384	nuntheless	\N	\N	2025-04-02 00:05:00.457346	2025-04-02 00:05:00.457346	19
385	Rebecca Goldberg	\N	\N	2025-04-02 00:05:00.462695	2025-04-02 00:05:00.462695	210
386	Ariel Zetina	\N	\N	2025-04-02 05:59:03.43445	2025-04-02 05:59:03.43445	1000
387	BASHKKA	\N	\N	2025-04-02 05:59:21.833601	2025-04-02 05:59:21.833601	2000
389	Bouffant Bouffant 	\N	\N	2025-04-02 05:59:52.997932	2025-04-02 05:59:52.997932	78
390	Cherriel	\N	\N	2025-04-02 06:00:06.430582	2025-04-02 06:00:06.430582	22
391	Club Chow	\N	\N	2025-04-02 06:00:16.482022	2025-04-02 06:00:16.482022	34
393	Sharlese	\N	\N	2025-04-02 06:01:17.268605	2025-04-02 06:01:17.268605	127
395	Stallone the Reducer	\N	\N	2025-04-02 06:01:44.082896	2025-04-02 06:01:44.082896	382
396	Young Muscle	\N	\N	2025-04-02 06:01:56.101537	2025-04-02 06:01:56.101537	271
398	Light Asylum	\N	\N	2025-04-03 04:29:26.558586	2025-04-03 04:29:26.558586	1400
399	Auntie Chanel	\N	\N	2025-04-03 04:29:26.563292	2025-04-03 04:29:26.563292	63
400	otodojo	\N	\N	2025-04-03 04:29:26.575141	2025-04-03 04:29:26.575141	83
401	Devoye	\N	\N	2025-04-03 04:29:26.881444	2025-04-03 04:29:26.881444	416
402	Rose Kourts	\N	\N	2025-04-03 04:29:26.884722	2025-04-03 04:29:26.884722	282
404	Kindle	\N	\N	2025-04-03 04:29:26.891343	2025-04-03 04:29:26.891343	16
405	Planet KaiA	\N	\N	2025-04-03 04:29:27.046298	2025-04-03 04:29:27.046298	6
406	B_X_R_N_X_R_D	\N	\N	2025-04-03 04:29:27.049465	2025-04-03 04:29:27.049465	29
407	something blue	\N	\N	2025-04-03 04:29:27.05375	2025-04-03 04:29:27.05375	34
408	Gallons	\N	\N	2025-04-03 04:29:27.059207	2025-04-03 04:29:27.059207	8
411	Jeff Risk	\N	\N	2025-04-04 23:17:35.538523	2025-04-04 23:17:35.538523	14
412	Beatnok	\N	\N	2025-04-04 23:17:35.553378	2025-04-04 23:17:35.553378	5
413	Ronin	\N	\N	2025-04-04 23:17:35.564657	2025-04-04 23:17:35.564657	296
414	Eddie C	\N	\N	2025-04-04 23:17:35.581562	2025-04-04 23:17:35.581562	2900
415	Jeremy Poling	\N	\N	2025-04-04 23:17:35.584949	2025-04-04 23:17:35.584949	17
416	Jon Lemmon	\N	\N	2025-04-04 23:17:35.587946	2025-04-04 23:17:35.587946	64
417	Nesto	\N	\N	2025-04-04 23:17:35.593893	2025-04-04 23:17:35.593893	28
418	Ohashi	\N	\N	2025-04-04 23:17:35.597494	2025-04-04 23:17:35.597494	11
419	Sergio Santos	\N	\N	2025-04-04 23:17:35.602839	2025-04-04 23:17:35.602839	194
420	Eric Sutter	\N	\N	2025-04-04 23:17:35.60591	2025-04-04 23:17:35.60591	23
422	Volvox	\N	\N	2025-04-04 23:17:35.761818	2025-04-04 23:17:35.761818	3500
423	x3butterfly	\N	\N	2025-04-04 23:17:35.765391	2025-04-04 23:17:35.765391	324
424	Marco Neves	\N	\N	2025-04-04 23:17:35.770174	2025-04-04 23:17:35.770174	56
425	KXAH	\N	\N	2025-04-04 23:17:35.776253	2025-04-04 23:17:35.776253	97
428	Discreet Disco	\N	\N	2025-04-05 01:15:18.335524	2025-04-05 01:15:18.335524	1
431	Will Clarke	\N	\N	2025-04-05 03:13:52.755975	2025-04-05 03:13:52.755975	8200
442	Pod Blotz	\N	\N	2025-04-05 05:55:58.942077	2025-04-05 05:55:58.942077	79
443	Tony Price	\N	\N	2025-04-05 05:55:58.952805	2025-04-05 05:55:58.952805	120
446	Anthony Jasper	\N	\N	2025-04-05 05:55:59.050556	2025-04-05 05:55:59.050556	9
448	MGUN	\N	\N	2025-04-05 05:55:59.130425	2025-04-05 05:55:59.130425	721
459	Fiending Hours	\N	\N	2025-04-05 06:00:37.133967	2025-04-05 06:00:37.133967	2
462	Jesse James	\N	\N	2025-04-05 06:03:47.132805	2025-04-05 06:03:47.132805	656
474	Kristof	\N	\N	2025-04-05 06:03:47.438224	2025-04-05 06:03:47.438224	7
490	DJ Tara	\N	\N	2025-04-05 06:10:51.711571	2025-04-05 06:10:51.711571	20
492	Stukes	\N	\N	2025-04-05 06:10:51.741412	2025-04-05 06:10:51.741412	21
499	Lo	\N	\N	2025-04-05 06:15:34.741713	2025-04-05 06:15:34.741713	798
513	DJ Plant Texture	\N	\N	2025-04-11 22:49:05.54258	2025-04-11 22:49:05.54258	910
514	Paurro	\N	\N	2025-04-11 22:49:05.801159	2025-04-11 22:49:05.801159	529
515	Stardust	\N	\N	2025-04-11 22:49:06.004815	2025-04-11 22:49:06.004815	485
516	DJ Good Evening	\N	\N	2025-04-11 22:49:06.219865	2025-04-11 22:49:06.219865	6
517	níco	\N	\N	2025-04-11 22:49:06.417869	2025-04-11 22:49:06.417869	6
520	Turtle Bugg	\N	\N	2025-04-11 22:49:08.084898	2025-04-11 22:49:08.084898	375
522	Tom Noble	\N	\N	2025-04-11 22:49:10.546215	2025-04-11 22:49:10.546215	302
523	Aaron Dae	\N	\N	2025-04-11 22:49:10.847616	2025-04-11 22:49:10.847616	50
524	Disgonuts	\N	\N	2025-04-11 22:49:11.042539	2025-04-11 22:49:11.042539	58
525	Ronin Selecta	\N	\N	2025-04-11 22:49:18.387637	2025-04-11 22:49:18.387637	4
526	Andrea Ghita	\N	\N	2025-04-11 22:49:20.175142	2025-04-11 22:49:20.175142	32
527	Duke Shin	\N	\N	2025-04-11 22:49:20.46697	2025-04-11 22:49:20.46697	107
528	Jorissen	\N	\N	2025-04-11 22:49:20.651301	2025-04-11 22:49:20.651301	20
529	Byron The Aquarius	\N	\N	2025-04-11 22:49:31.961246	2025-04-11 22:49:31.961246	2900
530	Recloose	\N	\N	2025-04-11 22:49:32.519447	2025-04-11 22:49:32.519447	3800
534	Dantiez	\N	\N	2025-04-11 22:49:53.511656	2025-04-11 22:49:53.511656	303
535	Damarii Saunderson	\N	\N	2025-04-11 22:49:53.70266	2025-04-11 22:49:53.70266	19
536	Invite Only	\N	\N	2025-04-11 22:49:54.007739	2025-04-11 22:49:54.007739	1
537	Metawav.	\N	\N	2025-04-11 22:49:54.319	2025-04-11 22:49:54.319	2
538	Darren Divine	\N	\N	2025-04-11 22:49:54.52513	2025-04-11 22:49:54.52513	3
539	Drop Catch	\N	\N	2025-04-11 22:49:54.73894	2025-04-11 22:49:54.73894	5
540	Flabbergast	\N	\N	2025-04-11 22:50:03.589428	2025-04-11 22:50:03.589428	81
541	Maxime dB	\N	\N	2025-04-11 22:50:03.785532	2025-04-11 22:50:03.785532	101
542	Zeina	\N	\N	2025-04-11 22:50:03.982855	2025-04-11 22:50:03.982855	1300
543	Maher Daniel	\N	\N	2025-04-11 22:50:04.186477	2025-04-11 22:50:04.186477	1100
544	Bruno Schmidt	\N	\N	2025-04-11 22:50:04.377989	2025-04-11 22:50:04.377989	437
545	Magda	\N	\N	2025-04-11 22:50:04.571262	2025-04-11 22:50:04.571262	13600
547	Partok	\N	\N	2025-04-11 22:50:06.649012	2025-04-11 22:50:06.649012	450
549	Josh Steers	\N	\N	2025-04-11 22:50:07.048967	2025-04-11 22:50:07.048967	101
552	Blake Baxter	\N	\N	2025-04-11 22:50:10.857444	2025-04-11 22:50:10.857444	2800
553	Ron A.D.	\N	\N	2025-04-11 22:50:12.546295	2025-04-11 22:50:12.546295	13
554	DIRT ROOM	\N	\N	2025-04-11 22:50:15.749809	2025-04-11 22:50:15.749809	11
556	Demi Riquisimo	\N	\N	2025-04-18 00:28:42.177125	2025-04-18 00:28:42.177125	323
557	Tamper Evident	\N	\N	2025-04-18 00:28:43.855567	2025-04-18 00:28:43.855567	3
558	VITIGRRL	\N	\N	2025-04-18 00:28:45.61262	2025-04-18 00:28:45.61262	14
559	HAIEK	\N	\N	2025-04-18 00:28:46.013169	2025-04-18 00:28:46.013169	10
560	Marcus Lott	\N	\N	2025-04-18 00:28:46.442485	2025-04-18 00:28:46.442485	20
561	LATEX GIRL	\N	\N	2025-04-18 00:28:46.91336	2025-04-18 00:28:46.91336	42
562	Luca Miel	\N	\N	2025-04-18 00:28:47.311715	2025-04-18 00:28:47.311715	5
563	Wax Assassin	\N	\N	2025-04-18 00:28:47.830466	2025-04-18 00:28:47.830466	4
564	Ohm Hourani	\N	\N	2025-04-18 00:29:19.133772	2025-04-18 00:29:19.133772	198
566	Britty	\N	\N	2025-04-18 00:29:20.055952	2025-04-18 00:29:20.055952	5
567	DJ Slugo	\N	\N	2025-04-18 00:29:41.73473	2025-04-18 00:29:41.73473	2400
568	Sheefy McFly	\N	\N	2025-04-18 00:29:42.256797	2025-04-18 00:29:42.256797	82
569	Sinistarr	\N	\N	2025-04-18 00:29:42.749733	2025-04-18 00:29:42.749733	548
570	ASL Princess	\N	\N	2025-04-18 00:29:43.219182	2025-04-18 00:29:43.219182	27
571	DJ Manny	\N	\N	2025-04-18 00:29:43.950623	2025-04-18 00:29:43.950623	2000
572	Eddie Logix	\N	\N	2025-04-18 00:29:54.568382	2025-04-18 00:29:54.568382	23
573	John Beltran	\N	\N	2025-04-18 00:29:55.064934	2025-04-18 00:29:55.064934	5000
574	Marc Meistro	\N	\N	2025-04-18 00:29:56.032048	2025-04-18 00:29:56.032048	1
578	Viswar	\N	\N	2025-04-18 00:30:02.853518	2025-04-18 00:30:02.853518	2
579	program17	\N	\N	2025-04-18 00:30:03.327384	2025-04-18 00:30:03.327384	4
580	Hazmat Live	\N	\N	2025-04-18 00:30:03.852086	2025-04-18 00:30:03.852086	36
581	Joshua Tree	\N	\N	2025-04-18 00:30:04.333426	2025-04-18 00:30:04.333426	51
388	Bezier	\N	\N	2025-04-02 05:59:37.85041	2025-04-02 05:59:37.85041	657
582	Acidpimp	\N	\N	2025-04-18 00:30:04.810342	2025-04-18 00:30:04.810342	6
583	Derek Michael	\N	\N	2025-04-18 00:30:05.288074	2025-04-18 00:30:05.288074	57
584	LLaMa Dream	\N	\N	2025-04-18 00:30:05.745307	2025-04-18 00:30:05.745307	2
586	Stone Owl	\N	\N	2025-04-18 00:30:06.900016	2025-04-18 00:30:06.900016	88
587	Craig Blackmoore	\N	\N	2025-04-18 00:30:07.569128	2025-04-18 00:30:07.569128	1
588	dBridge	\N	\N	2025-04-18 00:30:20.513052	2025-04-18 00:30:20.513052	5700
589	DjRUM	\N	\N	2025-04-18 00:30:21.022855	2025-04-18 00:30:21.022855	13100
590	RP Boo	\N	\N	2025-04-18 00:30:21.501994	2025-04-18 00:30:21.501994	2500
591	Identified Patient	\N	\N	2025-04-18 00:30:21.974271	2025-04-18 00:30:21.974271	3300
592	Reptant	\N	\N	2025-04-18 00:30:22.499084	2025-04-18 00:30:22.499084	2300
594	Mun Sing	\N	\N	2025-04-18 00:30:23.458251	2025-04-18 00:30:23.458251	493
597	Yumi	\N	\N	2025-04-18 00:30:24.884583	2025-04-18 00:30:24.884583	158
598	Fusegrade	\N	\N	2025-04-18 00:30:25.342921	2025-04-18 00:30:25.342921	12
599	Charles Trees	\N	\N	2025-04-18 00:30:35.262447	2025-04-18 00:30:35.262447	107
600	Kenjiro	\N	\N	2025-04-18 00:30:36.320323	2025-04-18 00:30:36.320323	16
603	Chippy Nonstop	\N	\N	2025-04-18 00:30:40.0914	2025-04-18 00:30:40.0914	1300
604	MNSA	\N	\N	2025-04-18 00:30:40.579756	2025-04-18 00:30:40.579756	3
606	Nadim Maghzal	\N	\N	2025-04-18 00:30:41.535638	2025-04-18 00:30:41.535638	5
607	SAMIA	\N	\N	2025-04-18 00:30:42.014306	2025-04-18 00:30:42.014306	1600
608	Saphe	\N	\N	2025-04-18 00:30:42.517349	2025-04-18 00:30:42.517349	13
609	Wake Island	\N	\N	2025-04-18 00:30:43.266105	2025-04-18 00:30:43.266105	62
610	Zarina	\N	\N	2025-04-18 00:30:43.732378	2025-04-18 00:30:43.732378	47
612	Adi	\N	\N	2025-04-18 00:31:04.941887	2025-04-18 00:31:04.941887	192
613	Craig Richards	\N	\N	2025-04-18 00:31:05.793825	2025-04-18 00:31:05.793825	6800
614	Dana Ruh	\N	\N	2025-04-18 00:31:06.159647	2025-04-18 00:31:06.159647	2600
616	Francois Dillinger	\N	\N	2025-04-18 00:31:07.345937	2025-04-18 00:31:07.345937	160
617	Justin Shaffer	\N	\N	2025-04-18 00:31:07.727666	2025-04-18 00:31:07.727666	5
618	Kate Simko	\N	\N	2025-04-18 00:31:08.121751	2025-04-18 00:31:08.121751	3300
839	Walter Glasshouse	\N	\N	2025-05-12 06:16:17.607057	2025-05-12 06:16:17.607057	\N
840	Jyarsch	\N	\N	2025-05-12 06:16:17.627652	2025-05-12 06:16:17.627652	\N
841	Kevin Ritchey	\N	\N	2025-05-12 06:16:17.68306	2025-05-12 06:16:17.68306	\N
842	Dan Bain	\N	\N	2025-05-12 06:16:17.807856	2025-05-12 06:16:17.807856	\N
843	Gettoblaster	\N	\N	2025-05-12 06:16:18.965742	2025-05-12 06:16:18.965742	\N
844	Soul Goodman	\N	\N	2025-05-12 06:16:18.987402	2025-05-12 06:16:18.987402	\N
845	Francesco e Marcello	\N	\N	2025-05-12 06:16:18.994938	2025-05-12 06:16:18.994938	\N
846	Chris Worthy	\N	\N	2025-05-12 06:16:20.588811	2025-05-12 06:16:20.588811	\N
847	Exhale	\N	\N	2025-05-12 06:16:20.605189	2025-05-12 06:16:20.605189	\N
848	Lynsey Huynh	\N	\N	2025-05-12 06:16:20.648746	2025-05-12 06:16:20.648746	\N
849	Anthony Cruz	\N	\N	2025-05-12 20:30:44.686911	2025-05-12 20:30:44.686911	\N
850	Matty B	\N	\N	2025-05-13 02:11:34.79321	2025-05-13 02:11:34.79321	\N
851	Galen Bundy	\N	\N	2025-05-13 02:11:34.806002	2025-05-13 02:11:34.806002	\N
852	Vee Shelton	\N	\N	2025-05-13 02:11:34.819707	2025-05-13 02:11:34.819707	\N
853	DJ Hardin	\N	\N	2025-05-13 02:11:34.832218	2025-05-13 02:11:34.832218	\N
854	CYMEK	\N	\N	2025-05-13 02:11:34.844179	2025-05-13 02:11:34.844179	\N
855	Acid Pimp	\N	\N	2025-05-13 02:11:34.865362	2025-05-13 02:11:34.865362	\N
856	Chad Stocker	\N	\N	2025-05-13 02:15:13.162914	2025-05-13 02:15:13.162914	\N
857	Motek	\N	\N	2025-05-13 02:15:13.18149	2025-05-13 02:15:13.18149	\N
858	Hal	\N	\N	2025-05-13 02:15:13.19633	2025-05-13 02:15:13.19633	\N
859	Deastro	\N	\N	2025-05-13 02:15:13.210322	2025-05-13 02:15:13.210322	\N
860	Scamardella	\N	\N	2025-05-13 02:15:13.223281	2025-05-13 02:15:13.223281	\N
861	Raj Mahal	\N	\N	2025-05-13 02:15:13.243421	2025-05-13 02:15:13.243421	\N
862	Moppy	\N	\N	2025-05-13 02:15:13.25687	2025-05-13 02:15:13.25687	\N
863	Angelo	\N	\N	2025-05-13 02:18:21.626972	2025-05-13 02:18:21.626972	\N
864	Selyna Alvarez	\N	\N	2025-05-13 02:18:21.649918	2025-05-13 02:18:21.649918	\N
865	Camcussion	\N	\N	2025-05-13 02:18:21.663969	2025-05-13 02:18:21.663969	\N
866	Jeffrey Woodward	\N	\N	2025-05-13 02:18:21.67941	2025-05-13 02:18:21.67941	\N
867	Andre Kronert	\N	\N	2025-05-13 03:30:50.812444	2025-05-13 03:30:50.812444	\N
868	Mike Trombley	\N	\N	2025-05-13 03:30:51.636257	2025-05-13 03:30:51.636257	\N
869	Nada Fácil	\N	\N	2025-05-13 20:30:53.52193	2025-05-13 20:30:53.52193	\N
870	Patio	\N	\N	2025-05-13 20:30:56.503783	2025-05-13 20:30:56.503783	\N
871	Art Department	\N	\N	2025-05-13 20:30:58.099073	2025-05-13 20:30:58.099073	\N
872	CHKLTE	\N	\N	2025-05-13 20:30:58.121115	2025-05-13 20:30:58.121115	\N
873	DR. Disko Dust	\N	\N	2025-05-14 03:30:50.155995	2025-05-14 03:30:50.155995	\N
874	Sprng4evr	\N	\N	2025-05-14 03:30:53.432587	2025-05-14 03:30:53.432587	\N
875	Black Noi$e	\N	\N	2025-05-14 03:30:55.174876	2025-05-14 03:30:55.174876	\N
876	John F.M.	\N	\N	2025-05-14 03:30:55.191213	2025-05-14 03:30:55.191213	\N
877	Raphy (2)	\N	\N	2025-05-14 03:30:55.279164	2025-05-14 03:30:55.279164	\N
878	DEEPFAKE	\N	\N	2025-05-14 20:30:52.052572	2025-05-14 20:30:52.052572	\N
879	Headless Horseman	\N	\N	2025-05-14 20:30:52.684439	2025-05-14 20:30:52.684439	\N
880	Kula	\N	\N	2025-05-14 20:30:52.701321	2025-05-14 20:30:52.701321	\N
881	KARUTH	\N	\N	2025-05-14 20:30:52.718546	2025-05-14 20:30:52.718546	\N
882	Nick Burgess	\N	\N	2025-05-14 20:30:52.736243	2025-05-14 20:30:52.736243	\N
883	dirtymoney	\N	\N	2025-05-14 20:30:52.750117	2025-05-14 20:30:52.750117	\N
884	Sherif	\N	\N	2025-05-14 20:30:52.988007	2025-05-14 20:30:52.988007	\N
885	Sleepy & Boo	\N	\N	2025-05-14 20:30:53.001305	2025-05-14 20:30:53.001305	\N
886	Resy	\N	\N	2025-05-14 20:30:53.014507	2025-05-14 20:30:53.014507	\N
887	GIADETROIT	\N	\N	2025-05-14 20:30:55.816099	2025-05-14 20:30:55.816099	\N
888	Robin Flux	\N	\N	2025-05-14 20:30:55.828511	2025-05-14 20:30:55.828511	\N
889	Lessnoise	\N	\N	2025-05-14 20:30:55.872506	2025-05-14 20:30:55.872506	\N
890	Todor (DET)	\N	\N	2025-05-14 20:30:55.910865	2025-05-14 20:30:55.910865	\N
891	Dretraxx	\N	\N	2025-05-15 03:30:51.73257	2025-05-15 03:30:51.73257	\N
892	Detroit Bureau of Sound	\N	\N	2025-05-15 03:30:51.880513	2025-05-15 03:30:51.880513	\N
893	Gustav Brovold	\N	\N	2025-05-15 03:30:51.98593	2025-05-15 03:30:51.98593	\N
894	Faited	\N	\N	2025-05-15 03:30:52.080187	2025-05-15 03:30:52.080187	\N
895	Julian Kendall	\N	\N	2025-05-15 03:30:52.174102	2025-05-15 03:30:52.174102	\N
896	YerikODJ	\N	\N	2025-05-15 03:30:52.358927	2025-05-15 03:30:52.358927	\N
897	Sincerely,	\N	\N	2025-05-15 03:30:52.371193	2025-05-15 03:30:52.371193	\N
898	Andre Terrell	\N	\N	2025-05-15 03:30:52.4149	2025-05-15 03:30:52.4149	\N
899	Andrea Kalajian	\N	\N	2025-05-15 20:30:56.626376	2025-05-15 20:30:56.626376	\N
900	Zen Zero	\N	\N	2025-05-15 20:30:56.758207	2025-05-15 20:30:56.758207	\N
901	Rex Bravo	\N	\N	2025-05-15 20:30:56.902802	2025-05-15 20:30:56.902802	\N
902	Taylor Monai	\N	\N	2025-05-15 20:30:56.929294	2025-05-15 20:30:56.929294	\N
903	KC	\N	\N	2025-05-15 20:30:56.948876	2025-05-15 20:30:56.948876	\N
904	Dylan Drazen	\N	\N	2025-05-15 20:30:56.964126	2025-05-15 20:30:56.964126	\N
905	DJ Bet	\N	\N	2025-05-15 20:30:59.006136	2025-05-15 20:30:59.006136	\N
906	ATTHEMOMENT	\N	\N	2025-05-15 20:30:59.054132	2025-05-15 20:30:59.054132	\N
907	Mekato	\N	\N	2025-05-15 20:30:59.114232	2025-05-15 20:30:59.114232	\N
908	TEO	\N	\N	2025-05-15 20:30:59.125703	2025-05-15 20:30:59.125703	\N
909	Roque Ybarra	\N	\N	2025-05-15 20:30:59.136374	2025-05-15 20:30:59.136374	\N
910	hypemelo	\N	\N	2025-05-15 20:30:59.204719	2025-05-15 20:30:59.204719	\N
911	NK-Ultra	\N	\N	2025-05-15 20:30:59.21631	2025-05-15 20:30:59.21631	\N
912	Fletch	\N	\N	2025-05-15 20:31:01.41374	2025-05-15 20:31:01.41374	\N
913	Andy Arcade	\N	\N	2025-05-15 20:31:01.454664	2025-05-15 20:31:01.454664	\N
914	LeNoir	\N	\N	2025-05-15 20:31:01.466172	2025-05-15 20:31:01.466172	\N
915	Secrets	\N	\N	2025-05-15 20:31:01.575464	2025-05-15 20:31:01.575464	\N
916	Travis Christian	\N	\N	2025-05-15 20:31:01.58738	2025-05-15 20:31:01.58738	\N
917	Adam Ortiz	\N	\N	2025-05-15 20:31:03.504418	2025-05-15 20:31:03.504418	\N
918	DJ 3000	\N	\N	2025-05-15 20:31:03.541976	2025-05-15 20:31:03.541976	\N
919	Gabriel Palomo	\N	\N	2025-05-15 20:31:03.61868	2025-05-15 20:31:03.61868	\N
920	Jason Hogans	\N	\N	2025-05-15 20:31:03.639273	2025-05-15 20:31:03.639273	\N
921	Ross Williams	\N	\N	2025-05-15 20:31:03.66892	2025-05-15 20:31:03.66892	\N
922	Nitin	\N	\N	2025-05-16 03:30:52.388774	2025-05-16 03:30:52.388774	\N
923	Nosha Luv	\N	\N	2025-05-16 20:30:55.708044	2025-05-16 20:30:55.708044	\N
924	Pitchblnd	\N	\N	2025-05-16 20:30:57.019643	2025-05-16 20:30:57.019643	\N
925	ARCS	\N	\N	2025-05-16 20:31:00.485563	2025-05-16 20:31:00.485563	\N
926	Kenneth P	\N	\N	2025-05-16 20:31:00.639304	2025-05-16 20:31:00.639304	\N
927	robin groulx	\N	\N	2025-05-16 20:31:00.979317	2025-05-16 20:31:00.979317	\N
928	Claymore	\N	\N	2025-05-16 20:31:02.108706	2025-05-16 20:31:02.108706	\N
929	Coogleme	\N	\N	2025-05-17 00:16:32.589557	2025-05-17 00:16:32.589557	\N
930	Johnny Malek	\N	\N	2025-05-17 00:16:32.60281	2025-05-17 00:16:32.60281	\N
931	McNasty	\N	\N	2025-05-17 00:16:32.610325	2025-05-17 00:16:32.610325	\N
932	Rustal	\N	\N	2025-05-17 03:30:59.491238	2025-05-17 03:30:59.491238	\N
933	Detune	\N	\N	2025-05-17 03:30:59.563975	2025-05-17 03:30:59.563975	\N
934	John Arnold	\N	\N	2025-05-17 03:30:59.582639	2025-05-17 03:30:59.582639	\N
935	Ron S.	\N	\N	2025-05-17 03:30:59.603473	2025-05-17 03:30:59.603473	\N
936	Will Web	\N	\N	2025-05-17 03:30:59.649	2025-05-17 03:30:59.649	\N
937	Japhy	\N	\N	2025-05-17 03:30:59.668695	2025-05-17 03:30:59.668695	\N
938	DJK	\N	\N	2025-05-17 03:30:59.675193	2025-05-17 03:30:59.675193	\N
939	Emanuel Eisbrenner	\N	\N	2025-05-17 03:30:59.680678	2025-05-17 03:30:59.680678	\N
940	Ron Mist	\N	\N	2025-05-17 03:30:59.686418	2025-05-17 03:30:59.686418	\N
941	Fold Theory	\N	\N	2025-05-17 03:30:59.697222	2025-05-17 03:30:59.697222	\N
942	Miss Powers	\N	\N	2025-05-17 03:30:59.704592	2025-05-17 03:30:59.704592	\N
943	T.Linder	\N	\N	2025-05-17 03:30:59.851912	2025-05-17 03:30:59.851912	\N
944	Neil V	\N	\N	2025-05-17 03:30:59.857169	2025-05-17 03:30:59.857169	\N
945	DJ Katalist	\N	\N	2025-05-17 03:30:59.872663	2025-05-17 03:30:59.872663	\N
946	G. Major	\N	\N	2025-05-17 03:30:59.888068	2025-05-17 03:30:59.888068	\N
947	Big Joe Hix	\N	\N	2025-05-17 03:30:59.907561	2025-05-17 03:30:59.907561	\N
948	DJ Dav	\N	\N	2025-05-17 03:30:59.916275	2025-05-17 03:30:59.916275	\N
949	Amateur Waifu	\N	\N	2025-05-17 03:30:59.92476	2025-05-17 03:30:59.92476	\N
950	Todd Weston	\N	\N	2025-05-17 03:30:59.934326	2025-05-17 03:30:59.934326	\N
951	Tokka	\N	\N	2025-05-17 03:31:00.144646	2025-05-17 03:31:00.144646	\N
952	Jeremiah (2)	\N	\N	2025-05-17 03:31:04.168062	2025-05-17 03:31:04.168062	\N
953	Tim Zawada	\N	\N	2025-05-17 03:31:04.17499	2025-05-17 03:31:04.17499	\N
954	Raybone Jones	\N	\N	2025-05-17 03:31:04.279354	2025-05-17 03:31:04.279354	\N
955	Calvin Morgan	\N	\N	2025-05-17 03:31:04.285663	2025-05-17 03:31:04.285663	\N
956	Matthew Scott	\N	\N	2025-05-17 03:31:05.197154	2025-05-17 03:31:05.197154	\N
957	Aluna	\N	\N	2025-05-17 03:31:06.00701	2025-05-17 03:31:06.00701	\N
958	Grace Arribas	\N	\N	2025-05-17 03:31:06.068922	2025-05-17 03:31:06.068922	\N
959	Big Strick	\N	\N	2025-05-17 20:30:56.422511	2025-05-17 20:30:56.422511	\N
960	Hardin	\N	\N	2025-05-18 20:30:57.981281	2025-05-18 20:30:57.981281	\N
961	Xav (US)	\N	\N	2025-05-19 20:31:01.933033	2025-05-19 20:31:01.933033	\N
962	STUKES	\N	\N	2025-05-19 20:31:01.989995	2025-05-19 20:31:01.989995	\N
963	HAL (6)	\N	\N	2025-05-19 20:31:02.59933	2025-05-19 20:31:02.59933	\N
964	Claiqlilia	\N	\N	2025-05-19 20:31:03.427657	2025-05-19 20:31:03.427657	\N
965	madeofants	\N	\N	2025-05-19 20:31:03.442123	2025-05-19 20:31:03.442123	\N
966	Rob Miller	\N	\N	2025-05-19 22:27:19.976289	2025-05-19 22:27:19.976289	\N
967	Dave Clevr	\N	\N	2025-05-19 22:27:19.992843	2025-05-19 22:27:19.992843	\N
968	DJ VPS	\N	\N	2025-05-19 22:27:20.001785	2025-05-19 22:27:20.001785	\N
969	Jason Garcia	\N	\N	2025-05-19 22:27:20.080452	2025-05-19 22:27:20.080452	\N
970	DetScientists	\N	\N	2025-05-19 22:27:20.11189	2025-05-19 22:27:20.11189	\N
971	Brandon Watkins	\N	\N	2025-05-19 22:27:20.245364	2025-05-19 22:27:20.245364	\N
972	Kruse Kontrol	\N	\N	2025-05-19 22:27:20.380044	2025-05-19 22:27:20.380044	\N
973	Sonik	\N	\N	2025-05-19 22:27:20.570158	2025-05-19 22:27:20.570158	\N
974	DJ Eddie Stewart	\N	\N	2025-05-19 22:27:20.70068	2025-05-19 22:27:20.70068	\N
975	Joshua Adams	\N	\N	2025-05-19 22:27:20.876107	2025-05-19 22:27:20.876107	\N
976	Moniker Set	\N	\N	2025-05-19 22:27:20.918689	2025-05-19 22:27:20.918689	\N
977	Jay Arthur	\N	\N	2025-05-19 22:27:20.928988	2025-05-19 22:27:20.928988	\N
978	Roland London	\N	\N	2025-05-19 22:27:20.970877	2025-05-19 22:27:20.970877	\N
979	Joe Gize	\N	\N	2025-05-19 22:27:20.997558	2025-05-19 22:27:20.997558	\N
980	Alex Shtaerman	\N	\N	2025-05-19 22:27:21.01173	2025-05-19 22:27:21.01173	\N
981	Juan Trevino	\N	\N	2025-05-19 22:27:21.023113	2025-05-19 22:27:21.023113	\N
982	Bethany Dzierwa	\N	\N	2025-05-19 22:27:21.032442	2025-05-19 22:27:21.032442	\N
983	DJ Krazy	\N	\N	2025-05-19 22:27:21.044536	2025-05-19 22:27:21.044536	\N
984	Perish	\N	\N	2025-05-20 03:30:46.215481	2025-05-20 03:30:46.215481	\N
985	WhereIsFenix	\N	\N	2025-05-20 03:30:48.970317	2025-05-20 03:30:48.970317	\N
986	SWDEJAY	\N	\N	2025-05-20 03:30:52.693976	2025-05-20 03:30:52.693976	\N
987	SKY JETTA	\N	\N	2025-05-20 20:31:01.831163	2025-05-20 20:31:01.831163	\N
988	Simple Cuts	\N	\N	2025-05-21 03:30:46.54707	2025-05-21 03:30:46.54707	\N
989	AIDEL	\N	\N	2025-05-21 20:31:15.380289	2025-05-21 20:31:15.380289	\N
990	autogyro	\N	\N	2025-05-21 20:31:15.448102	2025-05-21 20:31:15.448102	\N
991	Scott Ashley	\N	\N	2025-05-22 03:30:44.709054	2025-05-22 03:30:44.709054	\N
992	Mike Dearborn	\N	\N	2025-05-22 03:30:46.475638	2025-05-22 03:30:46.475638	\N
993	Bobby.	\N	\N	2025-05-22 03:30:48.263722	2025-05-22 03:30:48.263722	\N
994	3 Chairs	\N	\N	2025-05-22 03:30:48.702629	2025-05-22 03:30:48.702629	\N
995	Just Shacoi	\N	\N	2025-05-22 20:30:44.967198	2025-05-22 20:30:44.967198	\N
996	John Collins	\N	\N	2025-05-22 20:30:45.038315	2025-05-22 20:30:45.038315	\N
997	Mark Flash	\N	\N	2025-05-22 20:30:45.045575	2025-05-22 20:30:45.045575	\N
998	Spiñorita	\N	\N	2025-05-22 20:30:46.880437	2025-05-22 20:30:46.880437	\N
999	SEEPS	\N	\N	2025-05-22 20:30:48.369783	2025-05-22 20:30:48.369783	\N
1000	SKNDLSS	\N	\N	2025-05-22 20:30:48.514988	2025-05-22 20:30:48.514988	\N
1001	Pirahnahead	\N	\N	2025-05-22 20:30:48.579079	2025-05-22 20:30:48.579079	\N
1002	Fess Grandiose	\N	\N	2025-05-22 20:30:48.605081	2025-05-22 20:30:48.605081	\N
1003	Cinthie	\N	\N	2025-05-22 20:30:48.988818	2025-05-22 20:30:48.988818	\N
1004	Edgar Um	\N	\N	2025-05-22 20:30:48.993289	2025-05-22 20:30:48.993289	\N
1005	Party Boy Lance	\N	\N	2025-05-22 20:30:52.387009	2025-05-22 20:30:52.387009	\N
1006	Dj Jen	\N	\N	2025-05-22 22:36:13.054676	2025-05-22 22:36:13.054676	\N
1007	Summr Nites	\N	\N	2025-05-22 22:38:33.293846	2025-05-22 22:38:33.293846	\N
1008	Problematic Black Hottie	\N	\N	2025-05-22 22:42:11.422954	2025-05-22 22:42:11.422954	\N
1009	Steph Who?	\N	\N	2025-05-22 22:42:11.43826	2025-05-22 22:42:11.43826	\N
1010	DJ Her Boyfriend	\N	\N	2025-05-22 22:42:11.446683	2025-05-22 22:42:11.446683	\N
1011	Swingvibe	\N	\N	2025-05-22 22:42:11.459756	2025-05-22 22:42:11.459756	\N
1012	Monsuun	\N	\N	2025-05-22 22:42:11.46883	2025-05-22 22:42:11.46883	\N
1013	Billy Winters	\N	\N	2025-05-22 22:42:11.482404	2025-05-22 22:42:11.482404	\N
1014	Adam Dipaolo	\N	\N	2025-05-22 22:42:11.493213	2025-05-22 22:42:11.493213	\N
1015	C-Flo	\N	\N	2025-05-22 22:42:11.504565	2025-05-22 22:42:11.504565	\N
1016	Felice	\N	\N	2025-05-22 22:53:01.178059	2025-05-22 22:53:01.178059	\N
1017	Suitor	\N	\N	2025-05-22 22:53:01.186403	2025-05-22 22:53:01.186403	\N
1018	Qtc	\N	\N	2025-05-22 22:53:01.192688	2025-05-22 22:53:01.192688	\N
1019	Diego	\N	\N	2025-05-22 23:30:11.759951	2025-05-22 23:30:11.759951	\N
1020	Spinorita	\N	\N	2025-05-22 23:30:11.769799	2025-05-22 23:30:11.769799	\N
1021	Cousin Mouth	\N	\N	2025-05-22 23:30:11.777762	2025-05-22 23:30:11.777762	\N
1022	Wrckles	\N	\N	2025-05-22 23:44:50.816955	2025-05-22 23:44:50.816955	\N
1023	iii	\N	\N	2025-05-22 23:44:50.836611	2025-05-22 23:44:50.836611	\N
1024	Cye Pie	\N	\N	2025-05-22 23:44:50.851415	2025-05-22 23:44:50.851415	\N
1025	DON	\N	\N	2025-05-22 23:44:50.861123	2025-05-22 23:44:50.861123	\N
1026	Otez.G	\N	\N	2025-05-22 23:44:50.868711	2025-05-22 23:44:50.868711	\N
1027	Perry Mason	\N	\N	2025-05-22 23:52:12.66326	2025-05-22 23:52:12.66326	\N
1028	Adam Stanfel	\N	\N	2025-05-22 23:52:12.669562	2025-05-22 23:52:12.669562	\N
1029	ATM	\N	\N	2025-05-23 00:22:25.791719	2025-05-23 00:22:25.791719	\N
1030	Loading	\N	\N	2025-05-23 00:22:25.841274	2025-05-23 00:22:25.841274	\N
1031	Sincerely	\N	\N	2025-05-23 00:23:45.131503	2025-05-23 00:23:45.131503	\N
1032	Smooth Talk	\N	\N	2025-05-23 00:26:02.22922	2025-05-23 00:26:02.22922	\N
1033	888lambchop	\N	\N	2025-05-23 03:30:46.191547	2025-05-23 03:30:46.191547	\N
1034	we1sman	\N	\N	2025-05-23 03:30:46.232969	2025-05-23 03:30:46.232969	\N
1035	Sian	\N	\N	2025-05-23 03:30:46.2688	2025-05-23 03:30:46.2688	\N
1036	Eulalia	\N	\N	2025-05-23 03:30:46.280064	2025-05-23 03:30:46.280064	\N
1037	BLESSTONIO	\N	\N	2025-05-23 03:30:48.867768	2025-05-23 03:30:48.867768	\N
1038	TEO (CDN)	\N	\N	2025-05-24 20:30:57.228568	2025-05-24 20:30:57.228568	\N
1039	DJ BOS'N	\N	\N	2025-05-24 20:30:59.085879	2025-05-24 20:30:59.085879	\N
1040	Maheras	\N	\N	2025-05-25 03:31:35.029067	2025-05-25 03:31:35.029067	\N
1041	Cici	\N	\N	2025-05-25 03:31:37.623171	2025-05-25 03:31:37.623171	\N
1042	Sushi Ceej	\N	\N	2025-05-26 19:27:11.512696	2025-05-26 19:27:11.512696	\N
1043	Elijah James	\N	\N	2025-05-26 19:27:11.52719	2025-05-26 19:27:11.52719	\N
1044	Gold	\N	\N	2025-05-26 19:27:11.53587	2025-05-26 19:27:11.53587	\N
1045	Medha Achar	\N	\N	2025-05-26 20:31:13.691567	2025-05-26 20:31:13.691567	\N
1046	Martino Boga	\N	\N	2025-05-26 20:31:16.335971	2025-05-26 20:31:16.335971	\N
1047	Evan Oswald	\N	\N	2025-05-26 20:31:17.483217	2025-05-26 20:31:17.483217	\N
1048	Kaspar Lane	\N	\N	2025-05-26 20:31:19.187557	2025-05-26 20:31:19.187557	\N
1049	Ostara	\N	\N	2025-05-28 03:30:46.026926	2025-05-28 03:30:46.026926	\N
1050	PM	\N	\N	2025-05-28 03:30:46.112138	2025-05-28 03:30:46.112138	\N
1051	1 AM (1)	\N	\N	2025-05-28 03:30:46.119547	2025-05-28 03:30:46.119547	\N
1052	AM (8)	\N	\N	2025-05-28 03:30:46.125234	2025-05-28 03:30:46.125234	\N
1053	Russell E.L. Butler	\N	\N	2026-02-26 04:13:36.27913	2026-02-26 04:13:36.27913	\N
1054	Introspekt	\N	\N	2026-02-26 04:13:36.303886	2026-02-26 04:13:36.303886	\N
1055	Sister Zo	\N	\N	2026-02-26 04:13:36.367894	2026-02-26 04:13:36.367894	\N
1056	AZA	\N	\N	2026-02-26 04:13:36.699439	2026-02-26 04:13:36.699439	\N
1057	Function	\N	\N	2026-02-26 04:13:36.764466	2026-02-26 04:13:36.764466	\N
1058	Tauceti (FR)	\N	\N	2026-02-26 04:13:36.802951	2026-02-26 04:13:36.802951	\N
1059	LNS	\N	\N	2026-02-26 04:13:36.866366	2026-02-26 04:13:36.866366	\N
1060	D. Strange	\N	\N	2026-02-26 04:13:36.885728	2026-02-26 04:13:36.885728	\N
1061	Underground Resistance	\N	\N	2026-02-26 04:13:36.90149	2026-02-26 04:13:36.90149	\N
1062	Chuck Gunn	\N	\N	2026-02-26 04:13:37.077724	2026-02-26 04:13:37.077724	\N
1063	Jo Johnson	\N	\N	2026-02-26 04:13:37.084334	2026-02-26 04:13:37.084334	\N
1064	MERIVOR	\N	\N	2026-02-26 04:13:37.092766	2026-02-26 04:13:37.092766	\N
1065	Raica	\N	\N	2026-02-26 04:13:37.097847	2026-02-26 04:13:37.097847	\N
1066	Matias Aguayo	\N	\N	2026-02-26 04:13:37.112349	2026-02-26 04:13:37.112349	\N
1067	Yessi	\N	\N	2026-02-26 04:13:37.125183	2026-02-26 04:13:37.125183	\N
1068	Chloe Harris	\N	\N	2026-02-26 04:13:37.219044	2026-02-26 04:13:37.219044	\N
1069	Carrier	\N	\N	2026-02-26 04:13:37.223519	2026-02-26 04:13:37.223519	\N
1070	Hybrid	\N	\N	2026-02-26 04:13:37.465429	2026-02-26 04:13:37.465429	\N
1071	Vladimir Ivkovic	\N	\N	2026-02-26 04:13:37.476904	2026-02-26 04:13:37.476904	\N
1072	mad miran	\N	\N	2026-02-26 04:13:37.485905	2026-02-26 04:13:37.485905	\N
1073	Sepehr	\N	\N	2026-02-26 04:13:37.489974	2026-02-26 04:13:37.489974	\N
1074	Jlin	\N	\N	2026-02-26 04:13:37.605472	2026-02-26 04:13:37.605472	\N
1075	Batu	\N	\N	2026-02-26 04:13:37.610403	2026-02-26 04:13:37.610403	\N
1076	Laurel Halo	\N	\N	2026-02-26 04:13:37.614282	2026-02-26 04:13:37.614282	\N
1077	Carrier (Aus)	\N	\N	2026-02-26 04:13:37.682418	2026-02-26 04:13:37.682418	\N
1078	Emily Jeanne	\N	\N	2026-02-26 04:13:37.687972	2026-02-26 04:13:37.687972	\N
1079	DJ Plead	\N	\N	2026-02-26 04:13:37.692973	2026-02-26 04:13:37.692973	\N
1080	Mia Koden	\N	\N	2026-02-26 04:13:37.697494	2026-02-26 04:13:37.697494	\N
1081	Sha Ru	\N	\N	2026-02-26 04:13:37.702634	2026-02-26 04:13:37.702634	\N
1082	Ben Bondy	\N	\N	2026-02-26 04:13:37.709237	2026-02-26 04:13:37.709237	\N
1083	Special Guest DJ	\N	\N	2026-02-26 04:13:37.714109	2026-02-26 04:13:37.714109	\N
1084	DJ Dolla	\N	\N	2026-02-26 04:13:37.816234	2026-02-26 04:13:37.816234	\N
1085	flotussin	\N	\N	2026-02-26 04:13:37.820133	2026-02-26 04:13:37.820133	\N
1086	NEPTUNEFLESH	\N	\N	2026-02-26 04:13:37.868571	2026-02-26 04:13:37.868571	\N
1087	Sapphyre	\N	\N	2026-02-26 04:13:37.873188	2026-02-26 04:13:37.873188	\N
1088	SDOT MUSIC	\N	\N	2026-02-26 04:13:37.878365	2026-02-26 04:13:37.878365	\N
1089	DJ Pierre	\N	\N	2026-02-26 04:13:37.933215	2026-02-26 04:13:37.933215	\N
1090	J.Garcia	\N	\N	2026-02-26 04:13:38.016495	2026-02-26 04:13:38.016495	\N
1091	Tangle Garden (3)	\N	\N	2026-02-26 04:13:38.031307	2026-02-26 04:13:38.031307	\N
1092	Fadi Mohem	\N	\N	2026-02-26 04:13:38.937361	2026-02-26 04:13:38.937361	\N
1093	Wata Igarashi	\N	\N	2026-02-26 04:13:39.23092	2026-02-26 04:13:39.23092	\N
1094	Marcal	\N	\N	2026-02-26 04:13:39.246704	2026-02-26 04:13:39.246704	\N
1095	Yanamaste	\N	\N	2026-02-26 04:13:39.254292	2026-02-26 04:13:39.254292	\N
1096	Joey Beltram	\N	\N	2026-02-26 04:13:39.565859	2026-02-26 04:13:39.565859	\N
1097	Keoki	\N	\N	2026-02-26 04:13:39.584474	2026-02-26 04:13:39.584474	\N
1098	DJ SOUL SLINGER	\N	\N	2026-02-26 04:13:39.63649	2026-02-26 04:13:39.63649	\N
1099	Decibel Flekx	\N	\N	2026-02-26 04:13:39.646865	2026-02-26 04:13:39.646865	\N
1100	Hooraa	\N	\N	2026-02-26 04:13:39.656536	2026-02-26 04:13:39.656536	\N
1101	MTECH	\N	\N	2026-02-26 04:13:39.667224	2026-02-26 04:13:39.667224	\N
1102	AMO	\N	\N	2026-02-27 03:38:14.003856	2026-02-27 03:38:14.003856	\N
1103	Chad Andrew	\N	\N	2026-02-27 03:38:14.0995	2026-02-27 03:38:14.0995	\N
1104	Sam Gittis	\N	\N	2026-02-27 03:38:14.15362	2026-02-27 03:38:14.15362	\N
1105	San Dee	\N	\N	2026-02-27 03:38:14.192905	2026-02-27 03:38:14.192905	\N
1106	Satoshi Tomiie	\N	\N	2026-02-27 03:38:14.452072	2026-02-27 03:38:14.452072	\N
1107	Melody RA+RE	\N	\N	2026-02-27 03:38:14.468489	2026-02-27 03:38:14.468489	\N
1108	Kurilo	\N	\N	2026-02-27 03:38:14.482021	2026-02-27 03:38:14.482021	\N
1109	Manda Moor	\N	\N	2026-02-27 03:38:14.569903	2026-02-27 03:38:14.569903	\N
1110	Sirus Hood	\N	\N	2026-02-27 03:38:14.583148	2026-02-27 03:38:14.583148	\N
1111	Jean Pierre	\N	\N	2026-02-27 03:38:14.589011	2026-02-27 03:38:14.589011	\N
1112	Ms. Mada	\N	\N	2026-02-27 03:38:14.594922	2026-02-27 03:38:14.594922	\N
1113	Elliot Schooling	\N	\N	2026-02-27 03:38:14.693434	2026-02-27 03:38:14.693434	\N
1114	Liam Palmer	\N	\N	2026-02-27 03:38:14.701947	2026-02-27 03:38:14.701947	\N
1115	Julian Anthony	\N	\N	2026-02-27 03:38:14.748858	2026-02-27 03:38:14.748858	\N
1116	Luuk van Dijk	\N	\N	2026-02-27 03:38:14.753444	2026-02-27 03:38:14.753444	\N
1117	Laidlaw	\N	\N	2026-02-27 03:38:14.760656	2026-02-27 03:38:14.760656	\N
1118	Natalia Roth	\N	\N	2026-02-27 03:38:14.767379	2026-02-27 03:38:14.767379	\N
1119	Simone de Kunovich	\N	\N	2026-02-27 03:38:14.772401	2026-02-27 03:38:14.772401	\N
1120	Kaizen (2)	\N	\N	2026-02-27 03:38:14.794714	2026-02-27 03:38:14.794714	\N
1121	Nori	\N	\N	2026-02-27 03:38:14.805625	2026-02-27 03:38:14.805625	\N
1122	Carlos Chaparro	\N	\N	2026-02-27 03:38:14.850697	2026-02-27 03:38:14.850697	\N
1123	MEGUSTA	\N	\N	2026-02-27 03:38:14.87814	2026-02-27 03:38:14.87814	\N
1124	Cloonee	\N	\N	2026-02-27 03:38:14.991821	2026-02-27 03:38:14.991821	\N
1125	Ben Sterling	\N	\N	2026-02-27 03:38:15.003436	2026-02-27 03:38:15.003436	\N
1126	Gio Elia	\N	\N	2026-02-27 03:38:15.008107	2026-02-27 03:38:15.008107	\N
1127	Omar+	\N	\N	2026-02-27 03:38:15.013151	2026-02-27 03:38:15.013151	\N
1128	Salomé Le Chat	\N	\N	2026-02-27 03:38:15.020915	2026-02-27 03:38:15.020915	\N
1129	Anthony Attalla	\N	\N	2026-02-27 03:38:15.091394	2026-02-27 03:38:15.091394	\N
1130	Carlo Lio	\N	\N	2026-02-27 03:38:15.10185	2026-02-27 03:38:15.10185	\N
1131	LEFTI	\N	\N	2026-02-27 03:38:15.10811	2026-02-27 03:38:15.10811	\N
1132	Marco Lys	\N	\N	2026-02-27 03:38:15.114042	2026-02-27 03:38:15.114042	\N
1133	Siwell	\N	\N	2026-02-27 03:38:15.15955	2026-02-27 03:38:15.15955	\N
1134	Technasia	\N	\N	2026-02-27 03:38:15.165836	2026-02-27 03:38:15.165836	\N
1135	Danny Tenaglia	\N	\N	2026-02-27 03:38:15.190319	2026-02-27 03:38:15.190319	\N
1136	Radio Slave	\N	\N	2026-02-27 03:38:15.199986	2026-02-27 03:38:15.199986	\N
1137	Doc Martin	\N	\N	2026-02-27 03:38:15.251302	2026-02-27 03:38:15.251302	\N
1138	Tal Fussman	\N	\N	2026-02-27 03:38:15.261121	2026-02-27 03:38:15.261121	\N
1139	Anja Schneider	\N	\N	2026-02-27 03:38:15.267059	2026-02-27 03:38:15.267059	\N
1140	William Kiss	\N	\N	2026-02-27 03:38:15.274587	2026-02-27 03:38:15.274587	\N
1141	Adrian Mills	\N	\N	2026-02-27 03:38:15.31439	2026-02-27 03:38:15.31439	\N
1142	Cole Knight	\N	\N	2026-02-27 03:38:15.362814	2026-02-27 03:38:15.362814	\N
1143	Funk Tribu	\N	\N	2026-02-27 03:38:15.36866	2026-02-27 03:38:15.36866	\N
1144	I Hate Models	\N	\N	2026-02-27 03:38:15.374517	2026-02-27 03:38:15.374517	\N
1145	Indira Paganotto	\N	\N	2026-02-27 03:38:15.398017	2026-02-27 03:38:15.398017	\N
1146	Nico Moreno	\N	\N	2026-02-27 03:38:15.403591	2026-02-27 03:38:15.403591	\N
1147	Jamie Jones	\N	\N	2026-02-27 03:38:15.451303	2026-02-27 03:38:15.451303	\N
1148	Josh Baker	\N	\N	2026-02-27 03:38:15.456419	2026-02-27 03:38:15.456419	\N
1149	Justice	\N	\N	2026-02-27 03:38:15.462462	2026-02-27 03:38:15.462462	\N
1150	KETTAMA	\N	\N	2026-02-27 03:38:15.467182	2026-02-27 03:38:15.467182	\N
1151	Luke Dean_	\N	\N	2026-02-27 03:38:15.473821	2026-02-27 03:38:15.473821	\N
1152	Max Dean	\N	\N	2026-02-27 03:38:15.477167	2026-02-27 03:38:15.477167	\N
1153	Meduza	\N	\N	2026-02-27 03:38:15.483034	2026-02-27 03:38:15.483034	\N
1154	James Hype (UK)	\N	\N	2026-02-27 03:38:15.487233	2026-02-27 03:38:15.487233	\N
1155	PARAMIDA	\N	\N	2026-02-27 03:38:15.491476	2026-02-27 03:38:15.491476	\N
1156	PAWSA	\N	\N	2026-02-27 03:38:15.496739	2026-02-27 03:38:15.496739	\N
1157	Ranger Trucco	\N	\N	2026-02-27 03:38:15.535752	2026-02-27 03:38:15.535752	\N
1158	Cloudy	\N	\N	2026-02-27 03:38:15.546773	2026-02-27 03:38:15.546773	\N
1159	KUKO	\N	\N	2026-02-27 03:38:15.553026	2026-02-27 03:38:15.553026	\N
1160	NOVAH	\N	\N	2026-02-27 03:38:15.561593	2026-02-27 03:38:15.561593	\N
1161	TOKiMONSTA	\N	\N	2026-02-27 03:38:15.607119	2026-02-27 03:38:15.607119	\N
1162	Interplanetary Criminal	\N	\N	2026-02-27 03:38:15.633772	2026-02-27 03:38:15.633772	\N
1163	Skream	\N	\N	2026-02-27 03:38:15.638078	2026-02-27 03:38:15.638078	\N
1164	Tiga	\N	\N	2026-02-27 03:38:15.647625	2026-02-27 03:38:15.647625	\N
1165	TEED	\N	\N	2026-02-27 03:38:15.653411	2026-02-27 03:38:15.653411	\N
1166	MPH (1)	\N	\N	2026-02-27 03:38:15.657665	2026-02-27 03:38:15.657665	\N
1167	R/V Calypso	\N	\N	2026-02-27 03:38:15.661528	2026-02-27 03:38:15.661528	\N
1168	SOSA (UK)	\N	\N	2026-02-27 03:38:15.669533	2026-02-27 03:38:15.669533	\N
1169	East End Dubs	\N	\N	2026-02-27 03:38:15.673155	2026-02-27 03:38:15.673155	\N
1170	Locky	\N	\N	2026-02-27 03:38:15.678028	2026-02-27 03:38:15.678028	\N
1171	Tommy Phillips	\N	\N	2026-02-27 03:38:15.682688	2026-02-27 03:38:15.682688	\N
1172	Alignment	\N	\N	2026-02-27 03:38:15.750667	2026-02-27 03:38:15.750667	\N
1173	Johannes Schuster	\N	\N	2026-02-27 03:38:15.790807	2026-02-27 03:38:15.790807	\N
1174	Chris Avantgarde	\N	\N	2026-02-27 03:38:15.854371	2026-02-27 03:38:15.854371	\N
1175	Lumia	\N	\N	2026-02-27 03:38:15.864338	2026-02-27 03:38:15.864338	\N
1176	ATRIP	\N	\N	2026-02-27 03:38:15.868801	2026-02-27 03:38:15.868801	\N
1177	camoufly	\N	\N	2026-02-27 03:38:15.876863	2026-02-27 03:38:15.876863	\N
1178	Club Angel	\N	\N	2026-02-27 03:38:15.882424	2026-02-27 03:38:15.882424	\N
1179	Oppidan	\N	\N	2026-02-27 03:38:15.888496	2026-02-27 03:38:15.888496	\N
1180	Madota	\N	\N	2026-02-27 03:38:15.953155	2026-02-27 03:38:15.953155	\N
1181	Riordan	\N	\N	2026-02-27 03:38:15.972436	2026-02-27 03:38:15.972436	\N
1182	Six Sex	\N	\N	2026-02-27 03:38:15.996234	2026-02-27 03:38:15.996234	\N
1183	TOMI	\N	\N	2026-02-27 03:38:16.050131	2026-02-27 03:38:16.050131	\N
1184	Tomi & Kesh	\N	\N	2026-02-27 03:38:16.056332	2026-02-27 03:38:16.056332	\N
1185	VITO (UK)	\N	\N	2026-02-27 03:38:16.060535	2026-02-27 03:38:16.060535	\N
1186	Angel Heredia	\N	\N	2026-02-27 03:38:16.064264	2026-02-27 03:38:16.064264	\N
1187	Rafael (IS)	\N	\N	2026-02-27 03:38:16.146568	2026-02-27 03:38:16.146568	\N
1188	Alex Spanky	\N	\N	2026-02-27 03:38:16.180066	2026-02-27 03:38:16.180066	\N
1189	Redux Saints	\N	\N	2026-02-27 03:38:16.230848	2026-02-27 03:38:16.230848	\N
1190	Dj Seth Lowery	\N	\N	2026-02-27 03:38:16.243038	2026-02-27 03:38:16.243038	\N
1191	TriCade	\N	\N	2026-02-27 03:38:16.253903	2026-02-27 03:38:16.253903	\N
1192	Trizzoh	\N	\N	2026-02-27 03:38:16.263797	2026-02-27 03:38:16.263797	\N
1193	Oliver Heldens	\N	\N	2026-02-27 03:38:16.297918	2026-02-27 03:38:16.297918	\N
1194	Andrea Oliva	\N	\N	2026-02-27 03:38:16.330873	2026-02-27 03:38:16.330873	\N
1195	Harry Romero	\N	\N	2026-02-27 03:38:16.337621	2026-02-27 03:38:16.337621	\N
1196	HoneyLuv	\N	\N	2026-02-27 03:38:16.344846	2026-02-27 03:38:16.344846	\N
1197	Kellie Allen	\N	\N	2026-02-27 03:38:16.35053	2026-02-27 03:38:16.35053	\N
1198	Nic Fanciulli	\N	\N	2026-02-27 03:38:16.360146	2026-02-27 03:38:16.360146	\N
1199	Olive F	\N	\N	2026-02-27 03:38:16.364755	2026-02-27 03:38:16.364755	\N
1200	Harvard Bass	\N	\N	2026-02-27 03:38:16.489819	2026-02-27 03:38:16.489819	\N
1201	Hatiras	\N	\N	2026-02-27 03:38:16.495906	2026-02-27 03:38:16.495906	\N
1202	Jesse Perez	\N	\N	2026-02-27 03:38:16.535515	2026-02-27 03:38:16.535515	\N
1203	Roland Clark	\N	\N	2026-02-27 03:38:16.547802	2026-02-27 03:38:16.547802	\N
1204	Vampire Sex	\N	\N	2026-02-27 03:38:16.553317	2026-02-27 03:38:16.553317	\N
1205	Tiedye	\N	\N	2026-02-27 03:38:16.560995	2026-02-27 03:38:16.560995	\N
1206	AMPRS&ND	\N	\N	2026-02-27 03:38:16.565612	2026-02-27 03:38:16.565612	\N
1207	Casmalia	\N	\N	2026-02-27 03:38:16.570426	2026-02-27 03:38:16.570426	\N
1208	GOLES	\N	\N	2026-02-27 03:38:16.574589	2026-02-27 03:38:16.574589	\N
1209	Charles Meyer (US)	\N	\N	2026-02-27 03:38:16.582572	2026-02-27 03:38:16.582572	\N
1210	Scotty Boy	\N	\N	2026-02-27 03:38:16.634829	2026-02-27 03:38:16.634829	\N
1211	Tony H	\N	\N	2026-02-27 03:38:16.639753	2026-02-27 03:38:16.639753	\N
1212	Uriah G	\N	\N	2026-02-27 03:38:16.657661	2026-02-27 03:38:16.657661	\N
1213	Archie Hamilton	\N	\N	2026-02-27 03:38:16.849693	2026-02-27 03:38:16.849693	\N
1214	Fleur Shore	\N	\N	2026-02-27 03:38:16.854304	2026-02-27 03:38:16.854304	\N
1215	Hot Since 82	\N	\N	2026-02-27 03:38:16.857955	2026-02-27 03:38:16.857955	\N
1216	J. Worra	\N	\N	2026-02-27 03:38:16.935874	2026-02-27 03:38:16.935874	\N
1217	DREYA	\N	\N	2026-02-27 03:38:16.940092	2026-02-27 03:38:16.940092	\N
1218	Katie Ox	\N	\N	2026-02-27 03:38:16.943913	2026-02-27 03:38:16.943913	\N
1219	future.666	\N	\N	2026-02-27 03:38:16.947526	2026-02-27 03:38:16.947526	\N
1220	fumi (DE)	\N	\N	2026-02-27 03:38:16.951249	2026-02-27 03:38:16.951249	\N
1221	ALEJO (US)	\N	\N	2026-02-27 03:38:16.955085	2026-02-27 03:38:16.955085	\N
1222	Robyn Sin Love	\N	\N	2026-02-27 03:38:16.959081	2026-02-27 03:38:16.959081	\N
1223	Pegassi	\N	\N	2026-02-27 03:38:16.965339	2026-02-27 03:38:16.965339	\N
1224	Serafina	\N	\N	2026-02-27 03:38:16.968975	2026-02-27 03:38:16.968975	\N
1225	Jamback	\N	\N	2026-02-27 03:38:16.972653	2026-02-27 03:38:16.972653	\N
1226	Marsolo	\N	\N	2026-02-27 03:38:17.036117	2026-02-27 03:38:17.036117	\N
1227	M-High	\N	\N	2026-02-27 03:38:17.040482	2026-02-27 03:38:17.040482	\N
1228	Just Joe	\N	\N	2026-02-27 03:38:17.05608	2026-02-27 03:38:17.05608	\N
1229	Partiboi69	\N	\N	2026-02-27 03:38:17.063602	2026-02-27 03:38:17.063602	\N
1230	Juicy Romance	\N	\N	2026-02-27 03:38:17.072069	2026-02-27 03:38:17.072069	\N
1231	Inès Rau	\N	\N	2026-02-27 03:38:17.077335	2026-02-27 03:38:17.077335	\N
1232	Spencer Brown	\N	\N	2026-02-27 03:38:17.148552	2026-02-27 03:38:17.148552	\N
1233	Ultra Naté	\N	\N	2026-02-27 03:38:17.166514	2026-02-27 03:38:17.166514	\N
1234	Rissa Garcia	\N	\N	2026-02-27 03:38:17.17409	2026-02-27 03:38:17.17409	\N
1235	Gerd Janson	\N	\N	2026-02-27 03:38:17.236615	2026-02-27 03:38:17.236615	\N
1236	Mai iachetti	\N	\N	2026-02-27 03:38:17.24107	2026-02-27 03:38:17.24107	\N
1237	Bakke	\N	\N	2026-02-27 03:38:17.245497	2026-02-27 03:38:17.245497	\N
1238	Main Phase	\N	\N	2026-02-27 03:38:17.26447	2026-02-27 03:38:17.26447	\N
1239	Mira	\N	\N	2026-02-27 03:38:17.350174	2026-02-27 03:38:17.350174	\N
1240	Ro Rousseau	\N	\N	2026-02-27 03:38:17.356908	2026-02-27 03:38:17.356908	\N
1241	Riva + Bianca	\N	\N	2026-02-27 03:38:17.383575	2026-02-27 03:38:17.383575	\N
1242	Sunday Double	\N	\N	2026-02-27 03:38:17.433587	2026-02-27 03:38:17.433587	\N
1243	Bad Boombox	\N	\N	2026-02-27 03:38:17.478158	2026-02-27 03:38:17.478158	\N
1244	Ollie Lishman	\N	\N	2026-02-27 03:38:17.53471	2026-02-27 03:38:17.53471	\N
1245	PETERBLUE	\N	\N	2026-02-27 03:38:17.548765	2026-02-27 03:38:17.548765	\N
1246	Audien	\N	\N	2026-02-27 03:38:17.573426	2026-02-27 03:38:17.573426	\N
1247	Justin Mylo	\N	\N	2026-02-27 03:38:17.57981	2026-02-27 03:38:17.57981	\N
1248	Lucas & Steve	\N	\N	2026-02-27 03:38:17.584253	2026-02-27 03:38:17.584253	\N
1249	Peppe Citarella	\N	\N	2026-02-27 03:38:17.678619	2026-02-27 03:38:17.678619	\N
1250	Hector Romero	\N	\N	2026-02-27 03:38:17.684696	2026-02-27 03:38:17.684696	\N
1251	Chesster	\N	\N	2026-02-27 03:38:17.747582	2026-02-27 03:38:17.747582	\N
1252	Klaudie	\N	\N	2026-02-27 03:38:17.753846	2026-02-27 03:38:17.753846	\N
1253	Verso	\N	\N	2026-02-27 03:38:17.75969	2026-02-27 03:38:17.75969	\N
1254	Shawn Jackson	\N	\N	2026-02-27 03:38:17.891744	2026-02-27 03:38:17.891744	\N
1255	Lauren Mayhew	\N	\N	2026-02-27 03:38:17.897729	2026-02-27 03:38:17.897729	\N
1256	Oscar N (US)	\N	\N	2026-02-27 03:38:17.903236	2026-02-27 03:38:17.903236	\N
1257	Gianni Petrarca	\N	\N	2026-02-27 03:38:17.946649	2026-02-27 03:38:17.946649	\N
1258	Rebolledo	\N	\N	2026-02-27 03:38:17.975593	2026-02-27 03:38:17.975593	\N
1259	Manumat	\N	\N	2026-02-27 03:38:18.022189	2026-02-27 03:38:18.022189	\N
1260	Nala	\N	\N	2026-02-27 03:38:18.129137	2026-02-27 03:38:18.129137	\N
1261	Alex Cecil	\N	\N	2026-02-27 03:38:18.197184	2026-02-27 03:38:18.197184	\N
1262	KIQI	\N	\N	2026-02-27 03:38:18.217482	2026-02-27 03:38:18.217482	\N
1263	sumkind	\N	\N	2026-02-27 03:38:18.240245	2026-02-27 03:38:18.240245	\N
1264	Sosh & Mosh	\N	\N	2026-02-27 03:38:18.251493	2026-02-27 03:38:18.251493	\N
1265	Prunk	\N	\N	2026-02-27 03:38:18.337575	2026-02-27 03:38:18.337575	\N
1266	Ronnie Spiteri	\N	\N	2026-02-27 03:38:18.41068	2026-02-27 03:38:18.41068	\N
1267	DJ Chus	\N	\N	2026-02-27 03:38:18.536102	2026-02-27 03:38:18.536102	\N
1268	Joeski	\N	\N	2026-02-27 03:38:18.576576	2026-02-27 03:38:18.576576	\N
1269	DJ Joeski	\N	\N	2026-02-27 03:38:18.589257	2026-02-27 03:38:18.589257	\N
1270	Patrick M	\N	\N	2026-02-27 03:38:18.604631	2026-02-27 03:38:18.604631	\N
1271	Supernova	\N	\N	2026-02-27 03:38:18.611933	2026-02-27 03:38:18.611933	\N
1272	Vidaloca	\N	\N	2026-02-27 03:38:18.620758	2026-02-27 03:38:18.620758	\N
1273	Yulia Niko	\N	\N	2026-02-27 03:38:18.626616	2026-02-27 03:38:18.626616	\N
1274	Amine K	\N	\N	2026-02-27 03:38:18.631562	2026-02-27 03:38:18.631562	\N
1275	Óscar de Rivera	\N	\N	2026-02-27 03:38:18.637806	2026-02-27 03:38:18.637806	\N
1276	Organic	\N	\N	2026-02-27 03:38:18.690524	2026-02-27 03:38:18.690524	\N
1277	Qrion	\N	\N	2026-02-27 03:38:18.70258	2026-02-27 03:38:18.70258	\N
1278	Massane	\N	\N	2026-02-27 03:38:18.709689	2026-02-27 03:38:18.709689	\N
1279	Because of Art	\N	\N	2026-02-27 03:38:18.73801	2026-02-27 03:38:18.73801	\N
1280	Alaya (PT)	\N	\N	2026-02-27 03:38:18.936665	2026-02-27 03:38:18.936665	\N
1281	Darin Epsilon	\N	\N	2026-02-27 03:38:19.033696	2026-02-27 03:38:19.033696	\N
1282	Min the Universe	\N	\N	2026-02-27 03:38:19.038187	2026-02-27 03:38:19.038187	\N
1283	Sydney Blu	\N	\N	2026-02-27 03:38:19.042541	2026-02-27 03:38:19.042541	\N
1284	DJ Dove	\N	\N	2026-02-27 03:38:19.242903	2026-02-27 03:38:19.242903	\N
1285	Emmaculate	\N	\N	2026-02-27 03:38:19.259785	2026-02-27 03:38:19.259785	\N
1286	Lazaro Casanova	\N	\N	2026-02-27 03:38:19.348188	2026-02-27 03:38:19.348188	\N
1287	Oscar G	\N	\N	2026-02-27 03:38:19.433572	2026-02-27 03:38:19.433572	\N
1288	Stacy Kidd	\N	\N	2026-02-27 03:38:19.443998	2026-02-27 03:38:19.443998	\N
1289	L.P. Rhythm	\N	\N	2026-02-27 03:38:19.549091	2026-02-27 03:38:19.549091	\N
1290	Rana Iravani	\N	\N	2026-02-27 03:38:19.558105	2026-02-27 03:38:19.558105	\N
1291	Sidney Charles	\N	\N	2026-02-27 03:38:19.563117	2026-02-27 03:38:19.563117	\N
1292	Carlita	\N	\N	2026-02-27 03:38:19.567853	2026-02-27 03:38:19.567853	\N
1293	Jaden Thompson	\N	\N	2026-02-27 03:38:19.631942	2026-02-27 03:38:19.631942	\N
1294	AC13	\N	\N	2026-02-27 03:38:19.636446	2026-02-27 03:38:19.636446	\N
1295	Harriet Jaxxon	\N	\N	2026-02-27 03:38:19.640145	2026-02-27 03:38:19.640145	\N
1296	Hybrid Minds	\N	\N	2026-02-27 03:38:19.651475	2026-02-27 03:38:19.651475	\N
1297	Rohaan	\N	\N	2026-02-27 03:38:19.655983	2026-02-27 03:38:19.655983	\N
1298	What So Not	\N	\N	2026-02-27 03:38:19.659908	2026-02-27 03:38:19.659908	\N
1299	Mija	\N	\N	2026-02-27 03:38:19.705948	2026-02-27 03:38:19.705948	\N
1300	Dan Ghenacia	\N	\N	2026-02-27 03:38:19.751555	2026-02-27 03:38:19.751555	\N
1301	LP Giobbi	\N	\N	2026-02-27 03:38:19.779065	2026-02-27 03:38:19.779065	\N
1302	Seven Lions	\N	\N	2026-02-27 03:38:19.790265	2026-02-27 03:38:19.790265	\N
1303	Nick Warren	\N	\N	2026-02-27 03:38:19.845574	2026-02-27 03:38:19.845574	\N
1304	Goosey	\N	\N	2026-02-27 03:38:19.94323	2026-02-27 03:38:19.94323	\N
1305	RUZE	\N	\N	2026-02-27 03:38:19.949036	2026-02-27 03:38:19.949036	\N
1306	Edd (1)	\N	\N	2026-02-27 03:38:19.994511	2026-02-27 03:38:19.994511	\N
1307	AGELESS	\N	\N	2026-02-27 03:38:20.041392	2026-02-27 03:38:20.041392	\N
1308	Nicolas Matar	\N	\N	2026-02-27 03:38:20.048954	2026-02-27 03:38:20.048954	\N
1309	Diplo	\N	\N	2026-02-27 03:38:20.062268	2026-02-27 03:38:20.062268	\N
1310	Cosmic Gate	\N	\N	2026-02-27 03:38:20.133243	2026-02-27 03:38:20.133243	\N
1311	Luccio	\N	\N	2026-02-27 03:38:20.141587	2026-02-27 03:38:20.141587	\N
1312	Nicole Moudaber	\N	\N	2026-02-27 03:38:20.159852	2026-02-27 03:38:20.159852	\N
1313	Jonathan Cowan	\N	\N	2026-02-27 03:38:20.167379	2026-02-27 03:38:20.167379	\N
1314	Romina Mazzini	\N	\N	2026-02-27 03:38:20.17551	2026-02-27 03:38:20.17551	\N
1315	Louie Vega	\N	\N	2026-02-27 03:38:20.235269	2026-02-27 03:38:20.235269	\N
1316	Anane	\N	\N	2026-02-27 03:38:20.244356	2026-02-27 03:38:20.244356	\N
1317	Karizma	\N	\N	2026-02-27 03:38:20.249232	2026-02-27 03:38:20.249232	\N
1318	Cristobal Pesce	\N	\N	2026-02-27 03:38:20.269407	2026-02-27 03:38:20.269407	\N
1319	Lara Klart	\N	\N	2026-02-27 03:38:20.27617	2026-02-27 03:38:20.27617	\N
1320	Gioh Cecato	\N	\N	2026-02-27 03:38:20.288137	2026-02-27 03:38:20.288137	\N
1321	Jay Toledo	\N	\N	2026-02-27 03:38:20.333731	2026-02-27 03:38:20.333731	\N
1322	KETTING	\N	\N	2026-02-27 03:38:20.338239	2026-02-27 03:38:20.338239	\N
1323	Black Coffee	\N	\N	2026-02-27 03:38:20.538312	2026-02-27 03:38:20.538312	\N
1324	Luciano	\N	\N	2026-02-27 03:38:20.565637	2026-02-27 03:38:20.565637	\N
1325	Toman	\N	\N	2026-02-27 03:38:20.573865	2026-02-27 03:38:20.573865	\N
1326	Silvie Loto	\N	\N	2026-02-27 03:38:20.582659	2026-02-27 03:38:20.582659	\N
1327	Nicole Gallamini	\N	\N	2026-02-27 03:38:20.632909	2026-02-27 03:38:20.632909	\N
1328	Anetha	\N	\N	2026-02-27 03:38:20.676487	2026-02-27 03:38:20.676487	\N
1329	Souls Departed	\N	\N	2026-02-27 03:38:20.690718	2026-02-27 03:38:20.690718	\N
1330	Ammo Avenue	\N	\N	2026-02-27 03:38:20.735646	2026-02-27 03:38:20.735646	\N
1331	Claudio	\N	\N	2026-02-27 03:38:20.740473	2026-02-27 03:38:20.740473	\N
1332	slugg	\N	\N	2026-02-27 03:38:20.754849	2026-02-27 03:38:20.754849	\N
1333	Rodriguez Jr.	\N	\N	2026-02-27 03:38:20.862342	2026-02-27 03:38:20.862342	\N
1334	Nico Morano	\N	\N	2026-02-27 03:38:20.866796	2026-02-27 03:38:20.866796	\N
1335	Lady Vusumzi	\N	\N	2026-02-27 03:38:20.947573	2026-02-27 03:38:20.947573	\N
1336	Marten Hørger	\N	\N	2026-02-27 03:38:20.977227	2026-02-27 03:38:20.977227	\N
1337	Todd Terry	\N	\N	2026-02-27 03:38:21.040149	2026-02-27 03:38:21.040149	\N
1338	Diego Barrera	\N	\N	2026-02-27 03:38:21.046955	2026-02-27 03:38:21.046955	\N
1339	Franz (IT)	\N	\N	2026-02-27 03:38:21.065759	2026-02-27 03:38:21.065759	\N
1340	You Liang	\N	\N	2026-02-27 03:38:21.070794	2026-02-27 03:38:21.070794	\N
1341	Deekline	\N	\N	2026-02-27 03:38:21.141155	2026-02-27 03:38:21.141155	\N
1342	DJ Genesis	\N	\N	2026-02-27 03:38:21.145661	2026-02-27 03:38:21.145661	\N
1343	Slug (US)	\N	\N	2026-02-27 03:38:21.150347	2026-02-27 03:38:21.150347	\N
1344	Bradley Drop	\N	\N	2026-02-27 03:38:21.15544	2026-02-27 03:38:21.15544	\N
1345	Eartight	\N	\N	2026-02-27 03:38:21.160009	2026-02-27 03:38:21.160009	\N
1346	Dominik Audio	\N	\N	2026-02-27 03:38:21.166107	2026-02-27 03:38:21.166107	\N
1347	Prato	\N	\N	2026-02-27 03:38:21.170926	2026-02-27 03:38:21.170926	\N
1348	Brook B	\N	\N	2026-02-27 03:38:21.175892	2026-02-27 03:38:21.175892	\N
1349	Malone	\N	\N	2026-02-27 03:38:21.262411	2026-02-27 03:38:21.262411	\N
1350	Aline Rocha	\N	\N	2026-02-27 03:38:21.362246	2026-02-27 03:38:21.362246	\N
1351	Natasha Diggs	\N	\N	2026-02-27 03:38:21.371137	2026-02-27 03:38:21.371137	\N
1352	Yasmin	\N	\N	2026-02-27 03:38:21.437975	2026-02-27 03:38:21.437975	\N
1353	Ilario Alicante	\N	\N	2026-02-27 03:38:21.493242	2026-02-27 03:38:21.493242	\N
1354	Jay de Lys	\N	\N	2026-02-27 03:38:21.534895	2026-02-27 03:38:21.534895	\N
1355	Matroda	\N	\N	2026-02-27 03:38:21.548436	2026-02-27 03:38:21.548436	\N
1356	Tini Gessler	\N	\N	2026-02-27 03:38:21.570275	2026-02-27 03:38:21.570275	\N
1357	EMJIE	\N	\N	2026-02-27 03:38:21.581356	2026-02-27 03:38:21.581356	\N
1358	Nikita Green	\N	\N	2026-02-27 03:38:21.590593	2026-02-27 03:38:21.590593	\N
1359	hhunter	\N	\N	2026-02-27 03:38:21.644481	2026-02-27 03:38:21.644481	\N
1360	Bontan	\N	\N	2026-02-27 03:38:21.655563	2026-02-27 03:38:21.655563	\N
1361	Notre Dame	\N	\N	2026-02-27 03:38:21.663178	2026-02-27 03:38:21.663178	\N
1362	Rafael	\N	\N	2026-02-27 03:38:21.667765	2026-02-27 03:38:21.667765	\N
1363	KinAhau	\N	\N	2026-02-27 03:38:21.734455	2026-02-27 03:38:21.734455	\N
1364	Marte	\N	\N	2026-02-27 03:38:21.74107	2026-02-27 03:38:21.74107	\N
1365	Silva Bumpa	\N	\N	2026-02-27 03:38:21.747018	2026-02-27 03:38:21.747018	\N
1366	SLAMM	\N	\N	2026-02-27 03:38:21.751067	2026-02-27 03:38:21.751067	\N
1367	ChaseWest	\N	\N	2026-02-27 03:38:21.754721	2026-02-27 03:38:21.754721	\N
1368	Yamagucci	\N	\N	2026-02-27 03:38:21.75869	2026-02-27 03:38:21.75869	\N
1369	Oscar P	\N	\N	2026-02-27 03:38:21.842131	2026-02-27 03:38:21.842131	\N
1370	Jesse Chavarin	\N	\N	2026-02-27 03:38:21.85223	2026-02-27 03:38:21.85223	\N
1371	Nutritious	\N	\N	2026-02-27 03:38:21.858043	2026-02-27 03:38:21.858043	\N
1372	Maddix	\N	\N	2026-02-27 03:38:22.061629	2026-02-27 03:38:22.061629	\N
1373	AC Slater	\N	\N	2026-02-27 03:38:22.141264	2026-02-27 03:38:22.141264	\N
1374	Heimlich Knüller	\N	\N	2026-02-27 03:38:22.160948	2026-02-27 03:38:22.160948	\N
1375	eveava	\N	\N	2026-02-27 03:38:22.168809	2026-02-27 03:38:22.168809	\N
1376	22 Weeks	\N	\N	2026-02-27 05:42:42.46486	2026-02-27 05:42:42.46486	\N
1377	Avilo	\N	\N	2026-02-27 05:42:42.480092	2026-02-27 05:42:42.480092	\N
1378	Blankchecks	\N	\N	2026-02-27 05:42:42.495169	2026-02-27 05:42:42.495169	\N
1379	JAREB34R	\N	\N	2026-02-27 05:42:42.503171	2026-02-27 05:42:42.503171	\N
1380	TEGI	\N	\N	2026-02-27 05:42:42.511011	2026-02-27 05:42:42.511011	\N
1381	Bakki	\N	\N	2026-02-27 05:42:42.519835	2026-02-27 05:42:42.519835	\N
1382	Monrroe	\N	\N	2026-02-27 05:49:32.359604	2026-02-27 05:49:32.359604	\N
1383	Sustance	\N	\N	2026-02-27 05:49:32.371081	2026-02-27 05:49:32.371081	\N
1384	Rumble in the Jungle Crew	\N	\N	2026-02-27 05:49:32.378173	2026-02-27 05:49:32.378173	\N
1385	Alphaxero	\N	\N	2026-02-27 05:49:32.38414	2026-02-27 05:49:32.38414	\N
1386	Orchid	\N	\N	2026-02-27 05:49:32.393051	2026-02-27 05:49:32.393051	\N
1387	AmericanGrime	\N	\N	2026-02-27 05:49:32.399285	2026-02-27 05:49:32.399285	\N
1388	Sneaker	\N	\N	2026-02-27 20:31:21.856046	2026-02-27 20:31:21.856046	\N
1389	Fred P	\N	\N	2026-02-27 20:31:22.383319	2026-02-27 20:31:22.383319	\N
1390	Big Body Kito	\N	\N	2026-02-27 23:12:03.317582	2026-02-27 23:12:03.317582	\N
1391	ROMI LUX	\N	\N	2026-02-28 02:37:48.841423	2026-02-28 02:37:48.841423	\N
1392	JUDE & FRANK	\N	\N	2026-02-28 02:37:49.030014	2026-02-28 02:37:49.030014	\N
1393	TONY ZUCCARO	\N	\N	2026-02-28 02:37:49.137602	2026-02-28 02:37:49.137602	\N
1394	GT_OFICE	\N	\N	2026-02-28 02:37:49.148127	2026-02-28 02:37:49.148127	\N
1395	BONNIE X CLYDE	\N	\N	2026-02-28 02:37:49.156986	2026-02-28 02:37:49.156986	\N
1396	Gabss	\N	\N	2026-02-28 03:58:04.890195	2026-02-28 03:58:04.890195	\N
1397	Greg 99	\N	\N	2026-02-28 03:58:04.936614	2026-02-28 03:58:04.936614	\N
1398	EsDeeKid	\N	\N	2026-02-28 04:39:26.142591	2026-02-28 04:39:26.142591	\N
1399	SlapFunk	\N	\N	2026-02-28 04:50:11.628805	2026-02-28 04:50:11.628805	\N
1400	Yoyaku	\N	\N	2026-02-28 04:50:11.636003	2026-02-28 04:50:11.636003	\N
1401	Zoe Gitter	\N	\N	2026-02-28 04:57:28.013503	2026-02-28 04:57:28.013503	\N
1402	Loofy	\N	\N	2026-02-28 04:57:28.022313	2026-02-28 04:57:28.022313	\N
1403	Lauren Lane	\N	\N	2026-02-28 04:57:28.032952	2026-02-28 04:57:28.032952	\N
1404	Yokai	\N	\N	2026-02-28 04:57:28.038233	2026-02-28 04:57:28.038233	\N
1405	Marco Carola	\N	\N	2026-02-28 05:10:03.4658	2026-02-28 05:10:03.4658	\N
1406	Swimming Paul	\N	\N	2026-02-28 05:18:05.701611	2026-02-28 05:18:05.701611	\N
1407	Seven Liona	\N	\N	2026-02-28 05:56:57.989771	2026-02-28 05:56:57.989771	\N
1408	A Hundred Drums	\N	\N	2026-02-28 05:56:57.995179	2026-02-28 05:56:57.995179	\N
1409	Andrew Bayer	\N	\N	2026-02-28 05:56:58.000243	2026-02-28 05:56:58.000243	\N
1410	CASSIMM	\N	\N	2026-03-01 04:28:20.189973	2026-03-01 04:28:20.189973	\N
1411	CHUS & CEBALLOS	\N	\N	2026-03-01 04:28:20.205878	2026-03-01 04:28:20.205878	\N
1412	CRUSY	\N	\N	2026-03-01 04:28:20.214036	2026-03-01 04:28:20.214036	\N
1413	ESSEL	\N	\N	2026-03-01 04:28:20.224175	2026-03-01 04:28:20.224175	\N
1414	HATIRAS	\N	\N	2026-03-01 04:28:20.233746	2026-03-01 04:28:20.233746	\N
1415	ILLYUS BARRIENTOS	\N	\N	2026-03-01 04:28:20.261207	2026-03-01 04:28:20.261207	\N
1416	JAMES HURR	\N	\N	2026-03-01 04:28:20.268118	2026-03-01 04:28:20.268118	\N
1417	LOVRA	\N	\N	2026-03-01 04:28:20.276029	2026-03-01 04:28:20.276029	\N
1418	MARCO LYS	\N	\N	2026-03-01 04:28:20.286531	2026-03-01 04:28:20.286531	\N
1419	MARK KNIGHT	\N	\N	2026-03-01 04:28:20.295282	2026-03-01 04:28:20.295282	\N
1420	MARTIN IKIN	\N	\N	2026-03-01 04:28:20.304418	2026-03-01 04:28:20.304418	\N
1421	NOIZU	\N	\N	2026-03-01 04:28:20.315637	2026-03-01 04:28:20.315637	\N
1422	TITA LAU	\N	\N	2026-03-01 04:28:20.324381	2026-03-01 04:28:20.324381	\N
1423	TONY RAMOERA	\N	\N	2026-03-01 04:28:20.355909	2026-03-01 04:28:20.355909	\N
1424	WH0	\N	\N	2026-03-01 04:28:20.362083	2026-03-01 04:28:20.362083	\N
1425	Room 131	\N	\N	2026-03-02 20:31:24.993842	2026-03-02 20:31:24.993842	\N
1426	DJ Kemit	\N	\N	2026-03-02 20:31:25.045303	2026-03-02 20:31:25.045303	\N
1427	Musumeci	\N	\N	2026-03-03 06:50:09.802421	2026-03-03 06:50:09.802421	\N
1428	Israel Sunshine	\N	\N	2026-03-03 06:50:09.814468	2026-03-03 06:50:09.814468	\N
1429	Crusy	\N	\N	2026-03-03 06:50:09.908515	2026-03-03 06:50:09.908515	\N
1430	Gene Farris	\N	\N	2026-03-03 06:50:09.930463	2026-03-03 06:50:09.930463	\N
1431	OFFAIAH	\N	\N	2026-03-03 06:50:09.937802	2026-03-03 06:50:09.937802	\N
1432	Shiba San	\N	\N	2026-03-03 06:50:09.956077	2026-03-03 06:50:09.956077	\N
1433	Tony Romera	\N	\N	2026-03-03 06:50:09.962453	2026-03-03 06:50:09.962453	\N
1434	John Digweed	\N	\N	2026-03-03 06:50:10.370182	2026-03-03 06:50:10.370182	\N
1435	Adam Collins	\N	\N	2026-03-03 06:50:10.939778	2026-03-03 06:50:10.939778	\N
1436	Desyn	\N	\N	2026-03-03 06:50:10.950401	2026-03-03 06:50:10.950401	\N
1437	Fumiya Tanaka	\N	\N	2026-03-03 06:50:10.959307	2026-03-03 06:50:10.959307	\N
1438	Ika (GE)	\N	\N	2026-03-03 06:50:10.968049	2026-03-03 06:50:10.968049	\N
1439	Usherenko	\N	\N	2026-03-03 06:50:10.972324	2026-03-03 06:50:10.972324	\N
1440	Kev Gee	\N	\N	2026-03-03 06:50:10.976482	2026-03-03 06:50:10.976482	\N
1441	Krol	\N	\N	2026-03-03 06:50:10.983405	2026-03-03 06:50:10.983405	\N
1442	Rakim Under	\N	\N	2026-03-03 06:50:11.133846	2026-03-03 06:50:11.133846	\N
1443	Terence Tabeau	\N	\N	2026-03-03 06:50:11.143431	2026-03-03 06:50:11.143431	\N
1444	Tobias Lindén	\N	\N	2026-03-03 06:50:11.150317	2026-03-03 06:50:11.150317	\N
1445	Will Renuart	\N	\N	2026-03-03 06:50:11.15434	2026-03-03 06:50:11.15434	\N
1446	James Hurr	\N	\N	2026-03-03 06:50:11.336842	2026-03-03 06:50:11.336842	\N
1447	Milk & Sugar	\N	\N	2026-03-03 06:50:11.341963	2026-03-03 06:50:11.341963	\N
1448	Doc Brown	\N	\N	2026-03-03 06:50:11.352934	2026-03-03 06:50:11.352934	\N
1449	Kristina Sky	\N	\N	2026-03-03 06:50:11.370892	2026-03-03 06:50:11.370892	\N
1450	Puma (US)	\N	\N	2026-03-03 06:50:12.030121	2026-03-03 06:50:12.030121	\N
1451	Steve Lawler	\N	\N	2026-03-03 06:50:12.182849	2026-03-03 06:50:12.182849	\N
1452	Eli Fola	\N	\N	2026-03-03 06:50:12.187755	2026-03-03 06:50:12.187755	\N
1453	Ella Romand	\N	\N	2026-03-03 06:50:12.233486	2026-03-03 06:50:12.233486	\N
1454	Demarkus Lewis	\N	\N	2026-03-03 06:50:12.871646	2026-03-03 06:50:12.871646	\N
1455	Atomyard	\N	\N	2026-03-03 06:50:12.876717	2026-03-03 06:50:12.876717	\N
1456	Leo Del Toro	\N	\N	2026-03-03 06:50:12.880814	2026-03-03 06:50:12.880814	\N
1457	Stefano Noferini	\N	\N	2026-03-03 06:50:13.63513	2026-03-03 06:50:13.63513	\N
1458	Dimmish	\N	\N	2026-03-03 06:50:13.641581	2026-03-03 06:50:13.641581	\N
1459	Joe Vanditti	\N	\N	2026-03-03 06:50:13.731336	2026-03-03 06:50:13.731336	\N
1460	Mandiz	\N	\N	2026-03-03 06:50:13.831594	2026-03-03 06:50:13.831594	\N
1461	Malika	\N	\N	2026-03-03 20:31:25.579795	2026-03-03 20:31:25.579795	\N
1462	Mari.te	\N	\N	2026-03-03 20:31:25.592954	2026-03-03 20:31:25.592954	\N
1463	Aline Umber	\N	\N	2026-03-05 20:31:18.536483	2026-03-05 20:31:18.536483	\N
1464	Greg Paulus	\N	\N	2026-03-05 20:31:18.578773	2026-03-05 20:31:18.578773	\N
1465	Luke Hess	\N	\N	2026-03-05 20:31:18.594696	2026-03-05 20:31:18.594696	\N
1466	Rick Wade	\N	\N	2026-03-05 20:31:18.641959	2026-03-05 20:31:18.641959	\N
1467	Visionquest	\N	\N	2026-03-05 20:31:18.648795	2026-03-05 20:31:18.648795	\N
1468	Kill the Noise	\N	\N	2026-03-06 11:51:05.610242	2026-03-06 11:51:05.610242	\N
1469	Mitis	\N	\N	2026-03-06 11:51:05.619434	2026-03-06 11:51:05.619434	\N
1470	Quackson	\N	\N	2026-03-06 11:51:05.633942	2026-03-06 11:51:05.633942	\N
1471	Star Seed	\N	\N	2026-03-06 11:51:05.642095	2026-03-06 11:51:05.642095	\N
1472	AMTRAC	\N	\N	2026-03-06 11:59:13.129309	2026-03-06 11:59:13.129309	\N
1473	BECAUSE OF ART	\N	\N	2026-03-06 11:59:13.231085	2026-03-06 11:59:13.231085	\N
1474	CRi	\N	\N	2026-03-06 11:59:13.331033	2026-03-06 11:59:13.331033	\N
1475	DOSEM B2B HANA	\N	\N	2026-03-06 11:59:13.341028	2026-03-06 11:59:13.341028	\N
1476	ELI & FUR	\N	\N	2026-03-06 11:59:13.348667	2026-03-06 11:59:13.348667	\N
1477	ERIC LUTTRELL	\N	\N	2026-03-06 11:59:13.436264	2026-03-06 11:59:13.436264	\N
1478	EZEQUIEL ARIAS	\N	\N	2026-03-06 11:59:13.534433	2026-03-06 11:59:13.534433	\N
1479	REZIDENT	\N	\N	2026-03-06 11:59:13.63577	2026-03-06 11:59:13.63577	\N
1480	Chemikkal	\N	\N	2026-03-06 12:04:08.147396	2026-03-06 12:04:08.147396	\N
1481	Oscar Troya	\N	\N	2026-03-06 12:04:08.158983	2026-03-06 12:04:08.158983	\N
1482	Christian Corsi	\N	\N	2026-03-06 12:04:08.168631	2026-03-06 12:04:08.168631	\N
1483	Brian Tyler	\N	\N	2026-03-06 12:04:08.176035	2026-03-06 12:04:08.176035	\N
1484	JoiseyJay	\N	\N	2026-03-06 12:04:08.18456	2026-03-06 12:04:08.18456	\N
1485	Enzo is Burning	\N	\N	2026-03-06 12:07:43.595006	2026-03-06 12:07:43.595006	\N
1486	Esse	\N	\N	2026-03-06 12:07:48.213325	2026-03-06 12:07:48.213325	\N
1487	MIRA MIRA	\N	\N	2026-03-06 20:31:31.149359	2026-03-06 20:31:31.149359	\N
1488	Santiago Salazar	\N	\N	2026-03-06 20:31:31.187964	2026-03-06 20:31:31.187964	\N
1489	Claudio PRC	\N	\N	2026-03-06 20:31:31.377137	2026-03-06 20:31:31.377137	\N
1490	Juana	\N	\N	2026-03-06 20:31:31.386093	2026-03-06 20:31:31.386093	\N
1491	Traversable Wormhole	\N	\N	2026-03-06 20:31:31.450881	2026-03-06 20:31:31.450881	\N
1492	Adam X	\N	\N	2026-03-06 20:31:31.4662	2026-03-06 20:31:31.4662	\N
1493	Justin Aulis Long	\N	\N	2026-03-06 20:31:31.534049	2026-03-06 20:31:31.534049	\N
1494	Posthuman	\N	\N	2026-03-06 20:31:32.033549	2026-03-06 20:31:32.033549	\N
1495	Acid Pauli	\N	\N	2026-03-08 20:31:31.014599	2026-03-08 20:31:31.014599	\N
1496	Egyptian Lover	\N	\N	2026-03-08 20:31:31.094319	2026-03-08 20:31:31.094319	\N
1497	Margaret Dygas	\N	\N	2026-03-08 20:31:31.107338	2026-03-08 20:31:31.107338	\N
1498	Shokh	\N	\N	2026-03-08 20:31:31.115995	2026-03-08 20:31:31.115995	\N
1499	The Advent	\N	\N	2026-03-08 20:31:31.129195	2026-03-08 20:31:31.129195	\N
1500	Inbal	\N	\N	2026-03-08 20:31:31.13853	2026-03-08 20:31:31.13853	\N
1501	Puma	\N	\N	2026-03-08 20:31:31.179237	2026-03-08 20:31:31.179237	\N
\.


--
-- Data for Name: artists_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.artists_events (artist_id, event_id) FROM stdin;
53	391
386	391
387	391
388	391
389	391
390	391
391	391
392	391
355	391
87	391
49	391
81	391
393	391
394	391
395	391
396	391
57	282
58	282
59	282
60	282
61	282
62	282
63	282
46	282
64	282
65	282
90	283
91	283
92	283
84	283
46	283
70	283
93	283
94	283
95	284
96	284
97	284
98	284
99	284
100	284
101	284
102	284
103	284
104	285
105	285
106	285
107	285
108	287
109	287
110	287
111	287
32	287
112	289
33	289
113	289
114	289
115	289
116	289
117	289
302	381
303	381
304	381
305	381
306	381
307	381
308	381
309	381
310	381
311	382
312	383
313	383
314	383
315	384
316	384
317	384
121	384
318	384
25	384
319	384
33	384
320	384
321	384
322	384
323	384
324	384
325	384
191	384
326	384
27	384
116	384
201	384
327	384
215	384
328	384
329	384
330	385
331	385
332	385
333	385
334	385
132	386
335	386
84	386
336	386
178	386
337	386
338	386
8	386
201	386
339	386
340	386
214	386
215	386
341	386
216	386
342	386
343	386
219	386
344	386
210	386
345	386
129	293
254	258
255	258
256	258
257	258
258	258
259	260
260	260
261	260
262	260
263	260
33	262
397	393
398	393
157	393
399	393
400	394
10	394
254	395
24	395
328	395
401	395
402	395
403	395
404	395
56	395
191	397
38	397
169	397
405	397
406	397
407	397
399	397
408	397
359	294
360	294
361	294
362	294
363	294
364	388
125	389
153	389
346	389
347	389
152	389
348	389
159	389
167	389
350	389
351	389
173	389
352	389
353	389
354	389
355	389
356	389
8	389
357	389
358	389
214	389
218	389
245	390
365	390
246	390
341	390
247	390
366	390
248	390
219	390
112	390
367	315
368	315
369	315
370	315
103	315
371	315
372	315
373	315
374	315
375	315
376	315
377	315
378	315
379	315
100	315
380	315
381	315
382	315
383	315
384	315
385	315
8	263
9	263
10	263
11	263
12	263
13	263
409	398
410	398
66	249
67	249
53	249
68	249
69	249
9	249
70	249
71	249
72	249
73	249
59	249
74	249
75	249
221	250
222	250
223	250
224	250
225	250
226	250
227	250
228	250
229	250
230	250
231	250
232	250
233	250
234	250
235	250
236	250
237	251
238	251
239	251
240	251
165	251
241	251
242	251
243	251
18	251
244	253
14	263
249	255
250	255
251	255
252	255
253	255
15	264
16	264
17	264
18	264
19	264
20	264
21	264
22	266
23	266
24	266
25	266
26	266
27	266
28	266
29	266
30	266
36	267
38	267
37	267
34	267
31	267
32	267
33	267
35	267
39	270
40	270
41	270
42	270
43	270
44	270
45	270
46	270
47	270
48	270
49	270
50	270
51	271
52	271
53	271
54	272
160	273
55	277
56	277
411	273
412	273
380	273
413	273
365	275
414	275
415	275
416	275
191	275
417	275
418	275
419	275
420	275
421	286
109	286
422	286
423	286
424	286
425	286
264	312
265	312
266	312
267	312
268	312
269	312
270	312
271	312
272	312
273	312
274	312
43	312
275	312
276	312
12	313
64	313
81	313
68	313
82	313
83	313
70	313
84	313
85	313
86	313
87	313
88	313
49	313
69	313
72	313
73	313
67	313
89	313
37	314
76	314
77	314
78	314
79	314
80	314
277	316
278	316
279	316
212	316
280	316
24	317
281	317
282	317
283	317
117	317
28	318
106	318
284	318
251	318
285	318
252	318
253	318
286	318
148	321
217	321
355	401
25	401
385	401
426	401
428	401
429	401
430	401
431	404
186	384
432	384
433	384
434	385
435	383
436	383
437	275
438	275
439	275
440	275
441	275
442	382
443	382
444	382
445	382
446	382
447	382
448	382
449	266
450	270
451	388
452	388
453	388
454	388
455	388
456	388
457	388
458	388
459	388
460	289
461	403
462	403
463	403
464	403
465	403
466	403
467	403
468	403
469	403
470	403
471	403
472	403
473	403
474	403
475	403
476	403
477	294
478	402
479	402
480	402
481	402
482	402
295	402
483	402
484	286
485	282
486	284
487	258
230	258
488	258
489	258
490	397
491	397
492	397
493	260
494	260
495	260
496	250
497	389
498	389
499	389
500	262
501	262
502	262
503	262
504	262
505	262
506	249
507	249
508	249
509	316
510	315
511	277
512	277
\.


--
-- Data for Name: event_attendees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.event_attendees (id, user_id, event_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events (id, title, date, start_time, end_time, venue_id, source, description, event_url, attending_count, created_at, updated_at, ticket_url, ticket_price, ticket_tier, ticket_wave, font_color, manual_override, short_title, event_logo, even_shorter_title, free_event, food_available, indoor_outdoor, age, promoter, notes, bg_color, manual_override_ticket, manual_override_location, manual_override_times, manual_override_genres, manual_override_title, manual_override_artists, manual_artist_names, city_key) FROM stdin;
710	Miami Music Week at E11EVEN: Monday	\N	2026-03-23 20:00:00	2026-03-24 10:00:00	179	RA	\N	https://ra.co/events/2381126	0	2026-03-03 06:50:08.245078	2026-03-03 06:50:08.29925	\N	0.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#642FC0	f	f	f	f	\N	\N	\N	mmw
594	Movement Day 1	\N	2026-05-23 14:00:00	2026-05-24 00:00:00	21	\N	\N	https://movementfestival.com/	\N	2026-02-26 06:18:39.157187	2026-02-26 06:23:08.933813	https://movementfestival.com/	200.00	\N	\N	#000000	\N	\N	\N	\N	\N	\N			\N	\N	#ffffff	f	f	f	f	\N	\N	\N	movement
595	Movement Day 2	\N	2026-05-24 14:00:00	2026-05-25 00:00:00	21	\N	\N	https://movementfestival.com/	\N	2026-02-26 06:21:07.956527	2026-02-26 06:21:07.956527	https://movementfestival.com/tickets	200.00	\N	\N	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	\N	\N	\N	movement
596	Movement Day 3	\N	2026-05-25 14:00:00	2026-05-25 23:00:00	21	\N	\N	https://movementfestival.com/	\N	2026-02-26 06:22:57.176086	2026-02-26 06:22:57.176086	https://movementfestival.com/	200.00	\N	\N	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	\N	\N	\N	movement
711	E11EVEN: Tuesday	\N	2026-03-24 20:00:00	2026-03-25 10:00:00	179	RA	\N	https://ra.co/events/2381127	0	2026-03-03 06:50:08.693984	2026-03-06 11:24:39.737803	https://speakeasygo.com/event/EVE-SZ6VC1?t=mmw_parties	10.00	\N	\N	#000000	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#bb9ee4	t	f	f	f	t	\N	\N	mmw
724	ReSolute goes Detroit (Daytime)	\N	2026-05-24 07:00:00	2026-05-24 20:00:00	25	RA	\N	https://ra.co/events/2384854	138	2026-03-03 20:31:25.466266	2026-03-08 20:31:30.64226	\N	38.35	2nd release	3 of 3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
609	Beatport Live Pool Party - 20 Years Rekids	\N	2026-03-25 15:00:00	2026-03-25 22:00:00	207	RA	\N	https://ra.co/events/2354114	74	2026-02-27 03:38:15.17814	2026-03-03 06:50:09.151293	https://dice.fm/event/av3p5q-beatport-live-pool-party-x-20-years-rekids-25th-mar-kimpton-epic-hotel-miami-tickets	55.00	\N	\N	#111827	\N	Beatport Live Pool Party	\N	\N	\N	\N			\N	\N	#8F8421	t	t	f	f	t	\N	\N	mmw
613	Do Not Sit On MMW ft. Madota	\N	2026-03-25 22:00:00	2026-03-26 05:00:00	174	RA	\N	https://ra.co/events/2353703	4	2026-02-27 03:38:15.9443	2026-03-03 06:50:09.593673	https://link.dice.fm/i7c9260f2ee7?dice_id=i7c9260f2ee7	36.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#FF8F1B	t	f	f	f	t	\N	\N	mmw
630	Interplanetary Criminal + Main Phase present: ATW Records	\N	2026-03-26 23:00:00	2026-03-27 07:00:00	176	RA	\N	https://ra.co/events/2357024	11	2026-02-27 03:38:17.255032	2026-03-03 06:50:10.450546	https://link.dice.fm/x011f76ee62f?dice_id=x011f76ee62f&utm_source=mmwparties	20.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#7738E4	t	f	f	f	t	\N	\N	mmw
638	BrunchCast MMW	\N	2026-03-26 12:00:00	2026-03-26 20:00:00	221	RA	\N	https://ra.co/events/2359823	1	2026-02-27 03:38:17.654913	2026-03-03 06:50:10.656117	https://bubbl.so/event/public/7B7s64sp8KzVokFNDrEj	23.00	free w RSVP before 1:30pm	\N	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#FF8018	t	t	f	f	t	\N	\N	mmw
646	MUMBO JUMBO: Rebolledo, Esquivel, Manumat	\N	2026-03-26 21:00:00	2026-03-27 04:00:00	191	RA	\N	https://ra.co/events/2379985	0	2026-02-27 03:38:17.965907	2026-03-03 06:50:10.851167	https://shotgun.live/en/events/mumbo-jumbo-rebolledo-esquivel-manumat	38.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N		21+	\N	\N	#FF901C	t	f	f	f	\N	\N	\N	mmw
657	The Soundgarden Cruise with Dubfire b2b Nick Warren 	\N	2026-03-27 15:30:00	2026-03-27 20:30:00	182	RA	\N	https://ra.co/events/2375638	7	2026-02-27 03:38:19.831832	2026-03-03 06:50:11.747137	\N	150.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#4699FF	t	f	f	f	t	\N	\N	mmw
660	Babël Music Showcase	\N	2026-03-27 23:59:00	2026-03-28 04:00:00	173	RA	\N	https://ra.co/events/2370232	1	2026-02-27 03:38:19.874461	2026-03-03 06:50:11.87917	https://shotgun.live/en/events/zeyzey-babel-showcase-miami-music-week-26	36.00	General admission	1 of 3	#052E16	\N	\N	\N	\N	\N	\N		18+	\N	\N	#20BB59	f	f	t	f	\N	\N	\N	mmw
597	The Hood Needs House	\N	2026-05-24 23:00:00	2026-05-25 02:30:00	12	\N	\N	\N	\N	2026-02-26 06:48:05.989146	2026-02-26 06:48:05.989146	https://www.axs.com/events/1345523/the-hood-needs-house-tickets	45.00	Early bird	\N	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	\N	\N	\N	movement
718	Kristina Sky presents United We Groove Miami 2026	\N	2026-03-27 19:00:00	2026-03-28 03:00:00	231	RA	\N	https://ra.co/events/2382068	1	2026-03-03 06:50:11.363553	2026-03-06 11:46:07.585126	https://www.eventbrite.com/e/kristina-sky-presents-united-we-groove-miami-2026-registration-1983740729924?aff=mmw_parties	0.00	FREE w/ RSVP	1 of 1	#000000	\N	\N	\N	\N	t	\N	Both	21+	\N	\N	#dd9bbf	t	f	f	f	\N	\N	\N	mmw
719	Todd Terry, Toribio, PUMA	\N	2026-03-27 21:00:00	2026-03-28 03:00:00	225	RA	The river venue sets the stage for a stylish yet chill night out. Whether you´re a party pro or just vibing, this is the spot.\r\nTune in our slick radio show serving up the latest tracks.\r\nSave the date and cath the urban-chic experience at Mad Radio Miami.\r\n\r\nSee you on the dance floor!\r\n	https://ra.co/events/2382351	1	2026-03-03 06:50:11.979665	2026-03-06 11:54:37.788357	https://shotgun.live/en/events/mmw-at-mad-radio-todd-terry-toribio-puma	20.00	\N	\N	#ffffff	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#767f8c	t	f	f	f	t	\N	\N	mmw
661	The Cut vs Humans Alike Showcase	\N	2026-03-27 21:00:00	2026-03-28 04:00:00	221	RA	The Cut Austin teams up with Humans Alike for an amazing Miami Music Week Showcase. Located at: Uva Wynwood Outdoor venue of Electric Lady.\r\n\r\nAddress: 2244 NW 1st Ct, Miami, FL 33127\r\n\r\nABOUT/\r\n\r\n• IF IT'S LATE FOR YOU, IT'S EARLY FOR US.\r\n\r\nThe Cut, your exclusive after-hours destination in Austin, Texas. Here, the dance floor comes alive with the beats of innovative DJs and producers. We are dedicated to curating an exhilarating party experience while ensuring a safe and dynamic environment for everyone.	https://ra.co/events/2379874	4	2026-02-27 03:38:19.935835	2026-03-06 11:57:17.541165	\N	12.12	\N	\N	#ffffff	\N	\N	\N	\N	\N	\N	Outdoor	21+	\N	\N	#e6873f	t	t	f	f	\N	\N	\N	mmw
629	RAW CUTS: DJ Tennis + Gerd Janson	\N	2026-03-26 15:00:00	2026-03-26 22:00:00	184	RA	\N	https://ra.co/events/2374513	17	2026-02-27 03:38:17.183816	2026-03-04 17:58:11.107685	https://shotgun.live/en/events/raw-cuts-mmw	50.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#1FA950	t	t	f	f	t	\N	\N	mmw
725	D-LiFE 10	\N	2026-05-24 14:00:00	2026-05-25 02:30:00	8	RA	\N	https://ra.co/events/2385294	118	2026-03-04 07:05:32.953934	2026-03-08 20:31:30.690299	\N	34.30	1st release	2 of 6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
713	Musumeci, Israel Sunshine	\N	2026-03-25 21:00:00	2026-03-26 03:00:00	225	RA	The river venue sets the stage for a stylish yet chill night out. Whether you´re a party pro or just vibing, this is the spot.\r\nTune in our slick radio show serving up the latest tracks.\r\nSave the date and cath the urban-chic experience at Mad Radio Miami.\r\n\r\nSee you on the dance floor!	https://ra.co/events/2382318	2	2026-03-03 06:50:09.781507	2026-03-06 11:30:07.856505	https://shotgun.live/en/events/mmw-at-mad-radio-musumeci-israel-sunshine	22.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#767F8C	t	f	f	f	t	\N	\N	mmw
612	Factory Town Music Week	\N	2026-03-25 22:00:00	2026-03-26 06:00:00	172	RA	\N	https://ra.co/events/2363657	10	2026-02-27 03:38:15.6156	2026-03-03 06:50:09.366415	https://link.dice.fm/x1c228cbea18?dice_id=x1c228cbea18	50.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N		18+	\N	\N	#199045	t	f	f	f	t	\N	\N	mmw
627	Bedrock Sunset Cruise	\N	2026-03-26 15:30:00	2026-03-26 20:30:00	182	RA	\N	https://ra.co/events/2341322	18	2026-02-27 03:38:17.142293	2026-03-03 06:50:10.367402	\N	160.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#4699FF	t	f	f	f	\N	\N	\N	mmw
712	Richie Hawtin B2B Dubfire, Magda, Satoshi Tomiie, DJ Nigiri	\N	2026-03-25 21:00:00	2026-03-26 03:00:00	191	RA	For one night only, FOOQS becomes a full-scale music and culinary production. The dining room transforms into an intimate stage featuring a Richie Hawtin b2b Dubfire set with support from Magda. All guests will be able to enjoy an à la carte yakitori selection. For guests who want an elevated experience, outdoor VIP tables are available.\r\n\r\nUpstairs in the Lion’s Den, tables become available after 11:30PM, featuring a special set by Satoshi Tomiie. Follow @fooqsmiami and @lionsden_miami for all upcoming programming.\r\n\r\nTicket Information:\r\n\r\nGeneral Admission includes access to main floor + patio\r\n21+ event	https://ra.co/events/2382065	6	2026-03-03 06:50:09.466591	2026-03-06 11:36:48.975582	https://shotgun.live/en/events/fooqs-converge-richie-hawtin-b2b-dubfire	90.00	includes yakitori 	\N	#111827	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#f0ae79	t	f	f	t	\N	\N	\N	mmw
716	Where Are My Keys? MMW by Un_Mute & Pickle	\N	2026-03-27 23:59:00	2026-03-30 10:00:00	229	RA	\N	https://ra.co/events/2381784	53	2026-03-03 06:50:10.882462	2026-03-03 06:50:10.891592	\N	111.85	3 DAY WEEKEND PASS	1 of 1	#052E16	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#2BF676	f	f	f	f	\N	\N	\N	mmw
673	Factory Town Music Week	\N	2026-03-28 21:00:00	2026-03-29 07:00:00	172	RA	\N	https://ra.co/events/2363675	13	2026-02-27 03:38:20.55736	2026-03-03 06:50:12.450488	https://link.dice.fm/p2a50fa92a25?dice_id=p2a50fa92a25	150.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#199045	t	f	f	f	t	\N	\N	mmw
682	House Stars	\N	2026-03-28 17:00:00	2026-03-29 03:00:00	199	RA	\N	https://ra.co/events/2375628	1	2026-02-27 03:38:21.059603	2026-03-03 06:50:12.665613	https://www.eventbrite.it/e/house-stars-miami-music-week-tickets-1983727127238	0.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#702020	t	f	f	f	t	\N	\N	mmw
717	We're Never Going Home - Miami Music Week	\N	2026-03-27 14:00:00	2026-03-28 05:00:00	230	RA	\N	https://ra.co/events/2381238	1	2026-03-03 06:50:11.304922	2026-03-03 06:50:11.306533	\N	34.30	All Day & All Night VIP Access	1 of 1	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#D23C3C	f	f	f	f	\N	\N	\N	mmw
720	Pendulum by Steve Lawler (MMW 2026)	\N	2026-03-28 22:00:00	2026-03-29 05:00:00	224	RA	\N	https://ra.co/events/2382239	41	2026-03-03 06:50:12.174051	2026-03-03 06:50:12.175368	\N	34.30	ANYTIME ENTRY	1 of 8	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#632EBE	f	f	f	f	\N	\N	\N	mmw
721	MMW AT MAD RADIO: Demarkus Lewis, Atomyard, Leo Del Toro	\N	2026-03-28 21:00:00	2026-03-29 03:00:00	225	RA	\N	https://ra.co/events/2382358	0	2026-03-03 06:50:12.865394	2026-03-03 06:50:12.86674	\N	0.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#6D7483	f	f	f	f	\N	\N	\N	mmw
723	Deeperfect Showcase (MMW 2026)	\N	2026-03-29 22:00:00	2026-03-30 05:00:00	224	RA	\N	https://ra.co/events/2382245	40	2026-03-03 06:50:13.530986	2026-03-03 06:50:13.532877	\N	22.85	ANYTIME ENTRY	1 of 4	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#632EBE	f	f	f	f	\N	\N	\N	mmw
714	Farris Wheel Showcase (MMW 2026)	\N	2026-03-26 22:00:00	2026-03-27 05:00:00	224	RA	\N	https://ra.co/events/2382236	40	2026-03-03 06:50:09.89193	2026-03-04 06:58:33.897799	\N	22.85	ANYTIME ENTRY	1 of 4	#000000	\N	\N	\N	\N	\N	\N			\N	\N	#e2d4f3	f	t	f	f	\N	\N	\N	mmw
715	Radio Slave, eveava	\N	2026-03-26 21:00:00	2026-03-27 03:00:00	225	RA	The river venue sets the stage for a stylish yet chill night out. Whether you´re a party pro or just vibing, this is the spot.\r\nTune in our slick radio show serving up the latest tracks.\r\nSave the date and cath the urban-chic experience at Mad Radio Miami.\r\n\r\nSee you on the dance floor!	https://ra.co/events/2382322	1	2026-03-03 06:50:10.758041	2026-03-06 11:41:49.080688	https://shotgun.live/en/events/mmw-at-mad-radio-radio-slave-eveava	20.00	\N	\N	#ffffff	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#767f8c	t	f	f	f	t	\N	\N	mmw
687	EsDeeKid Rebel Tour	\N	2026-03-28 22:00:00	2026-03-29 03:00:00	201	RA	\N	https://ra.co/events/2374631	0	2026-02-27 03:38:21.331729	2026-03-03 06:50:12.84527	https://posh.vip/e/the-rebel-tour-miami-1	60.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#757C8C	t	f	f	f	t	\N	\N	mmw
575	10 Years of Texture (2-day tickets)	\N	2024-05-01 22:00:00	2024-05-08 05:00:00	10	RA	\N	https://ra.co/events/2370518	105	2026-02-26 04:13:37.511242	2026-02-26 04:25:36.207979	\N	137.15	1st release	2 of 12	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	t	f	\N	\N	\N	movement
672	ANJUNADEEP OPEN AIR MIAMI	\N	2026-03-28 16:00:00	2026-03-28 23:59:00	185	RA	Anjunadeep returns to Miami on 29th of March for the label’s biggest Miami Music Week Open Air takeover yet. Join us at Wynwood Marketplace for a glorious day in the sun in the heart of Miami’s Wynwood district.\r\n	https://ra.co/events/2356185	17	2026-02-27 03:38:20.548032	2026-03-06 11:59:13.03046	https://www.tixr.com/groups/blnkcnvs/events/anjunadeep-open-air-miami-172415	70.00	\N	\N	#000000	\N	\N	\N	\N	\N	\N	Both	18+	\N	\N	#b8ebc8	t	f	f	f	\N	t	\N	mmw
593	CODA: The Closing Party	\N	2026-05-26 14:00:00	2026-05-27 02:00:00	88	RA	\N	https://ra.co/events/2323466	117	2026-02-26 04:13:39.55821	2026-03-07 20:31:30.335692	\N	28.55	1st release	2 of 2	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	t	f	f	\N	\N	\N	movement
590	The Bunker (I.T. presents)	\N	2026-05-25 22:00:00	2026-05-26 06:00:00	6	RA	\N	https://ra.co/events/2353600	363	2026-02-26 04:13:39.267986	2026-03-08 20:31:30.83324	\N	80.00	3rd release	3 of 6	#cccccc	\N	The Bunker	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
568	T4T LUV NRG (I.T. presents)	\N	2026-05-22 21:00:00	2026-05-23 05:00:00	6	RA	\N	https://ra.co/events/2353589	607	2026-02-26 04:13:36.079708	2026-03-08 20:31:29.284861	\N	51.45	3rd release	3 of 3	#cccccc	\N	T4T LUV NRG	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
579	SUBSONIC (Alternative School presents)	\N	2026-05-23 22:00:00	2026-05-24 05:00:00	13	RA	\N	https://ra.co/events/2375768	110	2026-02-26 04:13:37.923381	2026-03-08 20:31:30.317104	\N	40.00	1st wave	2 of 4	#cccccc	\N	SUBSONIC	\N	\N	\N	\N			\N	\N	#cccccc	f	f	t	f	t	\N	\N	movement
581	RAVEHOUSE	\N	2026-05-23 10:00:00	2026-05-23 14:30:00	25	RA	\N	https://ra.co/events/2369251	44	2026-02-26 04:13:38.040155	2026-03-08 20:31:30.423242	\N	8.55	Tier 1	2 of 4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
580	Detroit Techno Militia x Techno Snob	\N	2026-05-23 22:00:00	2026-05-24 02:00:00	160	RA	\N	https://ra.co/events/2344054	56	2026-02-26 04:13:37.989503	2026-03-07 20:31:29.389877	\N	20.00	cash at door	\N	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	t	f	f	f	\N	\N	\N	movement
582	DETROIT TRANSMISSION	\N	2026-05-23 14:00:00	2026-05-24 02:00:00	161	RA	\N	https://ra.co/events/2340421	36	2026-02-26 04:13:38.075159	2026-03-08 20:31:30.436381	\N	20.00	TRANNY	1 of 4	#000000	\N	\N	\N	\N	\N	\N			\N	\N	#0dc9bd	f	f	f	f	\N	\N	\N	movement
722	Reaction Radio presents: Miami Music Week	\N	2026-03-28 17:00:00	2026-03-28 23:00:00	233	RA	Join Reaction Radio for an unforgettable Miami Music Week event at Unseen Creatures in Miami, Florida, bringing together electronic music lovers, DJs, producers, and industry creatives for an evening of cutting-edge sound and vibrant atmosphere. Taking place from 5PM to 11PM at 4178 SW 74th Ct, Miami, FL, this special Miami Music Week gathering delivers a high-energy experience featuring curated DJ sets, immersive visuals, and a community-driven environment that reflects the spirit of Miami’s global dance music scene.	https://ra.co/events/2382760	0	2026-03-03 06:50:12.904472	2026-03-06 12:04:55.691725	https://posh.vip/e/reaction-radio-presents-miami-music-week	0.00	RSVP	\N	#ffffff	\N	\N	\N	\N	t	\N		21+	\N	\N	#a2242c	t	f	t	f	\N	t	\N	mmw
583	No Way Back	\N	2026-05-24 22:00:00	2026-05-25 12:00:00	6	RA	\N	https://ra.co/events/2353595	1054	2026-02-26 04:13:38.247176	2026-03-08 20:31:30.506163	\N	249.70	3rd release	6 of 6	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
585	Theo Parrish at Dreamtroit	\N	2026-05-24 19:00:00	2026-05-25 07:00:00	162	RA	\N	https://ra.co/events/2373631	413	2026-02-26 04:13:38.362054	2026-03-08 20:31:30.580229	\N	74.30	3rd release	4 of 6	#cccccc	\N	Theo Parrish 	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
645	Splash Revolution Pool Party	\N	2026-03-25 11:00:00	2026-03-25 17:00:00	181	RA	\N	https://ra.co/events/2379972	0	2026-02-27 03:38:17.940678	2026-03-03 06:50:10.839933	https://www.eventbrite.com/e/miami-music-week-pool-party-splash-at-moxy-south-beach-tickets-1983622039919?utm-campaign=social&utm-content=attendeeshare&utm-medium=discovery&utm-term=listing&utm-source=mmwparties&aff=ebdsshcopyurl	30.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#FFFF49	t	f	t	f	\N	t	\N	mmw
587	Into the Deep (DVS1 x RE/FORM present)	\N	2026-05-24 16:00:00	2026-05-25 02:00:00	15	RA	\N	https://ra.co/events/2374196	140	2026-02-26 04:13:38.55209	2026-03-08 20:31:30.614637	\N	46.00	General Admission - Tier 1	2 of 4	#cccccc	\N	Into the Deep	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
628	Ultra Naté's DEEP SUGAR MIAMI ''Ultra's Birthday Bash!''	\N	2026-03-26 20:00:00	2026-03-27 03:00:00	183	RA	\N	https://ra.co/events/2373633	21	2026-02-27 03:38:17.159865	2026-03-03 06:50:10.356063	\N	15.00	Advance ticket	1 of 1	#052E16	\N	Ultra's Birthday Bash	\N	\N	\N	\N			\N	\N	#2CFC78	f	f	f	f	\N	\N	\N	mmw
586	10 Years of Texture - Sunday	\N	2026-05-24 21:00:00	2026-05-25 05:00:00	24	RA	\N	https://ra.co/events/2347026	266	2026-02-26 04:13:38.370055	2026-03-07 20:31:29.69869	\N	57.15	1st release	2 of 7	#cccccc	\N	10 Yrs of Texture - Sun	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	\N	\N	\N	movement
592	15 Years of Visionquest	\N	2026-05-25 07:00:00	2026-05-26 06:00:00	17	RA	\N	https://ra.co/events/2368620	291	2026-02-26 04:13:39.53601	2026-03-08 20:31:30.859079	\N	62.85	2nd release	3 of 4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
588	Techfest Breakfast - Stacks & Tracks	\N	2026-05-24 08:00:00	2026-05-24 15:00:00	13	RA	\N	https://ra.co/events/2365421	91	2026-02-26 04:13:38.567269	2026-03-08 20:31:30.732302	\N	11.45	Early bird	1 of 2	#cccccc	\N	Techfest Breakfast	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
591	Lot Mass	\N	2026-05-25 12:00:00	2026-05-25 22:00:00	6	RA	\N	https://ra.co/events/2353597	243	2026-02-26 04:13:39.445954	2026-03-08 20:31:30.956198	\N	34.30	3rd release	3 of 6	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
573	Tresor 313	\N	2026-05-23 22:00:00	2026-05-24 10:00:00	6	RA	\N	https://ra.co/events/2353593	541	2026-02-26 04:13:37.276051	2026-03-08 20:31:29.838655	\N	85.70	3rd release	3 of 6	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
584	OBSERVE // SCENE // 2026	\N	2026-05-24 22:00:00	2026-05-25 07:00:00	17	RA	\N	https://ra.co/events/2363529	520	2026-02-26 04:13:38.353154	2026-03-08 20:31:30.533948	\N	87.60	Final release	4 of 4	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	\N	\N	\N	movement
589	Anthology	\N	2026-05-25 22:00:00	2026-05-26 07:00:00	15	RA	\N	https://ra.co/events/2374176	811	2026-02-26 04:13:38.931032	2026-03-08 20:31:30.781197	\N	75.00	General Admission - Tier 4	5 of 6	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
578	BOWEL MOVEMENT 2026	\N	2026-05-23 22:00:00	2026-05-24 06:00:00	7	RA	\N	https://ra.co/events/2343386	86	2026-02-26 04:13:37.900858	2026-03-07 20:31:29.357629	\N	9.99	Early bird	1 of 1	#ffffff	\N	\N	\N	\N	\N	\N			\N	\N	#67360e	f	f	f	f	\N	\N	\N	movement
574	10 Years of Texture - Saturday	\N	2026-05-23 22:00:00	2026-05-24 09:30:00	24	RA	\N	https://ra.co/events/2328607	484	2026-02-26 04:13:37.416529	2026-03-08 20:31:29.990703	\N	68.55	2nd release	3 of 8	#cccccc	\N	10 Yrs of Texture - Sat	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	\N	\N	\N	movement
599	Miami Music Week - SONIKA	\N	2026-03-23 22:00:00	2026-03-24 03:00:00	165	RA	\N	https://ra.co/events/2376210	0	2026-02-27 03:38:14.294679	2026-03-03 06:50:08.218841	\N	22.85	General admission	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#651F42	f	f	f	f	\N	\N	\N	mmw
621	Sagamore Pool Party MMW: Defected Miami: Loco Dice	\N	2026-03-26 13:00:00	2026-03-26 23:00:00	171	RA	\N	https://ra.co/events/2284076	90	2026-02-27 03:38:16.311252	2026-03-03 06:50:09.842842	\N	114.30	2nd release	5 of 6	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#FCE93A	f	f	f	f	\N	\N	\N	mmw
622	Cosmic Gate + Friends	\N	2026-03-26 21:00:00	2026-03-27 05:00:00	208	RA	\N	https://ra.co/events/2311024	7	2026-02-27 03:38:16.43513	2026-03-03 06:50:10.058848	\N	22.85	GA - BEFORE 12AM	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#FB4747	f	t	f	f	\N	\N	\N	mmw
607	Coldharbour X Black Hole Recordings Night	\N	2026-03-25 21:00:00	2026-03-26 05:00:00	170	RA	\N	https://ra.co/events/2360740	2	2026-02-27 03:38:15.06562	2026-03-03 06:50:09.137471	\N	17.14	Before 12AM	1 of 2	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#D46213	f	f	f	f	\N	\N	\N	mmw
623	Infected Mushroom + John 00 Fleming	\N	2026-03-26 21:00:00	2026-03-27 05:00:00	170	RA	\N	https://ra.co/events/2360730	4	2026-02-27 03:38:16.458283	2026-03-03 06:50:10.073477	\N	22.84	Before 12AM	1 of 2	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#D46213	f	f	f	f	\N	\N	\N	mmw
605	Monrroe & Sustance	\N	2026-03-24 20:00:00	2026-03-25 03:00:00	170	RA	MIAMI MUSIC WEEK – UK DRUM & BASS TAKEOVER\r\n\r\nOne night. One room. No compromises.\r\n\r\nThis Miami Music Week, Mazuma is taken over by pure UK drum & bass energy as Monrroe & Sustance touch down for their MIAMI DEBUT. Expect deep rollers, heavy pressure, and the kind of sound that hits different.\r\n\r\nAt a time when Miami is flooded with showcases and brand-driven events, this takeover focuses on substance, sound, and culture. Monrroe and Sustance—both celebrated for their cutting-edge productions and commanding DJ performances—bring a level of musical depth and energy that sets this event apart from the noise of the week.\r\n\r\nThe collaboration between Diverse Music Talent, Makino, and American Grime represents a shared mission: to create a space where underground music thrives during Miami Music Week, without compromise. This event is designed for true music lovers, offering a carefully curated environment, high-quality sound, and an atmosphere driven by community rather than hype alone.\r\n\r\nWith Miami Music Week attracting a global audience, this takeover stands as a definitive destination for those seeking the most impactful and memorable experience of the week\r\n\r\nThis event has been nearly a year in the making and brings together Makino, Diverse Music Talent, American Grime, and the Apex team for a proper UK DNB showcase during MMW.\r\n\r\nDirect support comes from the Rumble in the Jungle crew, known for setting the tone and opening for top international drum & bass artists. Joining them is Orchid, carving her own lane with undeniable talent and influence from her father DJ Craze — world-renowned artist and Miami legend. Alphaxero, rapidly gaining recognition in the city, adds even more weight to the lineup. Holding it down for the hometown are American Grime, featuring Brightwing & Jumanji, who have been pushing Miami’s drum & bass sound for years.	https://ra.co/events/2370326	2	2026-02-27 03:38:14.905978	2026-03-06 11:22:11.741356	https://shotgun.live/en/events/monrroe-sustance-mmw	30.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#f8d4b8	t	f	f	f	t	t	\N	mmw
625	Aliens On Mushrooms Pool Party Miami Music Week 2026	\N	2026-03-26 12:00:00	2026-03-26 23:00:00	181	RA	\N	https://ra.co/events/2371393	35	2026-02-27 03:38:16.478958	2026-03-03 06:50:10.108755	\N	22.85	1st release	2 of 5	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#FFFF49	f	f	f	f	\N	\N	\N	mmw
626	Factory Town Music Week	\N	2026-03-26 22:00:00	2026-03-27 07:00:00	172	RA	\N	https://ra.co/events/2363666	20	2026-02-27 03:38:16.844461	2026-03-03 06:50:10.255032	https://link.dice.fm/Y9748c13d158?dice_id=Y9748c13d158	50.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N		18+	\N	\N	#199045	t	f	f	f	t	\N	\N	mmw
633	FRESH SQUEEZE	\N	2026-03-26 18:00:00	2026-03-26 21:00:00	186	RA	\N	https://ra.co/events/2376178	7	2026-02-27 03:38:17.370985	2026-03-03 06:50:10.535769	\N	0.00	\N	\N	#FFFFFF	\N	\N	\N	\N	t	\N		21+	\N	\N	#FF5656	t	f	f	f	\N	\N	\N	mmw
634	DEADBEATS - 10 YEAR ANNIVERSARY	\N	2026-03-26 21:00:00	2026-03-27 05:00:00	187	RA	\N	https://ra.co/events/2356183	3	2026-02-27 03:38:17.445848	2026-03-03 06:50:10.633777	https://www.tixr.com/groups/blnkcnvs/events/deadbeats-10-year-anniversary-169701	90.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#0E5127	t	f	f	f	\N	\N	\N	mmw
608	Incorrect Music MMW Showcase	\N	2026-03-25 22:00:00	2026-03-26 05:00:00	224	RA	\N	https://ra.co/events/2378760	39	2026-02-27 03:38:15.083639	2026-03-03 06:50:08.838107	\N	22.85	ANYTIME ENTRY	1 of 3	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#632EBE	f	f	f	f	\N	\N	\N	mmw
601	Beatport Live Pool Party - Mood Child Label Showcase	\N	2026-03-24 17:00:00	2026-03-24 22:00:00	207	RA	\N	https://ra.co/events/2354111	68	2026-02-27 03:38:14.545874	2026-03-03 06:50:08.430285	https://dice.fm/event/oegb9y-beatport-live-pool-party-x-mood-child-24th-mar-kimpton-epic-hotel-miami-tickets	47.00	\N	\N	#111827	\N	Beatport Live Pool Party	\N	\N	\N	\N			\N	\N	#8F8421	t	t	f	f	t	\N	\N	mmw
602	Experts Only	\N	2026-03-24 23:00:00	2026-03-25 20:00:00	168	RA	\N	https://ra.co/events/2332926	25	2026-02-27 03:38:14.661105	2026-03-03 06:50:08.512683	https://link.dice.fm/va504f6099c4?dice_id=va504f6099c4	70.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#7E3BF2	t	f	f	f	t	\N	\N	mmw
636	Audien: PROGRESSIVE HOUSE NEVER DIES	\N	2026-03-26 22:00:00	2026-03-27 05:00:00	188	RA	\N	https://ra.co/events/2351462	2	2026-02-27 03:38:17.565625	2026-03-03 06:50:10.641326	https://www.eventbrite.com/e/audien-progressive-house-never-dies-tickets-1980668605116?utm-campaign=social&utm-content=attendeeshare&utm-medium=discovery&utm-term=listing&utm-source=mmwparties&aff=ebdsshcopyurl	45.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#1EAD53	t	f	f	f	\N	\N	\N	mmw
610	Factory Town Music Week 2026 (5-Day Pass)	\N	2024-03-06 10:00:00	2024-03-06 23:00:00	172	RA	\N	https://ra.co/events/2352453	23	2026-02-27 03:38:15.30107	2026-03-03 06:50:09.234195	\N	0.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#199045	f	f	t	f	\N	\N	\N	mmw
603	Get Closer: Luuk van Dijk	\N	2026-03-24 22:00:00	2026-03-25 04:00:00	169	RA	\N	https://ra.co/events/2368673	2	2026-02-27 03:38:14.681916	2026-03-03 06:50:08.530231	https://link.dice.fm/x7c6548cf0b6?dice_id=x7c6548cf0b6	15.00	\N	\N	#111827	\N	Get Closer: Luuk van Dijk	\N	\N	\N	\N		21+	\N	\N	#C75C12	t	f	f	f	t	\N	\N	mmw
726	Moods BBQ	\N	2026-05-22 14:00:00	2026-05-22 20:00:00	10	RA	\N	https://ra.co/events/2381021	39	2026-03-06 20:31:30.955572	2026-03-08 20:31:29.611018	\N	34.30	Early bird	1 of 1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
611	TOKiMONSTA presents: Young Art Records Takeover	\N	2026-03-25 20:00:00	2026-03-26 02:00:00	173	RA	\N	https://ra.co/events/2370161	11	2026-02-27 03:38:15.588117	2026-03-06 11:27:21.310525	\N	24.00	FREE ENTRY (before 10pm)	1 of 4	#000000	\N	\N	\N	\N	\N	\N	Both	21+	\N	\N	#e6f7ed	t	f	f	f	t	\N	\N	mmw
604	20Five8Records x Groovemates 	\N	2026-03-24 23:00:00	2026-03-25 03:00:00	165	RA	\N	https://ra.co/events/2376215	2	2026-02-27 03:38:14.783897	2026-03-03 06:50:08.627721	\N	11.45	General admission	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#651F42	f	f	f	f	t	\N	\N	mmw
617	Cheetah Print: Rafael	\N	2026-03-25 22:00:00	2026-03-26 04:00:00	169	RA	\N	https://ra.co/events/2376992	1	2026-02-27 03:38:16.139664	2026-03-06 11:37:58.831963	https://link.dice.fm/Be5d5782baaf?dice_id=Be5d5782baaf	20.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#f5c79e	t	f	f	f	t	\N	\N	mmw
614	Riordan Selects	\N	2026-03-25 23:00:00	2026-03-26 05:00:00	175	RA	\N	https://ra.co/events/2354370	3	2026-02-27 03:38:15.965856	2026-03-03 06:50:09.635179	https://link.dice.fm/Tb724e02ec67?dice_id=Tb724e02ec67	22.00	\N	\N	#FFFFFF	\N	Riordan Selects	\N	\N	\N	\N			\N	\N	#341864	t	f	f	f	t	\N	\N	mmw
615	Perreo Del Futuro presents: Six Sex	\N	2026-03-25 23:00:00	2026-03-26 07:00:00	176	RA	\N	https://ra.co/events/2357005	3	2026-02-27 03:38:15.991457	2026-03-03 06:50:09.645063	https://link.dice.fm/M92518260632?dice_id=M92518260632	15.00	\N	\N	#FFFFFF	\N	Six Sex (Perreo Del Futuro presents)	\N	\N	\N	\N			\N	\N	#7738E4	t	f	f	f	t	\N	\N	mmw
727	Detroit Love - Official Movement Afterparty	\N	2026-05-23 23:00:00	2026-05-24 03:00:00	17	RA	\N	https://ra.co/events/2387264	15	2026-03-06 20:31:32.231419	2026-03-08 20:31:30.480349	\N	0.00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
598	Enjoy MMW Opening Party	\N	2026-03-23 18:00:00	2026-03-24 03:00:00	164	RA	\N	https://ra.co/events/2375758	4	2026-02-27 03:38:13.847394	2026-03-04 06:55:02.609207	\N	0.00	\N	\N	#ffffff	\N	\N	\N	\N	\N	\N			\N	\N	#df6c99	f	t	f	f	\N	\N	\N	mmw
635	FACE 2 FACE: Factory Town Music Week	\N	2026-03-26 22:00:00	2026-03-27 07:00:00	172	RA	Face 2 Face lands at Factory Town during Miami Music Week 2026 for a night built around connection and shared energy.\r\n\r\nTwo artists sharing the booth, the crowd surrounding the moment, and the night unfolding in real time. No script just music happening Face 2 Face.	https://ra.co/events/2377327	4	2026-02-27 03:38:17.456042	2026-03-06 11:44:20.063301	https://dice.fm/partner/tickets/event/mx326k-factory-town-music-week-2026-thursday-pass-26th-mar-factory-town-miami-tickets?dice_id=8316869&dice_channel=web&dice_tags=organic&dice_campaign=Insomniac+Holdings&dice_feature=mio_marketing&_branch_match_id=1491377150189512842&utm_source=mmw_parties	67.00	\N	\N	#0d0d0d	\N	\N	\N	\N	\N	\N	Both	18+	\N	\N	#cff2d9	t	f	f	f	t	\N	\N	mmw
618	Resistance Miami Music Week (5-Day Pass)	\N	2024-03-13 19:00:00	2024-03-13 22:00:00	177	RA	\N	https://ra.co/events/2378108	1	2026-02-27 03:38:16.157164	2026-03-03 06:50:09.753499	\N	0.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#9244FF	f	f	t	f	\N	\N	\N	mmw
620	Oliver Heldens	\N	2026-03-25 20:00:00	2026-03-26 10:00:00	179	RA	\N	https://ra.co/events/2374669	1	2026-02-27 03:38:16.287463	2026-03-03 06:50:09.732016	https://speakeasygo.com/event/EVE-Q6SFK1?t=mmwparties	20.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#642FC0	t	f	f	t	t	\N	\N	mmw
640	UNIVerso BOAT PARTY (Verso presents)	\N	2026-03-26 16:00:00	2026-03-26 22:00:00	222	RA	\N	https://ra.co/events/2376440	1	2026-02-27 03:38:17.737818	2026-03-03 06:50:10.694119	\N	57.15	1st release	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#4EADFF	f	t	f	f	t	\N	\N	mmw
651	Journey: Spencer Brown, Eric Luttrell, Qrion b2b Massane & Because of Art	\N	2026-03-27 21:00:00	2026-03-28 05:00:00	170	RA	\N	https://ra.co/events/2379108	1	2026-02-27 03:38:18.670641	2026-03-03 06:50:11.254072	\N	22.85	Before 12AM	1 of 2	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#D46213	f	f	f	f	\N	\N	\N	mmw
656	Seven Lions (OPHELIA RECORDS)	\N	2026-03-27 21:00:00	2026-03-28 03:00:00	188	RA	\N	https://ra.co/events/2359858	3	2026-02-27 03:38:19.786329	2026-03-06 11:53:33.979575	https://www.eventbrite.com/e/mmw26-seven-lions-midline-miami-tickets-1980935210540?aff=mmw_parties	45.00	\N	\N	#000000	\N	\N	\N	\N	\N	\N	Indoor	18+	\N	\N	#52c77b	t	f	f	t	t	t	\N	mmw
648	Sagamore Pool Party MMW: Knee Deep In Miami with Hot Since 82	\N	2026-03-27 13:00:00	2026-03-27 23:00:00	171	RA	\N	https://ra.co/events/2284082	143	2026-02-27 03:38:18.278173	2026-03-03 06:50:10.863016	\N	114.30	GA - Tier 2	5 of 6	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#FCE93A	f	f	f	f	\N	\N	\N	mmw
652	Perspectives Digital x Alaya - Luxury Yacht Cruise	\N	2026-03-27 14:30:00	2026-03-27 19:00:00	193	RA	\N	https://ra.co/events/2376077	32	2026-02-27 03:38:18.870619	2026-03-03 06:50:11.384238	\N	68.55	Early bird	1 of 3	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#4CA8FF	f	f	f	f	t	\N	\N	mmw
653	House Is A Feeling (Nervous Records)	\N	2026-03-27 18:00:00	2026-03-28 04:00:00	194	RA	Nervous Records is America's longest standing and most storied independent Dance Label. The House Is A Feeling event is a celebration of the legacy of Nervous Records and the role it has played through the decades in spotlighting the best in House Music, Tech House, Techno, Afro-house and all the various sub-genres that propel dancefloors around the world. There is no cover charge for this event.\r\n	https://ra.co/events/2372578	16	2026-02-27 03:38:19.234858	2026-03-06 11:55:46.463677	\N	0.00	\N	\N	#ffffff	\N	\N	\N	\N	t	\N	Both	21+	\N	\N	#d25e14	t	f	f	f	t	\N	\N	mmw
671	Black Coffee at the Racetrack	\N	2026-03-28 18:00:00	2026-03-29 01:00:00	197	RA	Black Coffee in Open Air at the Racetrack at Hialeah Park Casino for MMW, Saturday March 28th.\r\n\r\nDoors at 6PM\r\n\r\nGA 18+ | VIP 21+\r\n\r\n\r\nSE Entrance\r\n2200 E 4th Ave\r\nHialeah, FL 33013	https://ra.co/events/2355884	19	2026-02-27 03:38:20.531092	2026-03-06 12:01:45.576579	https://dice.fm/partner/tickets/event/7dpg36-black-coffee-carlita-kaz-james-at-the-racetrack-mmw-26-28th-mar-club-space-miami-miami-hialeah-park-casino-hialeah-tickets?dice_id=8215878&dice_channel=web&dice_tags=organic&dice_campaign=short+link&dice_feature=mio_marketing&_branch_match_id=1555798105460415192&utm_source=mmw_parties	85.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N	Both	21+	\N	\N	#767F8C	t	f	f	f	t	\N	\N	mmw
668	Louie Vega & FRIENDS: Moodymann, Anané, Karizma	\N	2026-03-28 15:00:00	2026-03-28 22:00:00	173	RA	\N	https://ra.co/events/2368462	42	2026-02-27 03:38:20.186761	2026-03-03 06:50:12.161439	\N	40.00	GA - 1st Release	2 of 8	#052E16	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#20BB59	f	f	f	f	\N	\N	\N	mmw
658	Get Busy v. Madafakaz	\N	2026-03-27 23:00:00	2026-03-28 05:00:00	175	RA	\N	https://ra.co/events/2354377	2	2026-02-27 03:38:19.854739	2026-03-03 06:50:11.865684	https://link.dice.fm/E026d2ecc8ef?dice_id=E026d2ecc8ef&utm_source=mmwparties	30.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#341864	t	f	f	f	t	\N	\N	mmw
649	Stereo Annual Showcase with Chus & More	\N	2026-03-27 21:00:00	2026-03-28 05:00:00	224	RA	\N	https://ra.co/events/2362522	42	2026-02-27 03:38:18.470616	2026-03-03 06:50:11.165538	\N	22.85	ENTRY BEFORE 11PM	2 of 8	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#632EBE	f	f	f	f	\N	\N	\N	mmw
659	Seven Lions	\N	2026-03-27 21:00:00	2026-03-28 03:00:00	188	RA	\N	https://ra.co/events/2358160	2	2026-02-27 03:38:19.865117	2026-03-03 06:50:11.871585	https://www.eventbrite.com/e/mmw26-seven-lions-midline-miami-tickets-1980935210540?aff=mmwparties	40.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N		18+	\N	\N	#1EAD53	t	f	f	f	t	t	\N	mmw
650	Ferry Corsten X Giuseppe Ottaviani	\N	2026-03-27 21:00:00	2026-03-28 05:00:00	180	RA	\N	https://ra.co/events/2365612	4	2026-02-27 03:38:18.654273	2026-03-03 06:50:11.246437	\N	22.84	Before 12AM	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N		18+	\N	\N	#B13232	f	f	f	f	\N	\N	\N	mmw
654	Factory Town Music Week	\N	2026-03-27 21:00:00	2026-03-28 07:00:00	172	RA	\N	https://ra.co/events/2363673	10	2026-02-27 03:38:19.535134	2026-03-03 06:50:11.637412	https://link.dice.fm/x2774fb03811?dice_id=x2774fb03811	150.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#199045	t	f	f	f	t	\N	\N	mmw
663	WITTY TUNES SHOWCASE - EDD & FRIENDS	\N	2026-03-27 23:00:00	2026-03-28 06:00:00	165	RA	\N	https://ra.co/events/2376239	0	2026-02-27 03:38:19.986139	2026-03-03 06:50:11.961357	\N	11.45	General admission	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#651F42	f	f	f	f	\N	\N	\N	mmw
662	PNK Music Week '26 (Product Pluto & PNK Records present)	\N	2026-03-27 15:00:00	2026-03-28 00:00:00	173	RA	\N	https://ra.co/events/2355767	0	2026-02-27 03:38:19.972337	2026-03-03 06:50:11.938878	https://posh.vip/e/product-pluto-pnk-records-presents-pnk-music-week-26	30.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N		21+	\N	\N	#20BB59	t	f	f	f	t	\N	\N	mmw
665	Diplo at E11EVEN	\N	2026-03-27 20:00:00	2026-03-28 10:00:00	179	RA	\N	https://ra.co/events/2374671	0	2026-02-27 03:38:20.058219	2026-03-03 06:50:11.944617	https://speakeasygo.com/event/EVE-GJYTGW?t=mmwparties	75.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#642FC0	t	f	f	f	t	\N	\N	mmw
670	Gabriel & Dresden ' Stories We Tell '	\N	2026-03-28 21:00:00	2026-03-29 03:00:00	170	RA	\N	https://ra.co/events/2307525	5	2026-02-27 03:38:20.348384	2026-03-03 06:50:12.263688	\N	22.85	GA - BEFORE 12AM	1 of 2	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#D46213	f	f	f	f	\N	\N	\N	mmw
666	Cosmic Gate Sunset Cruise	\N	2026-03-28 15:00:00	2026-03-28 20:00:00	182	RA	\N	https://ra.co/events/2331102	59	2026-02-27 03:38:20.075264	2026-03-03 06:50:12.041789	\N	175.00	General Admission	2 of 3	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#4699FF	f	f	f	f	\N	\N	\N	mmw
667	Sagamore Pool Party MMW: Danny Tenaglia with Nicole Moudaber	\N	2026-03-28 13:00:00	2026-03-28 23:00:00	171	RA	\N	https://ra.co/events/2322358	42	2026-02-27 03:38:20.150731	2026-03-03 06:50:12.146566	\N	85.70	1st release	3 of 4	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#FCE93A	f	f	f	f	\N	\N	\N	mmw
674	Music On (Marco Carola presents)	\N	2026-03-28 23:00:00	2026-03-29 20:00:00	168	RA	\N	https://ra.co/events/2355892	13	2026-02-27 03:38:20.832893	2026-03-03 06:50:12.445171	https://link.dice.fm/Zbd69ac926ef?dice_id=Zbd69ac926ef&utm_source=mmwparties	50.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#7E3BF2	t	f	f	f	t	\N	\N	mmw
677	SlapFunk x Yoyaku	\N	2026-03-28 22:00:00	2026-03-29 04:00:00	169	RA	\N	https://ra.co/events/2372267	6	2026-02-27 03:38:20.873891	2026-03-03 06:50:12.562326	https://link.dice.fm/Nd984da4b468?dice_id=Nd984da4b468&utm_source=mmwparties	10.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N		21+	\N	\N	#C75C12	t	f	f	f	t	t	\N	mmw
644	Purple Tea Records x DTLA x Psych Drop present: Miami Music Week Label Showcase	\N	2026-03-26 13:00:00	2026-03-26 19:00:00	178	RA	We’re back for our annual Miami Music Week party\r\n\r\nPurple Tea Records x Deep Tech Los Angeles Records x Psych Drop Podcast link up for another day session takeover, celebrating the launch of the Psych Drop Podcast.\r\n\r\nCucu's Nest Bar, Miami Beach\r\nThursday, March 26\r\n1PM – 7PM\r\n\r\nLineup: Above Ground, GT_Ofice, Lauren Mayhew, Matthew Topper, Oscar N, Redux Saints, Shawn Jackson, and more.\r\n\r\nSun, sound, and serious vibes. Expect thicc tech house grooves, signature label energy, and nonstop movement all afternoon.	https://ra.co/events/2377961	0	2026-02-27 03:38:17.8784	2026-03-06 11:40:28.746648	\N	0.00	\N	\N	#000000	\N	\N	\N	\N	t	\N	Indoor	21+	\N	\N	#f2c1c3	t	f	f	f	\N	\N	\N	mmw
639	UNION SHOWCASE - Peppe Citarella & FRIENDS ASTRA	\N	2026-03-26 22:00:00	2026-03-27 04:00:00	165	RA	\N	https://ra.co/events/2376235	1	2026-02-27 03:38:17.66918	2026-03-03 06:50:10.673919	\N	22.85	General admission	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#651F42	f	f	f	f	\N	\N	\N	mmw
641	Miami Music Nexus	\N	2026-03-26 12:00:00	2026-03-26 18:00:00	188	RA	\N	https://ra.co/events/2356163	0	2026-02-27 03:38:17.838416	2026-03-03 06:50:10.782919	https://www.eventbrite.com/e/miami-music-week-nexus-2026-tickets-1981052050010	90.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#1EAD53	t	f	f	f	\N	\N	\N	mmw
642	MMW 2026 - Kazbah Showcase	\N	2026-03-26 20:00:00	2026-03-27 02:00:00	173	RA	\N	https://ra.co/events/2370171	1	2026-02-27 03:38:17.851576	2026-03-03 06:50:10.663344	\N	60.00	Early bird	1 of 10	#052E16	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#20BB59	f	f	f	f	\N	\N	\N	mmw
643	E11EVEN Thursday	\N	2026-03-26 20:00:00	2026-03-27 10:00:00	179	RA	\N	https://ra.co/events/2374670	0	2026-02-27 03:38:17.866283	2026-03-03 06:50:10.790122	https://speakeasygo.com/event/EVE-0A3CYJ?t=mmwparties	55.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#642FC0	t	f	f	f	t	\N	\N	mmw
705	E11EVEN Sunday	\N	2026-03-29 20:00:00	2026-03-30 10:00:00	179	RA	\N	https://ra.co/events/2374680	0	2026-02-27 03:38:22.149173	2026-03-03 06:50:14.357767	https://speakeasygo.com/event/EVE-EM6L2J?t=mmwparties	66.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#642FC0	t	f	f	f	t	\N	\N	mmw
696	Heavy House Society	\N	2026-03-29 22:00:00	2026-03-30 04:00:00	169	RA	\N	https://ra.co/events/2368657	3	2026-02-27 03:38:21.886407	2026-03-03 06:50:14.183909	https://link.dice.fm/nd990e2fa33a?dice_id=nd990e2fa33a&utm_source=mmwparties	10.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N		21+	\N	\N	#C75C12	t	f	f	f	t	\N	\N	mmw
686	GET CRANKED: MIAMI	\N	2026-03-28 21:00:00	2026-03-29 04:00:00	187	RA	\N	https://ra.co/events/2373359	0	2026-02-27 03:38:21.275833	2026-03-03 06:50:12.837675	https://www.tixr.com/groups/blnkcnvs/events/get-miami-175434	70.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N		18+	\N	\N	#0E5127	t	f	f	f	\N	\N	\N	mmw
699	Miami Music Week: Sunday	\N	2026-03-29 23:00:00	2026-03-30 05:00:00	175	RA	DOORS AT 11PM | 21+\r\n\r\nTHIS TICKET DOES NOT GRANT YOU ACCESS TO THE CLUB SPACE TERRACE\r\n\r\nFrom Miami with love,	https://ra.co/events/2356992	1	2026-02-27 03:38:21.998442	2026-03-06 12:12:03.506461	https://dice.fm/partner/tickets/event/v3q9el-f93-x-piv-records-miami-music-week-29th-mar-floyd-miami-miami-tickets?dice_id=8172711&dice_channel=web&dice_tags=organic&dice_campaign=General+Short+Link&dice_feature=mio_marketing&_branch_match_id=1555798105460415192&utm_source=mmw_parties	15.00	\N	\N	#ffffff	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#642fb1	t	f	f	f	\N	\N	\N	mmw
697	MMW 26: Swimming Paul	\N	2026-03-29 22:00:00	2026-03-30 03:00:00	188	RA	\N	https://ra.co/events/2369339	3	2026-02-27 03:38:21.907787	2026-03-03 06:50:14.192021	https://www.eventbrite.com/e/mmw-26-swimming-paul-at-midline-tickets-1982320423750?aff=mmwparties	50.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#1EAD53	t	f	f	f	\N	t	\N	mmw
688	E11EVEN Saturday	\N	2026-03-28 20:00:00	2026-03-29 10:00:00	179	RA	\N	https://ra.co/events/2374673	0	2026-02-27 03:38:21.340251	2026-03-03 06:50:12.851344	https://speakeasygo.com/event/EVE-S2E7FV?t=mmwparties	80.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#642FC0	t	f	f	f	t	\N	\N	mmw
689	ODD MOB	\N	2026-03-28 22:00:00	2026-03-29 05:00:00	188	RA	\N	https://ra.co/events/2379930	0	2026-02-27 03:38:21.347163	2026-03-03 06:50:12.857827	https://www.eventbrite.com/e/mmw26-odd-mob-midline-0328-tickets-1983780601180?utm-campaign=social&utm-content=attendeeshare&utm-medium=discovery&utm-term=listing&utm-source=mmwparties&aff=ebdsshcopyurl	60.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N		21+	\N	\N	#1EAD53	t	f	f	f	t	t	\N	mmw
647	RVDIOVCTIVE x Groove Factory x Clique Cabana	\N	2026-03-26 16:00:00	2026-03-27 05:00:00	192	RA	\N	https://ra.co/events/2379790	9	2026-02-27 03:38:18.087237	2026-03-03 06:50:10.006714	\N	25.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#FF891A	t	f	f	f	\N	\N	\N	mmw
678	Gwen's Gathering	\N	2026-03-28 21:00:00	2026-03-29 03:00:00	198	RA	\N	https://ra.co/events/2347782	2	2026-02-27 03:38:20.941611	2026-03-03 06:50:12.635523	\N	25.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#818A9B	t	f	f	f	\N	\N	\N	mmw
690	Sagamore Pool Party MMW: Glitterbox	\N	2026-03-29 13:00:00	2026-03-29 23:00:00	171	RA	\N	https://ra.co/events/2284185	45	2026-02-27 03:38:21.355179	2026-03-03 06:50:13.131989	\N	85.70	1st release	2 of 4	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#FCE93A	f	f	f	f	\N	\N	\N	mmw
679	Spring Break Boat Trips	\N	2026-03-28 13:00:00	2026-03-28 18:00:00	198	RA	\N	https://ra.co/events/2347797	2	2026-02-27 03:38:20.95666	2026-03-03 06:50:12.65774	\N	40.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#818A9B	t	f	f	f	\N	\N	\N	mmw
691	Guy J & Mariano Mellino	\N	2026-03-29 21:00:00	2026-03-30 05:00:00	180	RA	\N	https://ra.co/events/2305676	20	2026-02-27 03:38:21.4501	2026-03-03 06:50:13.938985	\N	34.30	GA - BEFORE 12AM	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#B13232	f	f	f	f	\N	\N	\N	mmw
692	Cristoph presents COS Miami	\N	2026-03-29 21:00:00	2026-03-30 05:00:00	170	RA	\N	https://ra.co/events/2360733	4	2026-02-27 03:38:21.470392	2026-03-03 06:50:13.946244	\N	22.84	Before 12AM	1 of 2	#111827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#D46213	f	f	f	f	\N	\N	\N	mmw
693	Factory Town Music Week	\N	2026-03-29 21:00:00	2026-03-30 07:00:00	172	RA	\N	https://ra.co/events/2363685	10	2026-02-27 03:38:21.488125	2026-03-03 06:50:13.952113	https://link.dice.fm/Ra26f6178cf1?dice_id=Ra26f6178cf1	100.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#199045	t	f	f	f	t	\N	\N	mmw
680	Valentino Khan & Friends Miami	\N	2026-03-28 22:00:00	2026-03-29 06:00:00	205	RA	\N	https://ra.co/events/2365474	2	2026-02-27 03:38:20.9694	2026-03-03 06:50:12.646848	https://www.tixr.com/groups/blnkcnvs/events/valentino-khan-friends-miami-175015	35.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#7C3AED	t	t	f	f	\N	\N	\N	mmw
701	HOLY MIAMI	\N	2026-03-29 22:00:00	2026-03-30 04:00:00	204	RA	\N	https://ra.co/events/2373362	1	2026-02-27 03:38:22.071763	2026-03-03 06:50:14.242923	https://www.tixr.com/groups/blnkcnvs/events/tba-175277	60.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N		18+	\N	\N	#1CA24D	t	f	f	f	\N	\N	\N	mmw
728	Excursions:Detroit 2026	\N	2026-05-24 21:00:00	2026-05-25 05:00:00	26	RA	\N	https://ra.co/events/2388225	3	2026-03-07 20:31:29.935807	2026-03-08 20:31:30.744568	\N	0.00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
703	MMW 2026 - PlayGRND Series Mami: Spring Fever Edition	\N	2026-03-29 17:00:00	2026-03-29 23:00:00	173	RA	\N	https://ra.co/events/2370264	0	2026-02-27 03:38:22.093953	2026-03-03 06:50:14.339284	\N	60.00	General admission	1 of 2	#052E16	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#20BB59	f	f	f	f	\N	\N	\N	mmw
681	FREEZE PROJECT & INHOUSE RECORDS	\N	2026-03-28 23:00:00	2026-03-29 04:00:00	165	RA	\N	https://ra.co/events/2376240	4	2026-02-27 03:38:21.035326	2026-03-03 06:50:12.567746	\N	22.85	General admission	1 of 2	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	#651F42	f	f	f	f	\N	\N	\N	mmw
700	Ultra Day 3	\N	2026-03-29 12:00:00	2026-03-29 22:00:00	203	RA	\N	https://ultramusicfestival.com/	1	2026-02-27 03:38:22.057481	2026-03-06 12:00:14.208944	\N	500.00	\N	\N	#ffffff	\N	\N	\N	\N	\N	\N	Outdoor	18+	\N	\N	#2fbb60	t	f	t	f	\N	\N	\N	mmw
706	All Hands On Deck	\N	2026-03-29 16:00:00	2026-03-30 03:00:00	191	RA	Heimlich Knüller is one of the few dj’s from Berlin you can call a high quality constant for years. As grandmaster of festivals, tireless treasure hunter & pearl diver, connoisseur of music, prince of track selection, sun dancer and herald of mirth his reputation precedes him.\r\n\r\nMANUMAT, our dear resident DJ; Whether you discover him on the sandy beaches of Tulum, in Black Rock City’s dusty oasis, maybe nestled in the humid jungles of Costa Rica's Envision festival or in a dark bunker in the heart of Berlin, his eclectic blend of sophisticated rhythms are sure to resonate long after the party ends. With a few classic jams and new undiscovered gems along the way.\r\n\r\nBorn in Milan and now based between Miami and New York, Nico Bernardini delivers a fresh fusion of tech house and timeless disco grooves to dance floors worldwide. Sharing decks with icons such as Marco Carola, BLOND:ISH, LP Giobbi, The Martinez Brothers, and RÜFÜS DU SOL, Nicola brings magnetic energy to every set. He is also the founder of Harmonic Heaven, an electrifying party series launched in Miami and expanding worldwide.\r\n\r\nSiegel’s audiences would describe his style as constantly blurring the lines between multiple genres. From Psychedelic Indie, Hypnotic, Minimal & Raw Techno, UK Break, and even proper old school House, there isn’t a style he hasn’t engaged in. He always finds a unique way to combine multiple sounds that seamlessly flow together throughout his sets. With a handful of unreleased originals & remixes, he is keen on pushing his musical boundaries and taking his audiences on a unique and memorable experience.\r\n\r\nEveava is a Medellín-born, Berlin-based DJ and producer known for her adventurous, genre-fluid sets that bridge past and future. Blending everything from 1930s boleros and rare Bowie acapellas to Aphex Twin and amapiano, her sound is an open dialogue between the organic and the electronic, the groovy and the unexpected.\r\n\r\nSebastian Mendoza is a Miami-based DJ and producer blending ’90s house, trance, progressive, and Latin-driven grooves into a dynamic underground sound. From his early beginnings in Panama to sharing stages internationally, he continues to champion vinyl culture and forward-thinking dance music through his project Wax n’ Dance.\r\n	https://ra.co/events/2380001	1	2026-02-27 03:38:22.156455	2026-03-06 12:05:59.790343	https://shotgun.live/en/events/all-hands-on-deck	35.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#f0ae79	t	f	f	f	\N	\N	\N	mmw
704	AC Slater & FRIENDS	\N	2026-03-29 22:00:00	2026-03-30 04:00:00	205	RA	\N	https://ra.co/events/2373366	0	2026-02-27 03:38:22.137623	2026-03-06 12:08:51.371986	https://www.tixr.com/groups/blnkcnvs/events/ac-slater-friends-176058	30.00	FREE BEFORE 12AM	\N	#ffffff	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#351760	t	f	f	t	\N	\N	\N	mmw
702	OUTRO - MMW CLOSING PARTY	\N	2026-03-29 21:00:00	2026-03-30 05:00:00	187	RA	\r\nShare\r\n\r\n\r\n\r\n\r\nOUTRO returns for another Legendary Bass Music Closing Party! BLNK CNVS & Monstercat team up again to produce the biggest closing bass music party that Miami Music Week has ever seen! This party gets bigger and bigger every year and you're not going to want to miss what we have instored for you this year!	https://ra.co/events/2356193	0	2026-02-27 03:38:22.086934	2026-03-06 12:10:23.223284	https://www.tixr.com/groups/blnkcnvs/events/outro-172480	60.00	\N	\N	#000000	\N	\N	\N	\N	\N	\N			\N	\N	#74d395	t	f	f	f	\N	\N	\N	mmw
683	Project Mayhem Industry Social	\N	2026-03-28 12:00:00	2026-03-29 03:00:00	209	RA	\N	https://ra.co/events/2345603	0	2026-02-27 03:38:21.135491	2026-03-03 06:50:12.738954	https://malomediawebsites.wixstudio.com/pmindustrysocial	35.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		18+	\N	\N	#972B2B	t	t	f	f	t	\N	\N	mmw
684	Miami Music Week: Saturday	\N	2026-03-28 23:00:00	2026-03-29 05:00:00	175	RA	\N	https://ra.co/events/2354383	0	2026-02-27 03:38:21.239427	2026-03-03 06:50:12.759482	https://link.dice.fm/Z55373c0294a?dice_id=Z55373c0294a&utm_source=mmwparties	20.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#341864	t	f	f	f	\N	\N	\N	mmw
676	Rodriguez Jr. & Nico Morano (Do Not Sit On MMW)	\N	2026-03-28 22:00:00	2026-03-29 05:00:00	174	RA	\N	https://ra.co/events/2353943	7	2026-02-27 03:38:20.855007	2026-03-03 06:50:12.554163	https://link.dice.fm/X13d276e5112?dice_id=X13d276e5112&utm_source=mmwparties	50.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#FF8F1B	t	f	f	f	t	\N	\N	mmw
685	WHYNOTUS	\N	2026-03-28 23:00:00	2026-03-29 07:00:00	176	RA	\N	https://ra.co/events/2357057	0	2026-02-27 03:38:21.252362	2026-03-03 06:50:12.76772	https://link.dice.fm/s0d1ef6214a9?dice_id=s0d1ef6214a9&utm_source=mmwparties	20.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#7738E4	t	f	f	f	t	\N	\N	mmw
694	SYSTEM Pool Party Miami	\N	2026-03-29 14:00:00	2026-03-29 22:00:00	202	RA	\N	https://ra.co/events/2369402	7	2026-02-27 03:38:21.835759	2026-03-03 06:50:14.142727	\N	11.45	Early bird	1 of 3	#111827	\N	\N	\N	\N	\N	\N		21+	\N	\N	#FFFF50	f	f	f	f	t	\N	\N	mmw
695	PIV x F93	\N	2026-03-29 23:00:00	2026-03-30 06:00:00	175	RA	\N	https://ra.co/events/2364555	4	2026-02-27 03:38:21.870711	2026-03-03 06:50:14.170583	https://link.dice.fm/D68e49828a66?dice_id=D68e49828a66&utm_source=mmwparties	15.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#341864	t	f	f	f	\N	\N	\N	mmw
698	Miami Music Week: Sunday	\N	2026-03-29 23:00:00	2026-03-30 07:00:00	176	RA	\N	https://ra.co/events/2357062	2	2026-02-27 03:38:21.988575	2026-03-03 06:50:14.232234	https://link.dice.fm/adc7c0922ced?dice_id=adc7c0922ced&utm_source=mmwparties	15.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N			\N	\N	#7738E4	t	f	f	f	\N	\N	\N	mmw
675	Doc Martin, DJ Sneak, Matt E Love	\N	2026-03-28 21:00:00	2026-03-29 04:00:00	191	RA	\N	https://ra.co/events/2379997	9	2026-02-27 03:38:20.841497	2026-03-06 12:02:34.601412	https://shotgun.live/en/events/doc-martin-dj-sneak-matt-e-love	53.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N	Indoor	21+	\N	\N	#f0ae79	t	f	f	f	\N	\N	\N	mmw
729	Where Are My Keys - Detroit	\N	2026-05-25 05:00:00	2026-05-26 07:00:00	234	RA	\N	https://ra.co/events/2388713	0	2026-03-08 20:31:30.984236	2026-03-08 20:31:30.98908	\N	27.95	Super Early Bird *No Re-entry	1 of 5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
730	On The One - A Skeez Backyard BBQ Bash	\N	2026-05-25 16:00:00	2026-05-26 04:30:00	159	RA	\N	https://ra.co/events/2388198	1	2026-03-08 20:31:31.196183	2026-03-08 20:31:31.203274	\N	0.00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
624	Beatport Live Pool Parties at WMC - Hot Creations x Three Six Zero Recordings	\N	2026-03-26 13:00:00	2026-03-26 22:00:00	207	RA	\N	https://ra.co/events/2354117	66	2026-02-27 03:38:16.46809	2026-03-03 06:50:10.099141	https://dice.fm/event/bb387o-beatport-live-pool-party-hot-creations-x-tszr-26th-mar-kimpton-epic-hotel-miami-tickets	47.00	\N	\N	#111827	\N	Beatport Live Pool Party	\N	\N	\N	\N		21+	\N	\N	#8F8421	t	t	f	f	\N	\N	\N	mmw
631	Toolroom Miami Open Air	\N	2026-03-26 15:00:00	2026-03-26 23:59:00	185	RA	\N	https://ra.co/events/2356182	10	2026-02-27 03:38:17.275307	2026-03-03 06:50:10.459777	https://www.tixr.com/groups/blnkcnvs/events/toolroom-miami-open-air-172745	60.00	\N	\N	#052E16	\N	\N	\N	\N	\N	\N			\N	\N	#28E66E	t	f	f	f	\N	t	\N	mmw
632	Mira & Tal Fussman (Do Not Sit On MMW)	\N	2026-03-26 22:00:00	2026-03-27 05:00:00	174	RA	\N	https://ra.co/events/2353708	7	2026-02-27 03:38:17.343353	2026-03-03 06:50:10.466193	https://link.dice.fm/Sd0382ecbc3f?dice_id=Sd0382ecbc3f&utm_source=mmwparties	50.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N		21+	\N	\N	#FF8F1B	t	f	f	f	t	\N	\N	mmw
637	Cloonee presents Hellbent	\N	2026-03-26 23:00:00	2026-03-27 20:00:00	168	RA	\N	https://ra.co/events/2355891	5	2026-02-27 03:38:17.641356	2026-03-03 06:50:10.550932	https://link.dice.fm/K404237b8606?dice_id=K404237b8606&utm_source=mmwparties	50.00	\N	\N	#FFFFFF	\N	\N	\N	\N	\N	\N		21+	\N	\N	#7E3BF2	t	f	f	f	t	\N	\N	mmw
669	Cristobal Pesce	\N	2026-03-28 22:00:00	2026-03-29 05:00:00	196	RA	\N	https://ra.co/events/2369534	9	2026-02-27 03:38:20.262927	2026-03-03 06:50:12.245583	\N	45.70	General admission	2 of 2	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#9A470E	f	f	f	f	\N	\N	\N	mmw
577	RE/FORM Detroit Weekender (Wall of Sound, Into The Deep, Anthology)	\N	2024-05-22 22:00:00	2024-05-29 07:00:00	163	RA	\N	https://ra.co/events/2376060	35	2026-02-26 04:13:37.892103	2026-03-07 20:31:29.274771	\N	185.00	Combo Tix: 5.23 Wall of Sound, 5.24 Into The Deep, 5.25 Anthology	6 of 16	#cccccc	\N	\N	\N	\N	\N	\N			\N	\N	#cccccc	f	t	t	f	\N	\N	\N	movement
569	Razor-N-Tape Takeover	\N	2026-05-22 14:00:00	2026-05-23 02:00:00	8	RA	\N	https://ra.co/events/2324409	348	2026-02-26 04:13:36.488622	2026-03-08 20:31:29.541958	\N	45.70	4th Release	5 of 5	#cccccc	\N	Razor-N-Tape	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
570	100% LIVE Techno – ALL HARDWARE SETS	\N	2026-05-22 21:00:00	2026-05-23 06:00:00	10	RA	\N	https://ra.co/events/2278088	266	2026-02-26 04:13:36.588065	2026-03-08 20:31:29.596013	\N	57.15	4th release	5 of 6	#ffffff	\N	100% LIVE Techno	\N	\N	\N	\N			\N	\N	#0e135d	f	f	f	f	t	\N	\N	movement
571	Wall of Sound (DVS1 & RE/FORM present)	\N	2026-05-23 22:00:00	2026-05-24 10:00:00	15	RA	\N	https://ra.co/events/2365128	1807	2026-02-26 04:13:36.618203	2026-03-08 20:31:29.763144	\N	185.00	Combo Tix: 5.23 Wall of Sound, 5.24 Into The Deep, 5.25 Anthology	6 of 6	#cccccc	\N	Wall of Sound	\N	\N	\N	\N			\N	\N	#cccccc	f	f	f	f	t	\N	\N	movement
709	Deep Detroit #16	\N	2026-05-23 22:00:00	2026-05-24 06:00:00	10	RA	\N	https://ra.co/events/2383513	59	2026-03-02 20:31:24.885952	2026-03-08 20:31:30.238347	\N	34.35	Early bird	1 of 2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
619	Thicc Cuts (Subsolar x DTLA present)	\N	2026-03-25 22:00:00	2026-03-26 05:00:00	178	RA	\N	https://ra.co/events/2376601	0	2026-02-27 03:38:16.170675	2026-03-06 11:38:42.6329	https://posh.vip/e/thicc-cuts-miami-dtla-subsolar-music	0.00	\N	\N	#000000	\N	Thicc Cuts 	\N	\N	t	\N			\N	\N	#f2c1c3	t	f	f	f	t	t	\N	mmw
576	CLUB COUSINS	\N	2026-05-23 22:00:00	2026-05-24 04:00:00	159	RA	\N	https://ra.co/events/2361242	60	2026-02-26 04:13:37.788154	2026-03-06 20:31:31.817723	\N	22.60	2nd release	3 of 5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	\N	\N	\N	movement
600	Satoshi Tomiie, Melody & More (NOMAD Talent)	\N	2026-03-24 22:00:00	2026-03-25 05:00:00	224	RA	\N	https://ra.co/events/2375669	49	2026-02-27 03:38:14.387004	2026-03-03 06:50:08.332027	https://link.dice.fm/Tb64c7a98b52?dice_id=Tb64c7a98b52	15.00	ANYTIME ENTRY	1 of 4	#FFFFFF	\N	Satoshi Tomiie, Melody & More	\N	\N	\N	\N		21+	\N	\N	#632EBE	t	f	f	f	t	\N	\N	mmw
606	Cloonee (Sagamore Pool Party)	\N	2026-03-25 13:00:00	2026-03-25 23:00:00	171	RA	\N	https://ra.co/events/2284072	59	2026-02-27 03:38:14.983186	2026-03-03 06:50:08.716183	\N	171.45	90% SOLD OUT: GA - Tier 3	6 of 7	#111827	\N	Cloonee	\N	\N	\N	\N			\N	\N	#FCE93A	f	f	f	f	t	\N	\N	mmw
616	Something Light Showcase (The Hideout presents)	\N	2026-03-25 18:00:00	2026-03-26 03:00:00	165	RA	\N	https://ra.co/events/2376225	3	2026-02-27 03:38:16.036656	2026-03-03 06:50:09.655333	\N	20.00	\N	SOLD OUT	#FFFFFF	\N	Something Light Showcase 	\N	\N	\N	\N			\N	\N	#651F42	t	f	f	f	t	\N	\N	mmw
655	LP Giobbi (Do Not Sit On MMW)	\N	2026-03-27 22:00:00	2026-03-28 05:00:00	174	RA	\N	https://ra.co/events/2359100	6	2026-02-27 03:38:19.773408	2026-03-03 06:50:11.764333	https://link.dice.fm/Y8d5f6f0b81f?dice_id=Y8d5f6f0b81f&utm_source=mmwparties	90.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#FF8F1B	t	f	f	f	t	\N	\N	mmw
664	AGELESS, Nicolas Matar, Esquivel	\N	2026-03-27 21:00:00	2026-03-28 04:00:00	191	RA	\N	https://ra.co/events/2379995	0	2026-02-27 03:38:20.012732	2026-03-03 06:50:11.969587	https://shotgun.live/en/events/ageless-nicolas-matar-esquivel	50.00	\N	\N	#111827	\N	\N	\N	\N	\N	\N			\N	\N	#FF901C	t	f	f	f	\N	\N	\N	mmw
707	Ultra Day 1	\N	2026-03-27 16:00:00	2026-03-28 00:00:00	203	\N	\N	https://ultramusicfestival.com/	\N	2026-02-28 06:06:10.89124	2026-03-06 11:59:48.650943	\N	500.00	\N	\N	#ffffff	\N	\N	\N	\N	\N	\N	Outdoor	18+	\N	\N	#2fbb60	t	f	f	f	\N	\N	\N	mmw
708	Ultra Day 2	\N	2026-03-28 12:00:00	2026-03-29 00:00:00	203	\N	\N	https://ultramusicfestival.com/	\N	2026-02-28 06:07:00.081465	2026-03-06 12:00:02.948924	\N	500.00	\N	\N	#ffffff	\N	\N	\N	\N	\N	\N	Outdoor	18+	\N	\N	#2fbb60	t	f	f	f	\N	\N	\N	mmw
\.


--
-- Data for Name: events_genres; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.events_genres (event_id, genre_id) FROM stdin;
258	11
258	14
260	9
260	18
261	9
261	11
262	19
262	14
264	9
264	10
266	9
266	11
381	9
383	9
270	9
270	12
271	13
272	11
273	21
273	22
383	11
384	9
275	11
275	14
276	24
277	9
277	11
385	9
280	9
280	15
283	9
283	11
285	14
285	13
286	9
286	11
287	9
287	16
288	9
288	11
385	11
292	9
292	11
293	9
293	11
294	9
294	16
388	11
388	26
390	9
390	14
265	11
265	9
267	20
267	9
250	9
251	9
251	17
253	9
253	11
255	11
255	14
312	9
316	11
316	14
317	11
318	14
318	13
321	9
321	11
335	9
335	28
391	20
393	34
394	18
395	9
395	11
398	9
398	35
276	22
276	9
399	9
399	15
400	9
400	11
382	15
382	9
382	36
382	37
382	38
263	24
263	15
263	11
263	9
289	14
289	11
289	9
282	24
282	15
282	12
282	9
284	15
284	14
284	9
386	15
386	13
386	11
386	9
397	15
397	11
397	9
389	15
389	11
389	9
389	29
249	9
249	18
249	15
249	11
315	24
315	15
315	11
315	9
313	9
313	38
313	13
313	11
401	15
401	13
401	11
401	9
403	26
403	21
403	9
404	11
404	9
407	9
407	11
408	28
409	9
409	11
410	9
410	11
411	9
411	11
412	9
412	11
414	9
414	11
416	9
416	17
418	9
418	11
419	9
419	11
420	28
420	14
421	26
423	14
423	40
424	9
424	11
426	9
430	9
430	14
393	36
394	36
421	36
434	36
425	11
425	9
428	15
428	13
428	11
428	9
440	9
440	11
256	11
441	14
442	9
442	14
443	9
443	13
444	9
444	11
445	18
445	43
446	9
447	18
447	43
449	9
449	15
450	18
451	11
451	13
452	11
452	14
453	9
453	14
256	9
454	9
454	44
456	9
456	11
457	9
457	11
458	9
458	11
460	11
460	14
461	45
461	46
462	11
462	28
463	9
463	47
464	9
464	48
465	11
465	49
441	42
467	11
467	18
468	26
468	11
469	21
469	50
470	13
470	17
471	9
408	11
472	9
472	18
473	9
473	11
474	30
474	9
475	26
475	25
477	14
477	51
478	11
478	45
479	11
479	15
480	9
480	11
481	9
481	11
482	11
482	14
483	9
483	11
484	11
484	28
485	18
485	37
486	11
487	9
487	14
426	17
488	11
489	17
489	9
490	17
490	9
491	11
491	13
492	11
492	25
493	9
493	17
494	9
494	11
495	15
495	14
496	11
496	26
497	11
497	26
498	21
498	11
499	9
499	15
500	11
500	25
502	49
504	11
504	14
507	14
507	25
510	26
510	49
511	11
511	14
514	11
514	13
515	11
515	25
519	11
519	13
521	9
521	11
522	11
522	26
523	28
523	52
524	11
524	14
455	9
455	11
525	11
525	15
526	9
526	11
527	53
527	54
528	36
529	42
529	46
530	11
530	55
531	26
531	13
532	56
532	57
533	11
533	28
422	49
534	9
535	43
535	46
536	11
536	42
537	11
537	42
488	26
538	30
538	11
539	11
540	19
540	11
501	11
437	11
437	9
406	9
439	24
439	45
438	15
438	11
438	9
503	44
503	22
503	9
505	17
505	15
505	11
505	9
543	9
543	11
544	9
544	11
545	9
545	11
546	9
546	11
547	36
547	17
548	11
548	42
549	9
549	11
550	9
550	11
551	50
552	11
553	44
553	11
554	9
554	58
556	11
560	13
560	11
560	9
561	11
559	13
559	11
559	9
562	49
562	44
563	11
563	51
384	11
564	26
564	49
565	11
565	13
566	49
566	45
566	11
567	9
567	11
569	11
569	13
570	9
571	9
576	9
576	49
577	9
578	9
578	37
579	11
579	17
580	9
581	55
581	26
582	9
582	15
584	9
587	11
588	9
588	11
589	9
592	11
592	28
593	9
593	11
594	9
595	9
596	9
597	11
598	11
599	11
599	26
600	11
600	26
601	11
603	26
604	11
605	21
605	50
606	11
607	30
607	9
608	9
608	26
609	9
609	11
611	11
613	26
613	28
614	55
614	47
615	59
616	11
616	45
617	26
617	28
618	9
618	26
619	9
619	26
621	11
622	19
622	30
623	30
623	60
624	11
625	11
625	26
628	11
628	51
629	11
630	9
630	55
631	11
632	11
632	14
633	11
633	61
634	16
635	9
636	11
637	26
638	11
638	26
639	11
639	51
640	9
640	11
642	11
642	26
644	11
644	26
645	51
647	11
647	13
648	11
649	11
649	35
650	30
650	9
651	19
651	14
652	9
652	25
653	11
653	51
655	11
655	14
657	19
657	9
658	26
660	11
660	62
661	11
661	26
662	26
663	11
663	62
666	11
666	26
667	11
668	11
668	51
669	9
670	30
670	11
671	51
671	35
672	19
672	11
674	26
676	11
676	14
678	11
678	26
679	11
679	14
680	26
681	11
682	11
682	51
683	24
683	15
684	62
685	26
685	51
687	45
687	63
689	26
690	11
691	19
691	9
692	19
692	11
694	11
694	14
695	11
695	26
696	11
697	11
697	61
698	62
699	62
703	46
620	11
709	9
709	14
713	11
714	11
714	26
715	11
716	11
716	28
717	11
717	26
718	19
718	30
719	11
720	19
720	35
721	11
722	11
722	14
723	9
723	26
724	9
724	11
725	9
725	14
712	9
656	50
656	36
656	30
656	64
656	65
704	26
704	66
728	14
728	42
729	11
729	15
730	11
730	42
\.


--
-- Data for Name: examples; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.examples (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: friendships; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.friendships (id, user_id, friend_id, created_at, updated_at, status) FROM stdin;
\.


--
-- Data for Name: genres; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.genres (id, name, created_at, updated_at, hex_color, short_name, font_color) FROM stdin;
8	Unknown Genre	2025-03-15 03:51:09.009865	2025-03-15 03:51:09.009865	\N	\N	\N
19	Progressive House	2025-03-26 03:16:47.250767	2025-03-26 23:16:08.317831	#ff70e0	Prog. House	#000000
18	Ambient	2025-03-15 04:10:38.406883	2025-03-26 23:16:29.010721	#fbc16f	\N	#000000
17	Acid	2025-03-15 04:10:38.056547	2025-03-26 23:16:35.575303	#2ef014	\N	#000000
16	Bass	2025-03-15 04:10:37.473799	2025-03-26 23:16:43.891907	#e60a0a	\N	#000000
15	Electro	2025-03-15 04:10:37.221151	2025-03-26 23:16:49.109095	#ffea00	\N	#000000
14	Deep House	2025-03-15 04:10:37.19791	2025-03-26 23:16:54.919381	#800a5b	\N	#ffffff
13	Disco	2025-03-15 04:10:37.171937	2025-03-26 23:17:01.016488	#8000ff	\N	#ffffff
12	Dub Techno	2025-03-15 04:10:37.118984	2025-03-26 23:17:06.927108	#5d1414	\N	#ffffff
11	House	2025-03-15 04:10:37.04245	2025-03-26 23:17:12.228387	#ff05bc	\N	#ffffff
10	EBM	2025-03-15 04:10:36.999856	2025-03-26 23:17:17.865035	#18107e	\N	#ffffff
9	Techno	2025-03-15 04:10:36.989375	2025-03-26 23:17:23.577459	#000000	\N	#ffffff
26	Tech House	2025-03-27 06:22:33.525409	2025-03-27 08:20:34.493053	#bc00f0	\N	#ffffff
24	Breakbeat	2025-03-27 06:22:33.499526	2025-03-27 08:21:00.273708	#99d6e5	\N	#000000
22	Jungle	2025-03-27 06:22:33.472442	2025-03-27 08:21:20.029772	#14612f	\N	#ffffff
21	Drum & Bass	2025-03-27 06:22:33.469898	2025-03-27 08:21:43.348605	#6f330b	\N	#ffffff
20	????	2025-03-26 04:31:10.086681	2025-03-27 08:21:53.86069	#00ffbf	\N	#000000
25	Club	2025-03-27 06:22:33.501165	2025-03-27 08:22:23.356574	#cccccc	\N	#000000
27	\N	2025-03-27 08:22:26.520388	2025-03-27 08:22:26.520388	#cccccc	\N	#0d0d0d
29	Funk	2025-04-02 03:44:41.549506	2025-04-02 03:44:41.549506	#ff7b00	\N	#fafafa
30	Trance	2025-04-02 05:48:27.258954	2025-04-02 05:48:27.258954	#f0b7c2	\N	#000000
37	Industrial	2025-04-04 23:38:17.791433	2025-04-04 23:38:17.791433	#5c5c5c	\N	#ffffff
38	Leftfield	2025-04-04 23:38:58.527164	2025-04-04 23:38:58.527164	#0011ff	\N	#ffffff
39	UKG	2025-04-04 23:46:51.668702	2025-04-04 23:46:51.668702	#9b9717	\N	#ffffff
36	Experimental	2025-04-04 23:37:46.858118	2025-04-05 04:02:49.663836	#bdffca	\N	#000000
41	IDM	2025-04-18 00:30:01.472685	2025-04-18 04:49:04.235584	#999999	\N	#000000
28	Minimal	2025-04-01 23:44:48.00038	2025-04-18 04:49:17.651492	#cccccc	\N	#000000
40	Balearic	2025-04-18 00:29:53.519904	2025-04-18 04:51:59.334315	#1a40ff	\N	#ffffff
35	Afro Tech	2025-04-03 04:29:27.102083	2025-04-18 04:53:45.405391	#c05702	Afro	#ffffff
43	Downtempo	2025-04-24 00:18:45.521516	2025-04-24 02:06:20.448495	#583f92	\N	#ffffff
42	Funk / Soul	2025-04-21 19:10:59.017924	2025-04-24 02:06:35.149548	#ff9f1a	\N	#000000
48	Ballroom	2025-05-05 20:22:34.00434	2025-05-05 20:22:34.00434	\N	\N	\N
50	Dubstep	2025-05-05 21:49:43.736286	2025-05-05 21:49:43.736286	#710449	\N	#ffffff
53	Breakcore	2025-05-19 20:31:03.372869	2025-05-19 20:31:03.372869	\N	\N	\N
54	Gabber	2025-05-19 20:31:03.382127	2025-05-19 20:31:03.382127	\N	\N	\N
49	Ghetto Tech	2025-05-05 20:22:35.648897	2025-05-19 22:33:08.046449	#007bff	\N	#000000
58	Vinyl	2025-05-22 22:51:57.158549	2025-05-22 22:51:57.158549	#393838	\N	#ffffff
44	Footwork	2025-04-29 21:46:16.032278	2025-05-22 22:59:39.953332	#ec5b5b	\N	#000000
46	R&B	2025-05-05 20:22:33.064525	2025-05-22 22:59:57.087508	#34570a	\N	#ffffff
34	Post-Punk	2025-04-03 04:29:26.507544	2025-05-22 23:00:22.724702	#236152	\N	#fffafa
45	Hip-Hop	2025-05-05 20:22:33.043373	2025-05-22 23:00:46.425384	#2c258e	\N	#ffffff
55	Garage	2025-05-20 03:30:47.785615	2026-02-26 05:09:38.939027	#cccccc	\N	#000000
51	Afro House	2025-05-08 21:44:55.17722	2026-02-28 05:40:53.842483	#3e7a58	\N	#ffffff
63	Grime	2026-02-27 03:38:21.299105	2026-02-28 05:41:13.329651	#074633	\N	#ffffff
62	Electronica	2026-02-27 03:38:19.871893	2026-02-28 05:41:27.396168	#eeafaf	\N	#000000
61	Dancehall	2026-02-27 03:38:17.368501	2026-02-28 05:41:40.69068	#2f25c1	\N	#ffffff
60	Psytrance	2026-02-27 03:38:16.453456	2026-02-28 05:41:51.373678	#fa9e00	\N	#ffffff
59	Neo Perreo	2026-02-27 03:38:15.986041	2026-02-28 05:42:00.481723	#e0baf2	\N	#000000
57	Afrobeats	2025-05-20 03:30:52.679018	2026-02-28 05:42:28.253554	#ffffff	\N	#ffffff
56	Reggaeton	2025-05-20 03:30:52.674997	2026-02-28 05:42:35.406226	#b31919	\N	#ffffff
52	Minimal Techno	2025-05-17 03:31:02.58696	2026-02-28 05:42:41.40415	#cccccc	\N	#000000
47	UK Funky	2025-05-05 20:22:33.879132	2026-02-28 05:43:02.837715	#90cf07	\N	#ffffff
64	Melodic Dubstep	2026-03-06 11:52:00.731388	2026-03-06 11:52:00.731388	#79dbdc	\N	#000000
65	Future Bass	2026-03-06 11:52:25.984003	2026-03-06 11:52:25.984003	#b57cee	\N	#000000
66	Bass House	2026-03-06 12:06:46.831674	2026-03-06 12:06:46.831674	#823908	\N	#ffffff
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (version) FROM stdin;
20250315002930
20250315002931
20250315002934
20250315002935
20250315002936
20250315002937
20250315004257
20250315034250
20250315035609
20250321043114
20250326021531
20250326025029
20250326033015
20250326035300
20250326045932
20250326231138
20250326231139
20250326231418
20250327002428
20250327043217
20250327071054
20250328213258
20250328222837
20250328222841
20250328225410
20250329002829
20250401235901
20250402000346
20250402014223
20250403024910
20250405022743
20250405041132
20250407013152
20250407023054
20250418175150
20250429220458
20250418221536
20250420191350
20250422021054
20250422023111
20250422024210
20250422024211
20250422040743
20250422040755
20250424042358
20250424042848
20250424043819
20250502172648
20250506015554
20250506040545
20250509005703
20250509163000
20250511045137
20250512063411
20250522213847
20260226234627
20260226234628
20260226234712
20260227014322
20260227015220
20260227223026
\.


--
-- Data for Name: ticket_posts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ticket_posts (id, created_at, updated_at, event_id, price, looking_for, note) FROM stdin;
\.


--
-- Data for Name: user_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_events (id, user_id, event_id, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, email, profile_info, created_at, updated_at, reset_password_token, reset_password_sent_at, remember_created_at, encrypted_password, username, picture, authentication_token, admin) FROM stdin;
4	Carly Patricia	carly.marsh@hotmail.com	\N	2025-05-06 04:27:46.485325	2025-05-06 17:59:35.580366	\N	\N	\N	$2a$12$T0P5iEhfb/3W1BLIwEmkLOlrFt7DPwmS9mbwnnXDEegIK3eEem1q2	carly.marsh@hotmail.com	https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=10171466473495008&height=50&width=50&ext=1749146370&hash=AbbdARFLkahVK_hRsEugomIo	b71aa3b960901aa4ca5abef63ad9714a8e70346d	\N
5	Carly C	carlypmarsh@gmail.com	\N	2025-05-06 20:00:21.114189	2025-05-12 06:55:03.863525	\N	\N	\N	$2a$12$Sq1wHhM618RRUNhpQyYO9.L06K8J0Pe6VIO0FMYJPLJ7oujSlvO3m	carlypmarsh@gmail.com	\N	e04b2e4c78aabd28931931c8d3dcb3c7fee09e61	t
\.


--
-- Data for Name: venues; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.venues (id, name, location, capacity, created_at, updated_at, image_filename, bg_color, font_color, subheading, venue_type, serves_alcohol, notes, venue_url, address, description, distance, additional_images, hex_color, city_key) FROM stdin;
180	Clutch Wynwood	Wynwood	\N	2026-02-27 03:38:16.430876	2026-03-04 17:54:09.904955	\N	#d5575d	#ffffff	\N	Restaurant/Bar/Lounge	\N	\N	https://www.instagram.com/clutch_wynwood/	2250 NW 2nd Ave, Miami, Florida 33127	Your new go-to sports bar inside Wynwood Marketplace	\N	\N	\N	mmw
184	Waterfront Tennis Court 	\N	\N	2026-02-27 03:38:17.180399	2026-03-04 06:03:02.436219	\N	#1FA950	#FFFFFF	Watson Island Park	Music Venue/Event Space	\N	\N	https://ra.co/clubs/141218	Miami Seaplane Base, 1000 MacArthur Cswy, Miami, FL 33132	\N	\N	\N	\N	mmw
197	Hialeah Park Casino	Hialeah	\N	2026-02-27 03:38:20.471406	2026-03-04 06:03:02.54923	\N	#767F8C	#FFFFFF	\N	Other	\N	\N	https://hialeahparkcasino.com/	2200 E 4th Ave, Hialeah, FL	\N	\N	\N	\N	mmw
198	TBA - Miami	\N	\N	2026-02-27 03:38:20.93574	2026-03-04 06:03:02.552481	\N	#4B535F	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
196	Domicile	\N	\N	2026-02-27 03:38:20.257154	2026-03-04 06:45:47.957145	\N	#78340b	#ffffff	\N	Small Intimate Venue	\N	\N	https://www.clubdomicile.com/	2900 NW 7th Ave, Miami, FL	MIAMI'S BEST KEPT SECERT\r\nEXPERIENCE OUR TECHNO UNDERGROUND	\N	\N	\N	mmw
173	ZeyZey	Little Haiti	\N	2026-02-27 03:38:15.578171	2026-03-04 17:59:31.716888	\N	#e6f7ed	#000000	\N	Music Venue/Event Space	\N	\N	https://zeyzeymiami.com/	353 NE 61st Miami, FL	ZeyZey Miami is a 15,000-square-foot, family-friendly, indoor/outdoor music venue and cultural hub in Miami's Little River/Little Haiti area, opened in 2023. It features live music (Afro-Cuban funk, Brazilian disco, salsa, electronic), a curated cocktail program by Esther Merino, and food vendors like Dale Street Food and The Maiz Project	\N	\N	\N	mmw
205	MAD Club Live	Wynwood	\N	2026-02-27 03:38:22.135094	2026-03-04 07:02:42.020409	\N	#351760	#ffffff	\N	Nightclub/Club	\N	\N	https://www.madclubwynwood.com/	55 NE 24th St Miami, FL	MAD Club is Wynwood’s intimate nightlife experience—where reguetton, house, EDM and open-format beats blend into a sensual, elevated atmosphere. A space where conversations matter, bodies move closer, and the night unfolds at its own pace.\r\nYou don’t come here to get lost.\r\nYou come here to feel something.	\N	\N	\N	mmw
182	Hyatt Regency Dock	\N	\N	2026-02-27 03:38:17.137512	2026-03-04 06:34:50.479695	\N	#c8e0f4	#000000	Hyatt Regency Dock	Boat	\N	\N	https://ra.co/clubs/75370	\N	\N	\N	\N	\N	mmw
200	TBA - La Diosa	\N	\N	2026-02-27 03:38:21.083637	2026-03-04 06:03:02.586708	\N	#A8AFB8	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
203	Bayfront Park	Downtown	\N	2026-02-27 03:38:22.053603	2026-03-06 10:50:33.039917	\N	#2fbb60	#ffffff	\N	Music Venue/Event Space	\N	\N	https://ra.co/clubs/798	301 Biscayne Blvd. Miami, FL	\N	\N	\N	\N	mmw
170	Mazuma	Wynwood	\N	2026-02-27 03:38:14.891576	2026-03-04 06:41:03.474258	\N	#f8d4b8	#111827	\N	Small Intimate Venue	\N	\N	https://www.mazumamiami.com/	2411 N Miami Ave, Miami, FL	We are an Event hall in the heart of wynwood. Plenty of seating and dance space with state of the art sound and dj equipment. 	\N	\N	\N	mmw
199	Barsecco	Brickell	\N	2026-02-27 03:38:21.055081	2026-03-04 17:54:48.153681	\N	#c72c35	#ffffff	\N	Restaurant/Bar/Lounge	\N	\N	https://www.barsecco.com/	1421 S MIAMI AVE. MIAMI, FL 33130	Barsecco is a stylish restaurant & lounge that transforms from bright and open to sensual and inviting by night. Enter just off Brickell Avenue onto the breezy canopied terrace where eclectic seating, draping vines and reclaimed barn wood welcome guests to mingle, dine and relax. Inside, plush interiors, towering tree and low lighting lend a seductive edge to an otherwise cozy space.	\N	\N	\N	mmw
167	TBA - Kimpton EPIC Hotel	\N	\N	2026-02-27 03:38:14.501814	2026-03-04 06:03:02.208754	\N	#A8AFB8	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
181	Moxy Miami South Beach	Miami Beach	\N	2026-02-27 03:38:16.474827	2026-03-06 08:37:55.647498	\N	#e6b300	#111827	Moxy Miami South Beach	Pool	\N	\N	https://www.instagram.com/moxysouthbeach/?hl=en	915 Washington Ave, Miami Beach, FL 33139	\N	\N	\N	\N	mmw
192	Coyo Taco	Wynwood	\N	2026-02-27 03:38:18.061885	2026-03-04 06:44:31.172567	\N	#e06f1f	#ffffff	\N	Small Intimate Venue	\N	\N	https://ra.co/clubs/102437	2300 NW 2nd Ave Miami, FL 33127	\N	\N	\N	\N	mmw
201	TBA	\N	\N	2026-02-27 03:38:21.293427	2026-03-04 06:03:02.592125	\N	#4B535F	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
190	TBA - Boat (coconut grove) 	\N	\N	2026-02-27 03:38:17.73095	2026-03-04 06:03:02.512432	\N	#1B1F24	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
168	Club Space Miami	Downtown	\N	2026-02-27 03:38:14.64866	2026-03-04 07:01:06.755905	\N	#8c5ece	#ffffff	\N	Nightclub/Club	\N	\N	https://www.clubspace.com/	34 NE 11 St, Miami, FL	\N	\N	\N	\N	mmw
175	Floyd	Downtown	\N	2026-02-27 03:38:15.961489	2026-03-04 07:01:28.116842	\N	#642fb1	#ffffff	\N	Nightclub/Club	\N	\N	https://www.floydmiami.com/	34 NE 11th Street Miami, FL	Speakeasy with DJs serving Prohibition-era cocktails in a luxe space styled like a British mansion.	\N	\N	\N	mmw
204	RC Cola Plant	Wynwood	\N	2026-02-27 03:38:22.068586	2026-03-04 06:03:02.62376	\N	#CFF2D9	#FFFFFF	\N	Music Venue/Event Space	\N	\N	https://ra.co/clubs/115824	550 NW 24th St, Miami, FL 33127	\N	\N	\N	\N	mmw
178	Cucu's Nest Bar	Miami Beach	\N	2026-02-27 03:38:16.165612	2026-03-04 17:50:59.11037	\N	#f2c1c3	#000000	\N	Restaurant/Bar/Lounge	\N	\N	https://www.cucusnestbar.com/	1672 Collins Ave, South Beach, FL 33139	Visiting Miami or living here? Cucu's Nest bar is incredibly friendly, fun place to visit. Delicious food, special drinks, great atmosphere and incredible people is what describes us!	\N	\N	\N	mmw
171	The Sagamore Hotel	South Beach	\N	2026-02-27 03:38:14.970523	2026-03-06 08:38:02.053491	\N	#ffd433	#111827	The Sagamore Hotel	Pool	\N	\N	https://www.instagram.com/sagamorepoolparty/	1671 Collins Ave; Miami Beach, FL	\N	\N	\N	\N	mmw
195	TBA - Uva Wynwood 	\N	\N	2026-02-27 03:38:19.893436	2026-03-04 06:03:02.542846	\N	#767F8C	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
188	Midline	Wynwood	\N	2026-02-27 03:38:17.559792	2026-03-06 10:49:59.158255	\N	#52c77b	#000000	\N	Music Venue/Event Space	\N	\N	https://www.midlinemiami.com/	2221 NW Miami Ct  Miami, FL	We are a dynamic, transformative space in the heart of Wynwood, designed to inspire connection and fuel expression. We believe that great experiences are born from this very intersection, and our mission is to create a home for artists and brands who want to connect with their audience in a visceral, unforgettable way. We’re not just a venue; we’re an instrument for creativity.	\N	\N	\N	mmw
21	Hart Plaza	\N	\N	2025-03-15 04:10:37.52523	2025-05-16 23:54:32.578994	movement-logo.png	#ff5c00	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#ff5c00	movement
64	TBA - Detroit	\N	\N	2025-04-02 00:04:59.267983	2025-04-02 00:04:59.267983	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
207	Kimpton EPIC Hotel	Downtown	\N	2026-02-27 04:02:42.950031	2026-03-06 08:37:41.350327	\N	#fff3c4	#111827	Kimpton Epic Hotel	Pool	\N	\N	https://www.epichotel.com/	270 Biscayne Blvd. Way Miami, FL	\N	\N	\N	\N	mmw
172	Factory Town	Hialeah	\N	2026-02-27 03:38:15.291575	2026-03-06 10:48:08.264984	\N	#cff2d9	#0d0d0d	\N	Music Venue/Event Space	\N	\N	https://www.factorytown.com/	4800 NW 37th Ave Miami, FL	Rising from the shell of a former mattress factory in Hialeah — Miami’s ‘City of Progress’ — Factory Town is seven acres of steel, concrete, and open sky repurposed into a living, breathing city of sound. Here, every walk of life converges: dreamers, creatives, and misfits.\r\nFrom dusk an unfiltered expanse of stages and warehouses where global music collides with Miami’s underground energy. Factory Town is more than a venue — it’s a community and culture constructed from the ground up, inclusive, relentless, and alive until dawn.	\N	\N	\N	mmw
176	The Ground at Club Space	Downtown	\N	2026-02-27 03:38:15.97925	2026-03-04 07:01:53.025722	\N	#4e248b	#ffffff	\N	Nightclub/Club	\N	\N	https://www.thegroundmiami.com/	34 NE 11th Street  Miami, Florida	Located in the heart of downtown Miami, on the first floor of the world famous Club Space,\r\nThe Ground is the newest mid-sized professional venue to service South Florida and all its live music lovers. \r\nWith flexible floor space allowing between 250 and 555 attendees,\r\nThe Ground is the perfect size to accommodate large events without sacrificing acoustic experience and intimacy. \r\nIt is a room for all types of music, including electronic, rock, hip-hop, soul, and everything in between.	\N	\N	\N	mmw
185	Wynwood Marketplace	Wynwood	\N	2026-02-27 03:38:17.270836	2026-03-06 10:48:51.673848	\N	#b8ebc8	#000000	\N	Music Venue/Event Space	\N	\N	https://www.wynwood-marketplace.com/	2250 NW 2nd Ave Miami, FL	Live art installations, the best shops, and restaurant collaborations with local favorites are just some of the things you can expect upon visiting.\r\nIf you’re looking to grab a bite and enjoy drinks with friends, spend a fun day out with family, or dance with your girls – The Wynwood Marketplace is the perfect place to get together.	\N	\N	\N	mmw
174	Do Not Sit On The Furniture	South Beach	\N	2026-02-27 03:38:15.936747	2026-03-04 06:43:44.381976	\N	#ea9b5c	#ffffff	\N	Small Intimate Venue	\N	\N	https://donotsitonthefurniture.com/	423 16th St. Miami Beach, FL	Do Not Sit On The Furniture is the premier underground movement dedicated to injecting life, meaning, and culture into the underground music scene in Miami and abroad. We stand out from the competition by offering a more sophisticated environment for music lovers who want to enjoy their favorite DJs in an intimate atmosphere.\r\n\r\nDo Not Sit is an intimate environment made for underground music enthusiasts. Our reasonable dress code and cover charge gets you and your friends access to the most cutting edge DJs in Miami. Our professional bartenders can mix up something classic or something a little more eclectic for you and make your night extra special with our bottle service.	\N	\N	\N	mmw
206	South Beach Lady Yacht	\N	\N	2026-02-27 04:02:42.849619	2026-03-04 06:03:02.630202	\N	#4692CF	#FFFFFF	South Beach Lady Yacht	Boat	\N	\N	\N	\N	\N	\N	\N	\N	mmw
164	Esme Hotel Rooftop Miami Beach	Miami Beach	\N	2026-02-27 03:38:13.549086	2026-03-04 06:54:21.248512	\N	#df6c99	#ffffff	Esme Hotel Rooftop	Rooftop	\N	\N	https://www.instagram.com/esmehotel/	1438 Washington Ave, Miami Beach, FL 33139	An extraordinary restaurant and cocktail lounge nestled above the cityscape. Enjoy a delectable lunch while soaking up the sun's warm rays.	\N	\N	\N	mmw
208	La Otra Wynwood	Wynwood	\N	2026-02-27 04:02:43.002592	2026-03-04 17:52:44.033711	\N	#e18d91	#000000	\N	Restaurant/Bar/Lounge	\N	\N	https://www.laotramiami.com/	55 NE 24th St, Miami, FL	Iconic latin nightlife destination , LA OTRA is an upscale bar and lounge in the Wynwood Arts District in Miami.\r\n\r\nPerched behind a black iron gate, guests are greeted with infectious energy featuring lively music and an Indoor/ outdoor space surrounded by lush plants, disco balls, dim lights and sweeping views of the Miami skylights.	\N	\N	\N	mmw
209	La Diosa	Miami Lakes	\N	2026-02-27 04:02:43.07514	2026-03-04 17:54:31.433334	\N	#cf3b43	#ffffff	\N	Restaurant/Bar/Lounge	\N	\N	https://www.ladiosataqueria.com/	7321 Miami Lakes Dr Miami Lakes, FL	We are a Mexican restaurant with a delicious food and craft cocktails with a fun and vibrant atmosphere. we offer a variety of delicious tacos, quesadillas, burritos, fajitas and much more.	\N	\N	\N	mmw
183	The Triangle at Little River	Little Haiti	\N	2026-02-27 03:38:17.155388	2026-03-06 10:49:11.100858	\N	#95dfae	#000000	\N	Music Venue/Event Space	\N	\N	https://thetrianglemiami.com/	200 NE 62nd St. Miami, Fl 33138	The Triangle is Miami’s neighborhood hangout — a place for locals, families, and creatives to gather under the trees, share good food, sip great cocktails, and feel at home. Built on the belief For Locals by Locals, it’s a laid-back corner of the city designed for like-minded adults and parents who value good music, good flavors, and real community.\r\n\r\nA space discovered, not manufactured — and a home base for Miami’s makers, doers, and culture-shapers.	\N	\N	\N	mmw
96	3979 Bangor	\N	\N	2025-04-29 21:46:09.978131	2025-04-30 15:58:01.303475	\N	#8ac2ff	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#8ac2ff	movement
229	94th Aero Squadron	\N	\N	2026-03-03 06:50:10.87855	2026-03-06 10:51:03.15051	\N	#1fa950	#ffffff	\N	Music Venue/Event Space	\N	\N	\N	\N	\N	\N	\N	\N	mmw
151	Time Will Tell	Downtown	\N	2025-05-22 23:36:24.582629	2025-05-22 23:36:52.410204	\N	#4ba086	#000000	\N		\N	\N	https://www.instagram.com/timewilltelldetroit	6408 Woodward Ave	\N	\N	\N	\N	movement
219	Dreamtroit	\N	\N	2026-02-27 20:31:22.2732	2026-02-27 20:31:22.2732	\N	\N	\N	\N	\N	\N	\N	https://ra.co/clubs/221498	\N	\N	\N	\N	\N	movement
232	TBA - Uva Wynwood	\N	\N	2026-03-03 06:50:11.845139	2026-03-04 06:03:02.701811	\N	#D1D5DB	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
222	Coconut Grove Marina	3400 Pan American Dr, Coconut Grove, FL	\N	2026-03-01 03:53:18.618512	2026-03-04 06:35:10.028814	\N	#8dbee4	#000000	Coconut Grove Marina	Boat	\N	\N	\N	\N	\N	\N	\N	\N	mmw
230	Palace Bar	Miami Beach 	\N	2026-03-03 06:50:11.300225	2026-03-04 17:53:45.510584	\N	#d87378	#ffffff	\N	Restaurant/Bar/Lounge	\N	\N	https://palacesouthbeach.com/	1052 Ocean Drive,  Miami Beach, FL 33139	Y'all, step into Palace South Beach, Miami's ultimate LGBTQ+ bar and restaurant. For over 30 years, we've been servin' up the sassiest cocktails, gourmet eats, and the fiercest drag shows and brunches. Strut down to our iconic Ocean Drive spot and see why we're the heart of SoBe's gay scene – and oh, so much more.	\N	\N	\N	mmw
191	Lion's Den	Little River	\N	2026-02-27 03:38:17.962532	2026-03-04 06:43:11.777546	\N	#f0ae79	#111827	\N	Small Intimate Venue	\N	\N	https://fooqsmiami.com/	150 NW 73rd st, Miami, FL	Lion’s Den is set to open above Fooq’s in Miami’s Little River, introducing an intimate, vinyl-forward listening lounge rooted in community, exceptional sound, and carefully curated energy. Created by We All Gotta Eat founders David and Josh Foulquier, the space channels early-2000s New York club culture and old-school Miami nightlife through plush interiors, global DJ programming, and a refined cocktail and wine offering. Designed as an “if you know, you know” destination, Lion’s Den marks a new, music-driven chapter within Miami’s nightlife scene. 	\N	\N	\N	mmw
233	Unseen Creatures Brewing & Blending	South Miami	\N	2026-03-03 06:50:12.898796	2026-03-04 17:55:18.046098	\N	#a2242c	#ffffff	\N	Restaurant/Bar/Lounge	\N	\N	https://unseencreatures.com/	4178 SW 74th CT Miami, FL 33155	\N	\N	\N	\N	mmw
225	Mad Radio Miami	Little River	\N	2026-03-03 06:50:09.775102	2026-03-06 11:33:50.504305	\N	#767f8c	#ffffff	MAD Radio Miami	Small Intimate Venue	\N	\N	https://www.instagram.com/madradiomiami	7700 Biscayne Blvd, Miami, FL 33138	Mad Radio Miami is for all electronic music lovers. The cozy venue is hidden inside of the Selena Gold Dust Hotel right off of Biscayne and 77th.\r\nOur spots are unique experiences where vintage meets urban and eclectic vibes, all powered by local artists, DJs, and special guests from around the globe.	\N	\N	\N	mmw
227	UVA UVA Wynwood	\N	\N	2026-03-03 06:50:10.652267	2026-03-04 06:03:02.65995	\N	#D1D5DB	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
228	TBA - Boat (coconut grove)	\N	\N	2026-03-03 06:50:10.683606	2026-03-04 06:03:02.686127	\N	#A8AFB8	#FFFFFF	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	mmw
193	Musette Yacht	\N	\N	2026-02-27 03:38:18.862341	2026-03-04 06:35:41.372679	\N	#4692cf	#ffffff	Musette Yacht	Boat	\N	\N	https://ra.co/clubs/41270	\N	The Musette is the flagship vessel of Carfi Enterprises. This custom rebuilt yacht is big and was designed with entertainment in mind. Spanning 120 feet long and 3 decks high, Musette can accommodate up to 400 passengers with a 160 seated guest air-conditioned dinning salon. The open-air, multi-purpose, deck 2 can add an additional 150 seated guests, a spacious entertainment and dance floor, or any combination that fits your needs. Coupled with spectacular vistas from Musette's 3rd-level viewing deck, we have all the ingredients for a memorable cruise. \r\n	\N	\N	\N	mmw
224	MODE	Downtown	\N	2026-03-03 06:50:08.309311	2026-03-04 06:58:18.444876	\N	#e2d4f3	#000000	\N	Nightclub/Club	\N	\N	https://mode.miami/	2 South Miami Ave. Miami, FL 33130	Located in the heart of Downtown Miami, MODE is more than just a nightclub. It’s a sanctuary for music lovers, creatives, and cultural tastemakers. As one of the top Miami nightclubs, MODE offers a polite alternative to the city’s mercenary nightlife, with a focus on intimacy, authenticity, and connection.	\N	\N	\N	mmw
202	Greystone Miami Beach	Miami Beach	\N	2026-02-27 03:38:21.830884	2026-03-06 08:37:49.236576	\N	#ffd433	#111827	Greystone Miami Beach	Pool	\N	\N	https://www.greystonehotel.com/?gad_source=1&gad_campaignid=20196270694&gbraid=0AAAAApr4jv6H3XcHKwB0eI1P3ptVM2F61&gclid=CjwKCAiAnoXNBhAZEiwAnItcGyNwEoku1_tGo63eccYK1QRWdKnRIRlbbMTPRjf0zElCY1FDPVVKsRoCddUQAvD_BwE	1920 Collins Ave, Miami Beach, FL 33139	\N	\N	\N	\N	mmw
177	M2 Miami	Miami Beach	\N	2026-02-27 03:38:16.153514	2026-03-04 06:03:02.340932	\N	#351760	#FFFFFF	\N	Nightclub/Club	\N	\N	https://www.m2miami.com/	\N	Located in the heart of South Beach’s Art Deco District, M2 Miami is the ultimate nightlife and event destination. Our 35,000 square foot historic theater transforms into a vibrant mega club by night and a versatile event space by day.	\N	\N	\N	mmw
231	C-Level Rooftop Terrace	Miami Beach	\N	2026-03-03 06:50:11.359737	2026-03-06 11:49:09.36777	\N	#dd9bbf	#000000	C-Level Rooftop	Rooftop	\N	\N	https://www.clevelander.com/clevelander-beach-club.htm	1020 Ocean Dr; Miami Beach, FL 33139	\N	\N	\N	\N	mmw
152	Woodbridge Pub	Woodbridge	\N	2025-05-22 23:43:52.22704	2025-05-23 00:31:25.561791	\N	#592a12	#ffffff	\N		\N	\N	\N	5169 Trumbell, Detroit, MI	\N	\N	\N	\N	movement
234	3fifty Terrace	\N	\N	2026-03-08 20:31:30.974336	2026-03-08 20:31:30.974336	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
221	Uva Uva	Wynwood	\N	2026-02-27 22:48:41.051191	2026-03-04 06:44:12.215284	\N	#e6873f	#ffffff	\N	Small Intimate Venue	\N	\N	https://www.instagram.com/uvauvawynwood/?hl=en	2244 NW 1st Ct, Miami, FL 33127	New Outdoor Venue located in the heart of Wynwood, Miami. We are part of Electric Lady Wynwood 	\N	\N	\N	mmw
153	Lincoln Street Art Park	\N	\N	2025-05-22 23:50:06.368353	2025-05-22 23:50:06.368353	\N	#add6e1	#000000	\N		\N	\N	https://www.instagram.com/lincolnstreet_artpark/?hl=en	1331 Holden St	\N	\N	\N	\N	movement
154	Easy Peasy Patio	Sister bar to Low Key	\N	2025-05-23 00:21:19.343862	2025-05-23 00:21:19.343862	\N	#f9ee7b	#000000	\N		\N	\N	https://www.instagram.com/easypeasydetroit/?hl=en	1456 Woodward Ave, Detroit, Michigan	\N	\N	\N	\N	movement
155	TBA - 1331 Holden	\N	\N	2025-05-23 03:30:46.412533	2025-05-23 03:30:46.412533	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
156	TBA - DONUT VILLA 5875 Vernor Hwy, Detroit, MI 48209	\N	\N	2025-05-23 20:30:54.77633	2025-05-23 20:30:54.77633	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
157	TBA - 3364 Michigan Ave 	\N	\N	2025-05-24 03:30:50.426715	2025-05-24 03:30:50.426715	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
158	TBA - Lincoln Factory	\N	\N	2025-05-24 20:30:53.963627	2025-05-24 20:30:53.963627	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
79	Dessert Oasis Coffee Roasters	Downtown	\N	2025-04-11 22:50:13.649963	2025-05-16 23:54:35.175136	dessert-oasis.png	#ff4775	#ffffff	\N		\N	\N	https://docr.coffee/	1220 Griswold St, Detroit, MI 48226	\N	\N	\N	#ff4775	movement
82	TBA - RELISH ARTS DETROIT 6601 Kercheval Ave	\N	\N	2025-04-18 00:29:20.665971	2025-04-18 00:29:20.665971	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
76	Third Street Bar	\N	\N	2025-04-11 22:49:19.798742	2025-05-16 23:54:34.962908	third-street.png	#8ff8ff	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#8ff8ff	movement
75	The Old Miami	Midtown	\N	2025-04-05 03:38:58.642372	2025-05-16 23:54:34.572439	old-miami.png	#049d79	#ffffff	\N	Bar/Restaurant	\N	\N	\N	3930 Cass Ave, Detroit, MI 48201	venue description	6	\N	#049d79	movement
74	Historic Fort Wayne	Delray/Riverfront	\N	2025-04-05 03:13:07.021295	2025-05-16 23:54:34.521177	techno-5k.png	#f9a85d	#000000	\N		\N	\N	https://www.historicfortwayne.org/	6325 W. Jefferson Detroit, MI	\N	\N	\N	#f9a85d	movement
73	Corktown Tavern	Corktown	\N	2025-04-05 02:57:33.421873	2025-05-16 23:54:34.402523	corktown-tavern.png	#e8d78c	#000000	\N		\N	\N	https://www.instagram.com/explore/locations/2475203/corktown-tavern/	1716 Michigan Ave, Detroit, MI	\N	\N	\N	#e8d78c	movement
80	Detroit Eagle	\N	\N	2025-04-18 00:28:44.715507	2025-05-16 23:54:35.286073	eagle.png	#e40303	#ffffff	\N		\N	\N	https://www.facebook.com/p/The-Eagle-of-Detroit-100054651211590/	950 W McNichols Rd, Detroit, MI 48203	\N	\N	\N	#e40303	movement
77	Russell Industrial Center	\N	\N	2025-04-11 22:49:43.382565	2025-05-16 23:54:35.039824	russell.png	#737373	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#737373	movement
78	Big Pink	\N	\N	2025-04-11 22:49:53.030072	2025-05-16 23:54:35.111627	big-pink.png	#ff66ff	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#ff66ff	movement
6	Tangent Gallery	\N	\N	2025-03-15 03:51:09.027719	2025-05-16 23:54:30.592209	tangent_gallery.png	#f43715	#ffffff	Tangent Gallery	\N	\N	\N	\N	\N	\N	\N	\N	#f43715	movement
85	TBA - Location given after ticket purchase	\N	\N	2025-04-18 00:31:25.821891	2025-04-18 00:31:25.821891	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
71	TBA - DIAMOND BELLE YACHT (Diamond Jacks River Tours)	\N	\N	2025-04-03 04:29:27.099138	2025-04-03 04:29:27.099138	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
22	McShanes Irish Pub	\N	\N	2025-03-15 04:10:37.883615	2025-05-16 23:54:32.738121	mcshanes.png	#3f924f	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#3f924f	movement
81	The Whisky Parlor	\N	\N	2025-04-18 00:29:18.183431	2025-05-16 23:54:35.429905	whiskey-parlor.png	#947400	#ffffff	\N		\N	\N	https://www.facebook.com/whiskyparlor/	608 Woodward Ave, Fl 2, Detroit, MI, United States, Michigan	\N	\N	\N	#947400	movement
93	The Belt Alley	\N	\N	2025-04-24 00:18:44.589863	2025-05-16 23:54:35.961278	belt.png	#367d37	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#367d37	movement
91	TBA - Newlab	\N	\N	2025-04-21 19:10:59.428275	2025-04-21 19:10:59.428275	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
95	Hart Plaza - techno tour	\N	\N	2025-04-24 02:18:17.7129	2025-05-16 23:54:36.129967	movement-logo.png	#ffae00	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#ffae00	movement
94	Batch Brewing Co	\N	\N	2025-04-24 00:18:45.511492	2025-05-16 23:54:36.05689	batch.png	#e8fb89	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#e8fb89	movement
12	Magic Stick	\N	\N	2025-03-15 04:10:37.186686	2025-05-16 23:54:31.431797	magic-stick.png	#9d0aff	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#9d0aff	movement
7	TBA - Secret Location	\N	\N	2025-03-15 04:10:36.986696	2025-03-15 04:10:36.986696	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
8	MotorCity Wine	\N	\N	2025-03-15 04:10:37.035343	2025-05-16 23:54:30.785816	motorcity-wine.png	#751050	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#751050	movement
9	TV Lounge	\N	\N	2025-03-15 04:10:37.04011	2025-05-16 23:54:31.190839	tv_lounge.png	#3fed1d	#000000	\N	\N	\N	\N	\N	\N	\N	\N	\N	#3fed1d	movement
10	TBA	\N	\N	2025-03-15 04:10:37.082795	2025-03-15 04:10:37.082795	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
11	Leland City Club	\N	\N	2025-03-15 04:10:37.116733	2025-05-16 23:54:31.34423	leland.png	#5e2159	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#5e2159	movement
13	Northern Lights Lounge	\N	\N	2025-03-15 04:10:37.19573	2025-05-16 23:54:31.644681	northern-lights.png	#6a2424	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#6a2424	movement
14	TBA - old western market	\N	\N	2025-03-15 04:10:37.20382	2025-03-15 04:10:37.20382	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
16	FOXGLOVE	\N	\N	2025-03-15 04:10:37.39131	2025-05-16 23:54:31.972602	foxglove.png	#e2bafd	#000000	\N	\N	\N	\N	\N	\N	\N	\N	\N	#e2bafd	movement
17	Lincoln Factory	\N	\N	2025-03-15 04:10:37.419374	2025-05-16 23:54:32.041194	lincoln_factory.png	#fff705	#000000	\N	\N	\N	\N	\N	\N	\N	\N	\N	#fff705	movement
18	Red Door Digital	\N	\N	2025-03-15 04:10:37.453084	2025-03-26 23:40:29.61668	\N	#e40101	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#e40101	movement
19	Moondog Cafe	\N	\N	2025-03-15 04:10:37.494471	2025-05-16 23:54:32.235471	moondog.png	#fff8cc	#000000	\N	\N	\N	\N	\N	\N	\N	\N	\N	#fff8cc	movement
20	The Diamond Belle Boat	\N	\N	2025-03-15 04:10:37.518432	2025-05-16 23:54:32.548664	diamond-belle.png	#00a3cc	#ffffff	Diamond Belle Boat		\N	\N	\N	\N	\N	\N	\N	#00a3cc	movement
23	TBA - New Secret Location 	\N	\N	2025-03-15 04:10:37.889705	2025-03-15 04:10:37.889705	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
24	Marble Bar	\N	\N	2025-03-15 04:10:38.089462	2025-05-16 23:54:32.806975	marble_bar.png	#00bfff	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#00bfff	movement
25	Exodos Lounge	\N	\N	2025-03-15 04:10:38.094351	2025-05-16 23:54:32.939404	exodos.png	#ff0ab1	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#ff0ab1	movement
26	Andy Arts	\N	\N	2025-03-15 04:10:38.130192	2025-05-16 23:54:33.051668	andy-arts.png	#bd4b00	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#bd4b00	movement
28	Detroit Shipping Company	\N	\N	2025-03-15 04:10:38.404771	2025-05-21 02:17:52.570769	detroit-shipping-co.png	#3c52be	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#660000	movement
29	Level Two Bar & Rooftop	\N	\N	2025-03-15 04:10:38.901952	2025-05-16 23:54:33.330254	level-two.png	#ba01df	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#ba01df	movement
30	Spot Lite Detroit	\N	\N	2025-03-26 03:16:47.240291	2025-05-16 23:54:33.482345	spotlite.png	#cc8b00	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#cc8b00	movement
31	The Norwood Theatre	\N	\N	2025-03-26 03:16:47.248596	2025-05-16 23:54:33.583529	norwood.png	#06555b	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#06555b	movement
159	Paris Bar	\N	\N	2026-02-26 04:13:37.767539	2026-02-26 04:29:28.40917	\N	#a8d5ff	#0849a4	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
161	TBA - (313) 513 RAVE	\N	\N	2026-02-26 04:13:38.071285	2026-02-26 04:13:38.071285	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
36	T'avli	\N	\N	2025-03-27 06:22:34.564956	2025-03-27 06:22:34.564956	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
65	UFO Bar	\N	\N	2025-04-02 00:04:59.32482	2025-05-16 23:54:33.895954	ufo-bar.png	#8dff5c	#000000	\N	\N	\N	\N	\N	\N	\N	\N	\N	#8dff5c	movement
66	The Bassment	\N	\N	2025-04-02 00:04:59.333935	2025-04-02 02:21:19.047042	\N	#eb0000	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#eb0000	movement
67	The Gold Bar Detroit	\N	\N	2025-04-02 00:04:59.376073	2025-04-02 02:25:11.858288	\N	#eba000	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#eba000	movement
68	TBA - Midnight temple	\N	\N	2025-04-02 00:04:59.456271	2025-04-02 00:04:59.456271	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
69	Midnight Temple	\N	\N	2025-04-02 02:35:45.421136	2025-05-16 23:54:33.97375	midnight-temple.png	#6c0094	#ffffff	\N	\N	\N	\N	\N	\N	\N	\N	\N	#6c0094	movement
70	Menjo's	\N	\N	2025-04-02 05:54:42.013754	2025-05-16 23:54:34.164951	menjos.png	#ff0000	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#ff0000	movement
72	MIX Bricktown	\N	\N	2025-04-05 01:12:11.982534	2025-05-16 23:54:34.26407	mix-bricktown.jpg	#04f000	#000000	\N		\N	\N	\N	641 Beaubien Blvd, Detroit, MI	\N	\N	\N	#04f000	movement
83	Old Miami	\N	\N	2025-04-18 00:29:57.475924	2025-04-18 00:29:57.475924	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
84	Collected Detroit	\N	\N	2025-04-18 00:30:01.063122	2025-05-16 23:54:35.461201	collected-detroit.png	#4b5bd2	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#4b5bd2	movement
86	Relish Arts Detroit	\N	\N	2025-04-18 00:46:55.013996	2025-04-18 00:46:55.013996	\N	#79497e	#ffffff	\N		\N	\N	\N	6601 Kercheval Ave	\N	\N	\N	#79497e	movement
87	The Fillmore	\N	\N	2025-04-18 05:01:47.081888	2025-05-16 23:54:35.604449	shrek-fillmore.png	#b0c400	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#b0c400	movement
88	Bookie's Bar	Midtown	\N	2025-04-18 05:19:43.05323	2025-05-16 23:54:35.662277	bookies.png	#8f0505	#ffffff	\N		\N	\N	https://www.bookiesbar.com/	2208 Cass Ave, Detroit, MI 48201	\N	\N	\N	#8f0505	movement
89	RnR Saloon/Detroit Eagle	\N	\N	2025-04-21 19:10:56.643488	2025-04-21 19:10:56.643488	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
90	The High Dive	\N	\N	2025-04-21 19:10:57.126959	2025-05-16 23:54:35.779048	high-dive.png	#fad000	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#fad000	movement
92	Newlab	Michigan Central Station	\N	2025-04-21 19:30:24.601525	2025-05-16 23:54:35.875843	newlab.png	#3b2650	#ffffff	\N		\N	\N	\N	2050 15th St, Detroit, MI 48216, United States	\N	\N	\N	#3b2650	movement
97	TBA - Batch Brewing Co	\N	\N	2025-04-29 21:46:12.914229	2025-04-29 21:46:12.914229	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
15	Bert's Warehouse Theater	\N	\N	2025-03-15 04:10:37.21892	2025-05-16 23:54:31.693743	berts_warehouse.png	#ffa366	#000000	\N	\N	\N	\N	\N	\N	\N	\N	\N	#ffa366	movement
27	Mati's Avli Rooftop	\N	\N	2025-03-15 04:10:38.376755	2025-05-16 23:54:33.139659	matis-avli.png	#0063cc	#ffffff	Rooftop Bar	\N	\N	\N	\N	\N	\N	\N	\N	#0063cc	movement
150	Time Will Tell	\N	\N	2025-05-22 23:36:24.373288	2025-05-22 23:36:24.958184	\N	#4ba086	#000000	\N		\N	\N	https://www.instagram.com/timewilltelldetroit	\N	\N	\N	\N	\N	movement
37	Old Western Market	Corktown	\N	2025-03-27 07:18:08.296424	2025-05-16 23:54:33.774876	old-western-logo.png	#dbc1b3	#000000	\N	Outdoor Event Space	\N	\N	https://oldwesternmarket.com/	 2640 Michigan Ave. Detroit, MI 48216	Nestled in the growing and evolving neighborhood of Historic Corktown, we invite a new era of commerce beneath its storied historic canopies. Our marketplace is where the heartbeats of Detroit's communities sync with the rhythm of local commerce. Here, tantalizing aromas waft from the finest food trucks Detroit has to offer, while fresh, local produce and handcrafted artisanal goods gleam under the sunlit tents.	\N	\N	#dbc1b3	movement
98	The Shadow Gallery	\N	\N	2025-04-29 21:46:12.991244	2025-05-16 23:54:36.184392	shadow-gallery.png	#398a2e	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#398a2e	movement
99	Spkrbox	\N	\N	2025-04-29 21:46:17.492692	2025-05-16 23:54:36.274676	spkrbox.png	#ff961f	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#ff961f	movement
100	Halo Bar and Lounge	\N	\N	2025-04-29 21:46:17.557665	2025-05-16 23:54:36.846445	halo.png	#ff66cf	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#ff66cf	movement
101	The Eagle of Detroit	\N	\N	2025-05-05 20:22:33.869062	2025-05-05 20:22:33.869062	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
102	Trumbullplex	\N	\N	2025-05-05 20:22:33.997242	2025-05-05 20:26:31.34291	\N	#a32e2e	#ffffff	Trumbellplex		\N	\N	\N	\N	\N	\N	\N	#a32e2e	movement
103	Temple Bar	Midtown	\N	2025-05-05 20:22:35.640208	2025-05-23 19:36:14.595034	temple.png	#df345a	#ffffff	\N		\N	\N	https://www.instagram.com/templebardetroit	2906 Cass Ave	\N	\N	\N	#df345a	movement
104	Newlab Detroit	\N	\N	2025-05-05 20:22:36.29248	2025-05-05 20:22:36.29248	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
105	Hot Bones	\N	\N	2025-05-08 21:44:52.08775	2025-05-08 21:44:52.08775	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
106	7824 Mount Elliott St, Detroit, MI	\N	\N	2025-05-08 21:44:52.702565	2025-05-08 21:59:29.716957	\N	#3ddb6d	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#3ddb6d	movement
107	Common Pub	\N	\N	2025-05-08 21:44:53.475124	2025-05-16 23:54:36.849997	common-pub.png	#6f38d6	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#6f38d6	movement
108	Bleu	\N	\N	2025-05-08 21:44:56.59313	2025-05-16 23:54:36.985734	bleu.png	#0029a3	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#0029a3	movement
109	Belle Isle Park	\N	\N	2025-05-12 06:16:17.432431	2025-05-18 00:44:58.407973	\N	#028000	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	#0a7b35	movement
110	Mudgies	\N	\N	2025-05-12 06:16:18.889916	2025-05-18 01:00:45.966028	\N	#ffb81f	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#8665e2	movement
111	7824 Mount Elliott St, Detroit, MI	\N	\N	2025-05-12 06:16:19.64271	2025-05-13 05:17:13.430317	\N	\N	#cccccc	\N		\N	\N	\N	\N	\N	\N	\N	#cccccc	movement
112	TBA - 225 Jos Campau, Detroit, MI 48207	\N	\N	2025-05-12 20:30:46.782756	2025-05-12 20:30:46.782756	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
113	Lowkey	\N	\N	2025-05-13 03:30:51.590579	2025-05-17 00:10:40.345248	\N	#865fa5	#000000	\N		\N	\N	\N	\N	\N	\N	\N	#98d3ec	movement
145	Underground Music Academy	\N	\N	2025-05-22 20:30:46.710876	2025-05-22 22:59:02.372541	\N	#56f5cd	#0d0d0d	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
124	Bookies	\N	\N	2025-05-17 03:30:59.422006	2025-05-17 03:30:59.422006	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
114	TBA - 7824 Mount Elliott St, Detroit, MI	\N	\N	2025-05-13 20:30:54.73554	2025-05-13 20:30:54.73554	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
115	Lagerhaus No. 5	\N	\N	2025-05-14 20:30:52.215185	2025-05-19 22:22:51.373244	\N	#698c3c	#000000	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
116	Well Done Goods	Eastern Market	\N	2025-05-14 20:30:55.931697	2025-05-20 18:21:00.016162	\N	#f942fc	#000000	\N		\N	\N	https://welldonegoods.com/	1515 Division St Suit A, Detroit, MI 48207	\N	\N	\N	\N	movement
117	Puma Detroit	\N	\N	2025-05-15 03:30:52.291847	2025-05-19 22:14:12.32976	\N	#e73739	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
118	dez Delmar Store	Downtown	\N	2025-05-15 03:30:53.920221	2025-05-19 22:32:32.068135	\N	#de293f	#000000	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
119	Hotel Saint Regis Detroit	\N	\N	2025-05-15 20:30:58.340195	2025-05-15 20:30:58.340195	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
120	Society Detroit	Woodbridge	\N	2025-05-15 20:31:01.368618	2025-05-20 18:06:04.778193	\N	#700031	#ffffff	\N		\N	\N	https://www.instagram.com/societydetroit/?hl=en	1995 Woodbridge St, Detroit, MI 48207	\N	\N	\N	\N	movement
121	The Golden Rule	13441 PURITAN AVE. DETROIT MI 48235	\N	2025-05-15 20:31:01.541868	2025-05-22 19:37:33.197423	\N	#fcb936	#000000	\N		\N	\N	https://www.instagram.com/thegoldenrulelounge/	\N	\N	\N	\N	\N	movement
122	The Loft at Café Prince	Core City	\N	2025-05-16 20:30:59.905187	2025-05-20 18:35:47.768791	\N	#0807cd	#ffffff	The Loft		\N	\N	https://www.instagram.com/cafeprince.corecity/?hl=en	4884 Grand River Ave., Detroit, Michigan 48208	\N	\N	\N	\N	movement
125	ZUZU Upstairs	Downtown	\N	2025-05-17 03:31:04.242884	2025-05-20 18:32:35.702179	\N	#a01c1c	#ffffff	\N		\N	\N	\N	Upstairs in ZUZU: 511 Woodward, Suite 200, Detroit, MI 48226	\N	\N	\N	\N	movement
133	Johnny Noodle King	West Side Indudstrial	\N	2025-05-20 18:10:37.402334	2025-05-20 18:10:37.676803	\N	#d42f28	#ffffff	\N		\N	\N	http://www.johnnynoodleking.com	2601 W Fort St, Detroit, MI 48216	\N	\N	\N	\N	movement
139	Behind the Packard Plant	On the lawn behind the Packard Plant on Canton street between E Kirby and E Ferry (Midtown?)	\N	2025-05-21 03:30:52.882106	2025-05-21 18:05:25.529899	\N	#197a05	#ffffff	\N		\N	\N	\N	5432 Canton St	\N	\N	\N	\N	movement
126	TBA - Johnny Noodle King	\N	\N	2025-05-18 03:30:44.388559	2025-05-18 03:30:44.388559	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
127	The Complex Multimedia Media Center.	\N	\N	2025-05-18 20:30:57.911879	2025-05-18 20:30:57.911879	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
128	The Garage	North End	\N	2025-05-19 03:30:59.881596	2025-05-20 18:26:31.02623	\N	#ff0000	#ffffff	\N		\N	\N	https://www.facebook.com/theGarageDetroit/?locale=tl_PH	7615 Oakland AveDetroit, MI 48211	The Garage is an open-air space in the North End, Detroit that lives as a hub for grassroots neighborhood-led music culture and arts happenings.	\N	\N	\N	movement
129	Jobstoppers Inc. 	\N	\N	2025-05-19 20:31:03.360533	2025-05-20 18:29:06.051169	\N	#cc8b00	#000000	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
123	6112 Lincoln Street	Lincoln Art Park	\N	2025-05-17 00:16:18.523109	2025-05-17 00:17:09.372544	\N	#059922	#ffffff	\N		\N	\N	\N	\N	Free Parking @ the Art Block across the street.	\N	\N	\N	movement
130	27th Letter Books	Southwest	\N	2025-05-19 20:31:05.437674	2025-05-20 18:43:21.213558	\N	#0a8199	#ffffff	\N		\N	\N	https://www.27thletterbooks.com/	3546 Michigan Ave, Detroit, MI 48216	\N	\N	\N	\N	movement
134	225 Speakeasy	In Atwater Brewery/Rivertown Warehouse District	\N	2025-05-20 18:14:19.774481	2025-05-20 18:14:19.774481	\N	#458296	#ffffff	225 Speakeasy		\N	\N	https://www.instagram.com/225speakeasy/?hl=en	225 Jos Campau, Detroit, MI 48207	\N	\N	\N	\N	movement
135	TBA - Jobstoppers Inc. 	\N	\N	2025-05-20 20:30:59.583413	2025-05-20 20:30:59.583413	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
136	TBA - The Garage	\N	\N	2025-05-20 20:30:59.631282	2025-05-20 20:30:59.631282	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
131	Vollmers	Downtown	\N	2025-05-20 03:30:46.142937	2025-05-20 18:14:41.103206	\N	#d1a42d	#000000	\N		\N	\N	https://www.vollmersdetroit.com/	2040 Park Ave  Detroit MI 48226	\N	\N	\N	\N	movement
132	Paramita Sound	Downtown	\N	2025-05-20 03:30:47.780316	2025-05-20 17:51:29.40222	\N	#f6b3ff	#000000	\N		\N	\N	https://paramitasound.com/	1517 Broadway St, Detroit, USA	\N	\N	\N	\N	movement
137	TBA - ZUZU Upstairs	\N	\N	2025-05-20 20:30:59.727482	2025-05-20 20:30:59.727482	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
138	Delux Lounge	\N	\N	2025-05-20 20:30:59.816662	2025-05-21 02:16:09.244239	\N	#ddb134	#000000	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
140	Two James Spirits	Corktown	\N	2025-05-21 20:31:16.09793	2025-05-22 20:01:08.187211	\N	#907645	#000000	Two James Spirits		\N	\N	https://twojames.com/	2445 Michigan Avenue Detroit, MI 48216	\N	\N	\N	\N	movement
141	Motor City Street Dance Academy	\N	\N	2025-05-21 20:31:18.108089	2025-05-22 00:42:06.992255	\N	#8fffa5	#000000	\N		\N	\N	https://motorcitysda.mailchimpsites.com/	6509 Michigan Ave, Detroit, MI	\N	\N	\N	\N	movement
142	TBA - Behind the Packard Plant	\N	\N	2025-05-21 20:31:24.271141	2025-05-21 20:31:24.271141	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
143	TBA - Motor City Street Dance Academy	\N	\N	2025-05-22 03:30:45.852039	2025-05-22 03:30:45.852039	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	movement
144	Supergeil	\N	\N	2025-05-22 03:30:47.56278	2025-05-22 19:34:20.781026	\N	#a64917	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
146	1331 Holden	\N	\N	2025-05-22 20:30:48.492947	2025-05-23 00:47:03.397913	\N	#e1a8a8	#000000	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
147	Cafe Sous Terre	Midtown	\N	2025-05-22 22:41:20.986162	2025-05-22 22:41:21.452541	\N	#146e4d	#afdae9	\N		\N	\N	https://www.instagram.com/cafe_sous_terre	445 W Forest Ave, Unit 7, Detroit, Michigan 48201	\N	\N	\N	\N	movement
148	Packard Art Collective	\N	\N	2025-05-22 22:51:24.313853	2025-05-22 22:51:24.313853	\N	#835cf0	#ffffff	\N		\N	\N	https://www.instagram.com/packardarthouse/	7032 E Ferry St, Detroit	\N	\N	\N	\N	movement
149	Vesper Books & Wine 	\N	\N	2025-05-22 23:29:09.294771	2025-05-22 23:29:09.711839	\N	#ed4545	#141414	\N		\N	\N	https://www.instagram.com/vesperbooksandwine/?hl=en	5001 Grand River Ave, Detroit	\N	\N	\N	\N	movement
160	HALO DETROIT	\N	\N	2026-02-26 04:13:37.985284	2026-02-26 16:39:30.179239	\N	#8e8c5d	#ffffff	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
162	Dreamtroit	in the Freezer & Trackside 	\N	2026-02-26 04:13:38.359433	2026-02-26 05:18:55.580494	\N	#f3b8ff	#000000	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
163	Nowhere	\N	\N	2026-02-26 06:15:12.238003	2026-02-26 06:15:12.238003	\N	#cccccc	#cccccc	\N		\N	\N	\N	\N	\N	\N	\N	\N	movement
194	1-800-Lucky	Wynwood	\N	2026-02-27 03:38:19.138652	2026-03-04 06:44:59.240848	\N	#d25e14	#ffffff	1-800-Lucky	Small Intimate Venue	\N	\N	https://ra.co/clubs/146933	143 Northwest 23rd Street, Miami, FL 33127	1-800-Lucky is Miami's first Asian food hall, spanning 10,000 square feet in Wynwood and featuring a vibrant mix of pan-Asian cuisine from six restaurants, including sushi, Korean food, Vietnamese sandwiches, and hand-crafted dumplings.\r\nThe lively space includes indoor and outdoor seating, two full bars serving various cocktails and drinks, and a private karaoke room for guests to enjoy. Nightly entertainment features live music and DJs, exciting events, and programming, creating a dynamic atmosphere that attracts locals and tourists looking for great food and nightlife.	\N	\N	\N	mmw
186	Limonada	Miami Beach	\N	2026-02-27 03:38:17.362845	2026-03-04 17:51:29.800887	\N	#ebaeb0	#000000	\N	Restaurant/Bar/Lounge	\N	\N	https://www.limonadasouthbeach.com/	825 Washington Ave, Miami Beach, FL 33139	Experience the ultimate brunch celebration at Limonada Breakfast Bar + Brunch, where weekends transform into the hottest day parties in South Beach. Indulge in classic cocktails and our all-day dining menu. Join us for daily happy hour specials, drinking games, and live music with DJs, creating an unforgettable atmosphere.\r\n\r\n​\r\n\r\nConveniently located next to the Clinton Hotel, Limonada offers a modern twist on traditional American and Mexican fare. Plus, win at one of our drinking games like Shake for Shots or Beat the Glass, and enjoy a complimentary drink on us. Celebrate your Miami Beach vacation with us, where every brunch becomes the best day party in town.	\N	\N	\N	mmw
169	Jolene Downtown Miami	Downtown	\N	2026-02-27 03:38:14.676697	2026-03-04 06:41:21.641697	\N	#f5c79e	#111827	\N	Small Intimate Venue	\N	\N	https://www.jolenesoundroom.com/miami/	200 EAST FLAGER ST, MIAMI, FL 11211	A VISION INSPIRED BY THE PAST BUILT FOR PARTYGOERS OF THE PRESENT AND FUTURE, JOLENE SOUND ROOM JOLENE SOUND ROOM IS A ONE-OF-A-KIND SOUND SPACE THAT REPRESENTS THE FIRST FORMAL COLLABORATION BETWEEN HOSPITALITY PIONEERS BAR LAB HOSPITALITY AND LINK MIAMI REBELS | SPACE INVADERS - A MIAMI-BASED NIGHTLIFE TRIO FORMED IN 2016. \r\n\r\nTHE SPACE INSPIRED BY THE FIERCENESS AND FEMININITY OF DOLLY PARTON WILL SHOWCASE THE BEST OF DISCO, HOUSE, AND TECHNO IN BROOKLYN AND MIAMI.	\N	\N	\N	mmw
165	Astra Miami	Wynwood	\N	2026-02-27 03:38:14.267563	2026-03-04 06:52:55.711107	\N	#eec2d9	#000000	\N	Rooftop	\N	\N	https://www.astramiami.com/	2121 NW 2nd Ave Wynwood, Miami, FL 	ASTRA is the ideal rooftop restaurant and lounge to impress as you watch spectacular sunsets while you enjoy Mediterranean cuisine with an emphasis on greek flavors. You can also indulge in bottomless Sunday brunch, sip on the finest wines and crafted cocktails and make new friends. Lounge on overstuffed sofas as you enjoy music nightly from a host of international DJs and live bands and take in the 360-degree sweeping views of Wynwood, Miami.	\N	\N	\N	mmw
179	E11EVEN MIAMI	\N	\N	2026-02-27 03:38:16.278406	2026-03-04 07:00:44.962596	\N	#bb9ee4	#000000	\N	Nightclub/Club	\N	\N	https://www.11miami.com/	29 NE 11th Street, Miami, FL 33132	#1 Club in the USA, #6 Globally by Nightlife International Association. An immersive adventure encompassing the luxury and sophistication of a one-of-kind experience, the world’s only Ultraclub, E11EVEN MIAMI is entertainment reimagined. Winner of the prestigious “Best New Concept” award, as well as landing on the “Top-10 Nightclubs in America” awarded by Nightclub & Bar, plus the “Top-50 Clubs in the world” listed by DJ Magazine and ranked #6 in the “World’s Top-10 New Year’s Eve Celebrations” by Yahoo Travel, stabilizing its presence as one of the most sought-after venue for both public and private events alike.	\N	\N	\N	mmw
187	Mana Wynwood	Wynwood	\N	2026-02-27 03:38:17.441685	2026-03-06 10:49:31.932135	\N	#74d395	#000000	\N	Music Venue/Event Space	\N	\N	https://manawynwood.com/	318 NW 23rd St, Miami, FL 33127	Since 2010, Mana Wynwood has been a cornerstone of Wynwood’s identity as Miami’s Arts and Entertainment District. Our multi-use properties and event venues have hosted thousands of events, spanning the entire spectrum of cultural activities. From art shows and music festivals to concerts, cultural celebrations, political rallies, business conferences, technology showcases, and charitable events, Mana Wynwood has been the backdrop for unforgettable experiences.\r\n\r\nBut Mana Wynwood is more than just a venue. It’s a canvas for artistic expression, showcasing dozens of the largest and most prominent murals and transforming the neighborhood into one of the world’s largest outdoor art museums. Artists from all corners of the globe are drawn to the large-scale canvas that Mana Wynwood provides, allowing them to bring their mural creations to life.	\N	\N	\N	mmw
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 279, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 279, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 138, true);


--
-- Name: artist_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.artist_events_id_seq', 2299, true);


--
-- Name: artists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.artists_id_seq', 1501, true);


--
-- Name: event_attendees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.event_attendees_id_seq', 2, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.events_id_seq', 730, true);


--
-- Name: examples_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.examples_id_seq', 1, false);


--
-- Name: friendships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.friendships_id_seq', 1, false);


--
-- Name: genres_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.genres_id_seq', 66, true);


--
-- Name: ticket_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ticket_posts_id_seq', 1, false);


--
-- Name: user_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_events_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: venues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.venues_id_seq', 234, true);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: artist_events artist_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_events
    ADD CONSTRAINT artist_events_pkey PRIMARY KEY (id);


--
-- Name: artists artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: event_attendees event_attendees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendees
    ADD CONSTRAINT event_attendees_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: examples examples_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.examples
    ADD CONSTRAINT examples_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: ticket_posts ticket_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_posts
    ADD CONSTRAINT ticket_posts_pkey PRIMARY KEY (id);


--
-- Name: user_events user_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_events
    ADD CONSTRAINT user_events_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: venues venues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.venues
    ADD CONSTRAINT venues_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_artist_events_on_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artist_events_on_artist_id ON public.artist_events USING btree (artist_id);


--
-- Name: index_artist_events_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artist_events_on_event_id ON public.artist_events USING btree (event_id);


--
-- Name: index_artists_events_on_artist_id_and_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artists_events_on_artist_id_and_event_id ON public.artists_events USING btree (artist_id, event_id);


--
-- Name: index_artists_events_on_event_id_and_artist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artists_events_on_event_id_and_artist_id ON public.artists_events USING btree (event_id, artist_id);


--
-- Name: index_artists_on_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_artists_on_genre_id ON public.artists USING btree (genre_id);


--
-- Name: index_event_attendees_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_attendees_on_event_id ON public.event_attendees USING btree (event_id);


--
-- Name: index_event_attendees_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_event_attendees_on_user_id ON public.event_attendees USING btree (user_id);


--
-- Name: index_events_genres_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_genres_on_event_id ON public.events_genres USING btree (event_id);


--
-- Name: index_events_genres_on_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_genres_on_genre_id ON public.events_genres USING btree (genre_id);


--
-- Name: index_events_on_city_key_and_event_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_city_key_and_event_url ON public.events USING btree (city_key, event_url);


--
-- Name: index_events_on_venue_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_venue_id ON public.events USING btree (venue_id);


--
-- Name: index_friendships_on_friend_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_friend_id ON public.friendships USING btree (friend_id);


--
-- Name: index_friendships_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_user_id ON public.friendships USING btree (user_id);


--
-- Name: index_ticket_posts_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ticket_posts_on_event_id ON public.ticket_posts USING btree (event_id);


--
-- Name: index_user_events_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_events_on_event_id ON public.user_events USING btree (event_id);


--
-- Name: index_user_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_events_on_user_id ON public.user_events USING btree (user_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON public.users USING btree (authentication_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: index_venues_on_city_key_and_venue_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_venues_on_city_key_and_venue_url ON public.venues USING btree (city_key, venue_url);


--
-- Name: artist_events fk_rails_0bf3afe2ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_events
    ADD CONSTRAINT fk_rails_0bf3afe2ec FOREIGN KEY (artist_id) REFERENCES public.artists(id) ON DELETE CASCADE;


--
-- Name: artists fk_rails_0e8756372a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artists
    ADD CONSTRAINT fk_rails_0e8756372a FOREIGN KEY (genre_id) REFERENCES public.genres(id);


--
-- Name: user_events fk_rails_1b0b06bbc7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_events
    ADD CONSTRAINT fk_rails_1b0b06bbc7 FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_attendees fk_rails_1c126691ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendees
    ADD CONSTRAINT fk_rails_1c126691ed FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: ticket_posts fk_rails_3a5166d8d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ticket_posts
    ADD CONSTRAINT fk_rails_3a5166d8d5 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: user_events fk_rails_717ccf5f73; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_events
    ADD CONSTRAINT fk_rails_717ccf5f73 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: event_attendees fk_rails_c93dfeb29b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.event_attendees
    ADD CONSTRAINT fk_rails_c93dfeb29b FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: friendships fk_rails_d78dc9c7fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT fk_rails_d78dc9c7fd FOREIGN KEY (friend_id) REFERENCES public.users(id);


--
-- Name: friendships fk_rails_e3733b59b7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT fk_rails_e3733b59b7 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: artist_events fk_rails_f22f12deef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist_events
    ADD CONSTRAINT fk_rails_f22f12deef FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: events fk_rails_f476266cf4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_f476266cf4 FOREIGN KEY (venue_id) REFERENCES public.venues(id);


--
-- PostgreSQL database dump complete
--

