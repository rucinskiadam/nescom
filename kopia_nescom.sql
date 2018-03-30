--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.10
-- Dumped by pg_dump version 9.5.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET search_path = public, pg_catalog;

--
-- Name: edited_comment(); Type: FUNCTION; Schema: public; Owner: adam
--

CREATE FUNCTION edited_comment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        --
        -- Create archiwe row of post
        --
        IF (TG_OP = 'UPDATE') THEN
		IF ( NEW.comment != OLD.comment  ) THEN
		    	INSERT INTO post_comments_edit (post_id,comment_id,user_id,comment,create_date,create_time,edit_date,edit_time) 
			values 
			(OLD.post_id,OLD.id_comment,OLD.user_id,OLD.comment,OLD.create_date,OLD.create_time,now()::date,now()::time);
			
			update post_comments set last_edit_date=now()::date,last_edit_time=now()::time,edited=TRUE where id_comment=OLD.id_comment;
           	END IF;
        END IF;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.edited_comment() OWNER TO adam;

--
-- Name: edited_post(); Type: FUNCTION; Schema: public; Owner: adam
--

CREATE FUNCTION edited_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        --
        -- Create archiwe row of post
        --
        IF (TG_OP = 'UPDATE') THEN
		IF ( NEW.content != OLD.content or NEW.tags != OLD.tags ) THEN
		    	INSERT INTO posts_edit (post_id,user_id,tags,content,create_date,create_time,edit_date,edit_time) 
			values 
			(OLD.id_post,OLD.user_id,OLD.tags,OLD.content,OLD.create_date,OLD.create_time,now()::date,now()::time);
			
			update posts set last_edit_date=now()::date,last_edit_time=now()::time,edited=TRUE where id_post=OLD.id_post;
           	END IF;
        END IF;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.edited_post() OWNER TO adam;

--
-- Name: move_pass_to_arch(); Type: FUNCTION; Schema: public; Owner: adam
--

CREATE FUNCTION move_pass_to_arch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        --
        -- Create archiwe row of password
        --
        IF (TG_OP = 'UPDATE') THEN
            INSERT INTO passwords_arch (user_id,password,create_date,create_time,change_date,change_time) values 
		(OLD.user_id,OLD.password,OLD.create_date,OLD.create_time,now()::date,now()::time);
            RETURN NEW;
        END IF;
        RETURN NULL; -- result is ignored since this is an AFTER trigger
    END;
$$;


ALTER FUNCTION public.move_pass_to_arch() OWNER TO adam;

--
-- Name: move_personal_to_arch(); Type: FUNCTION; Schema: public; Owner: adam
--

CREATE FUNCTION move_personal_to_arch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        --
        -- Create archiwe row of personal data
        --
       IF (TG_OP = 'UPDATE') THEN
		IF (OLD.names!=NEW.names or OLD.surname!=NEW.surname or OLD.birth_date!=NEW.birth_date or OLD.email!=NEW.email or OLD.telephon_number!=NEW.telephon_number or OLD.country!=NEW.country ) THEN
	            	INSERT INTO personal_datas_arch (personal_data_id,user_id,names,surname,birth_date,email,telephon_number,country,create_date,create_time,update_date,update_time) 
			values 
			(OLD.id_personal_data,OLD.user_id,OLD.names,OLD.surname,OLD.birth_date,OLD.email,OLD.telephon_number,OLD.country,OLD.create_date,OLD.create_time,now()::date,now()::time);
		END IF;
        END IF;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.move_personal_to_arch() OWNER TO adam;

--
-- Name: stat_archiwe(); Type: FUNCTION; Schema: public; Owner: adam
--

CREATE FUNCTION stat_archiwe() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        --
        -- Create archiwe ifo about stats
        --
        IF (TG_OP = 'UPDATE') THEN
		IF ( NEW.rate != OLD.rate  ) THEN
		    	INSERT INTO stats_arch (stat_id,post_id,user_id,rate,selection_date,selection_time,change_date,change_time) 
			values 
			(OLD.id_stat,OLD.post_id,OLD.user_id,OLD.rate,OLD.selection_date,OLD.selection_time,now()::date,now()::time);
           	END IF;
        END IF;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.stat_archiwe() OWNER TO adam;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_types; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE account_types (
    id_account_type integer NOT NULL,
    type character varying(40)
);


ALTER TABLE account_types OWNER TO adam;

--
-- Name: log_in; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE log_in (
    login character varying(40),
    ip text,
    browser text,
    successfully boolean,
    login_date date DEFAULT (now())::date,
    login_time time without time zone DEFAULT (now())::time without time zone
);


ALTER TABLE log_in OWNER TO adam;

--
-- Name: passwords; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE passwords (
    id_password integer NOT NULL,
    user_id integer,
    password character varying(40) NOT NULL,
    create_date date DEFAULT (now())::date,
    create_time time without time zone DEFAULT (now())::time without time zone
);


ALTER TABLE passwords OWNER TO adam;

--
-- Name: passwords_arch; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE passwords_arch (
    id_password integer NOT NULL,
    user_id integer,
    password character varying(40) NOT NULL,
    create_date date,
    create_time time without time zone,
    change_date date,
    change_time time without time zone
);


ALTER TABLE passwords_arch OWNER TO adam;

--
-- Name: passwords_arch_id_password_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE passwords_arch_id_password_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE passwords_arch_id_password_seq OWNER TO adam;

--
-- Name: passwords_arch_id_password_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE passwords_arch_id_password_seq OWNED BY passwords_arch.id_password;


--
-- Name: passwords_id_password_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE passwords_id_password_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE passwords_id_password_seq OWNER TO adam;

--
-- Name: passwords_id_password_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE passwords_id_password_seq OWNED BY passwords.id_password;


--
-- Name: personal_datas; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE personal_datas (
    id_personal_data integer NOT NULL,
    user_id integer,
    names character varying(30),
    surname character varying(30),
    birth_date date,
    email character varying(100),
    telephon_number character varying(15),
    country character varying(50),
    create_date date DEFAULT (now())::date,
    create_time time without time zone DEFAULT (now())::time without time zone
);


ALTER TABLE personal_datas OWNER TO adam;

--
-- Name: personal_datas_arch; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE personal_datas_arch (
    id_personal_data_arch integer NOT NULL,
    personal_data_id integer,
    user_id integer,
    names character varying(30),
    surname character varying(30),
    birth_date date,
    email character varying(100),
    telephon_number character varying(15),
    country character varying(50),
    create_date date,
    create_time time without time zone,
    update_date date DEFAULT (now())::date,
    update_time time without time zone DEFAULT (now())::time without time zone
);


ALTER TABLE personal_datas_arch OWNER TO adam;

--
-- Name: personal_datas_arch_id_personal_data_arch_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE personal_datas_arch_id_personal_data_arch_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE personal_datas_arch_id_personal_data_arch_seq OWNER TO adam;

--
-- Name: personal_datas_arch_id_personal_data_arch_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE personal_datas_arch_id_personal_data_arch_seq OWNED BY personal_datas_arch.id_personal_data_arch;


--
-- Name: personal_datas_id_personal_data_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE personal_datas_id_personal_data_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE personal_datas_id_personal_data_seq OWNER TO adam;

--
-- Name: personal_datas_id_personal_data_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE personal_datas_id_personal_data_seq OWNED BY personal_datas.id_personal_data;


--
-- Name: post_comments; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE post_comments (
    id_comment integer NOT NULL,
    post_id integer,
    user_id integer,
    comment text,
    create_date date DEFAULT (now())::date,
    create_time time without time zone DEFAULT (now())::time without time zone,
    edited boolean DEFAULT false,
    last_edit_date date,
    last_edit_time time without time zone,
    active boolean DEFAULT true
);


ALTER TABLE post_comments OWNER TO adam;

--
-- Name: post_comments_edit; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE post_comments_edit (
    id_comment_edit integer NOT NULL,
    post_id integer,
    comment_id integer,
    user_id integer,
    comment text,
    create_date date DEFAULT (now())::date,
    create_time time without time zone DEFAULT (now())::time without time zone,
    edit_date date,
    edit_time time without time zone
);


ALTER TABLE post_comments_edit OWNER TO adam;

--
-- Name: post_comments_edit_id_comment_edit_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE post_comments_edit_id_comment_edit_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE post_comments_edit_id_comment_edit_seq OWNER TO adam;

--
-- Name: post_comments_edit_id_comment_edit_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE post_comments_edit_id_comment_edit_seq OWNED BY post_comments_edit.id_comment_edit;


--
-- Name: post_comments_id_comment_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE post_comments_id_comment_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE post_comments_id_comment_seq OWNER TO adam;

--
-- Name: post_comments_id_comment_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE post_comments_id_comment_seq OWNED BY post_comments.id_comment;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE posts (
    id_post integer NOT NULL,
    user_id integer,
    tags character varying(100),
    content text,
    create_date date DEFAULT (now())::date,
    create_time time without time zone DEFAULT (now())::time without time zone,
    edited boolean DEFAULT false,
    last_edit_date date,
    last_edit_time time without time zone,
    active boolean DEFAULT true
);


ALTER TABLE posts OWNER TO adam;

--
-- Name: posts_edit; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE posts_edit (
    id_posts_edit integer NOT NULL,
    post_id integer,
    user_id integer,
    tags character varying(100),
    content text,
    create_date date DEFAULT (now())::date,
    create_time time without time zone DEFAULT (now())::time without time zone,
    edit_date date,
    edit_time time without time zone
);


ALTER TABLE posts_edit OWNER TO adam;

--
-- Name: posts_edit_id_posts_edit_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE posts_edit_id_posts_edit_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE posts_edit_id_posts_edit_seq OWNER TO adam;

--
-- Name: posts_edit_id_posts_edit_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE posts_edit_id_posts_edit_seq OWNED BY posts_edit.id_posts_edit;


--
-- Name: posts_id_post_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE posts_id_post_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE posts_id_post_seq OWNER TO adam;

--
-- Name: posts_id_post_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE posts_id_post_seq OWNED BY posts.id_post;


--
-- Name: stats; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE stats (
    id_stat integer NOT NULL,
    post_id integer,
    user_id integer,
    rate boolean,
    selection_date date DEFAULT (now())::date,
    selection_time time without time zone DEFAULT (now())::time without time zone
);


ALTER TABLE stats OWNER TO adam;

--
-- Name: stats_arch; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE stats_arch (
    id_stat_arch integer NOT NULL,
    stat_id integer,
    post_id integer,
    user_id integer,
    rate boolean,
    selection_date date,
    selection_time time without time zone,
    change_date date DEFAULT (now())::date,
    change_time time without time zone DEFAULT (now())::time without time zone
);


ALTER TABLE stats_arch OWNER TO adam;

--
-- Name: stats_arch_id_stat_arch_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE stats_arch_id_stat_arch_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stats_arch_id_stat_arch_seq OWNER TO adam;

--
-- Name: stats_arch_id_stat_arch_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE stats_arch_id_stat_arch_seq OWNED BY stats_arch.id_stat_arch;


--
-- Name: stats_id_stat_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE stats_id_stat_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE stats_id_stat_seq OWNER TO adam;

--
-- Name: stats_id_stat_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE stats_id_stat_seq OWNED BY stats.id_stat;


--
-- Name: users; Type: TABLE; Schema: public; Owner: adam
--

CREATE TABLE users (
    id_user integer NOT NULL,
    login character varying(40),
    account_type integer,
    is_active boolean
);


ALTER TABLE users OWNER TO adam;

--
-- Name: users_id_user_seq; Type: SEQUENCE; Schema: public; Owner: adam
--

CREATE SEQUENCE users_id_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_user_seq OWNER TO adam;

--
-- Name: users_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: adam
--

ALTER SEQUENCE users_id_user_seq OWNED BY users.id_user;


--
-- Name: id_password; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY passwords ALTER COLUMN id_password SET DEFAULT nextval('passwords_id_password_seq'::regclass);


--
-- Name: id_password; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY passwords_arch ALTER COLUMN id_password SET DEFAULT nextval('passwords_arch_id_password_seq'::regclass);


--
-- Name: id_personal_data; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY personal_datas ALTER COLUMN id_personal_data SET DEFAULT nextval('personal_datas_id_personal_data_seq'::regclass);


--
-- Name: id_personal_data_arch; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY personal_datas_arch ALTER COLUMN id_personal_data_arch SET DEFAULT nextval('personal_datas_arch_id_personal_data_arch_seq'::regclass);


--
-- Name: id_comment; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments ALTER COLUMN id_comment SET DEFAULT nextval('post_comments_id_comment_seq'::regclass);


--
-- Name: id_comment_edit; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments_edit ALTER COLUMN id_comment_edit SET DEFAULT nextval('post_comments_edit_id_comment_edit_seq'::regclass);


--
-- Name: id_post; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY posts ALTER COLUMN id_post SET DEFAULT nextval('posts_id_post_seq'::regclass);


--
-- Name: id_posts_edit; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY posts_edit ALTER COLUMN id_posts_edit SET DEFAULT nextval('posts_edit_id_posts_edit_seq'::regclass);


--
-- Name: id_stat; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats ALTER COLUMN id_stat SET DEFAULT nextval('stats_id_stat_seq'::regclass);


--
-- Name: id_stat_arch; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats_arch ALTER COLUMN id_stat_arch SET DEFAULT nextval('stats_arch_id_stat_arch_seq'::regclass);


--
-- Name: id_user; Type: DEFAULT; Schema: public; Owner: adam
--

ALTER TABLE ONLY users ALTER COLUMN id_user SET DEFAULT nextval('users_id_user_seq'::regclass);


--
-- Data for Name: account_types; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY account_types (id_account_type, type) FROM stdin;
1	ADMIN
2	MODERATOR
3	USER
\.


--
-- Data for Name: log_in; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY log_in (login, ip, browser, successfully, login_date, login_time) FROM stdin;
\.


--
-- Data for Name: passwords; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY passwords (id_password, user_id, password, create_date, create_time) FROM stdin;
2	1	ddddd	2018-01-07	00:25:41.686267
\.


--
-- Data for Name: passwords_arch; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY passwords_arch (id_password, user_id, password, create_date, create_time, change_date, change_time) FROM stdin;
1	1	aaaaa	2018-01-07	00:25:41.686267	2018-01-07	00:26:51.589594
2	1	bbbbb	2018-01-07	00:25:41.686267	2018-01-07	00:27:26.304562
3	1	cccc	2018-01-07	00:25:41.686267	2018-01-07	00:27:51.94785
\.


--
-- Name: passwords_arch_id_password_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('passwords_arch_id_password_seq', 3, true);


--
-- Name: passwords_id_password_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('passwords_id_password_seq', 2, true);


--
-- Data for Name: personal_datas; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY personal_datas (id_personal_data, user_id, names, surname, birth_date, email, telephon_number, country, create_date, create_time) FROM stdin;
1	1	jezus	rucinski	1992-12-22	ruvisdaasd@op.pl	456456465	poland	2018-01-07	19:12:54.026263
\.


--
-- Data for Name: personal_datas_arch; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY personal_datas_arch (id_personal_data_arch, personal_data_id, user_id, names, surname, birth_date, email, telephon_number, country, create_date, create_time, update_date, update_time) FROM stdin;
1	1	1	adam	rucinski	1992-12-20	ruvisdaasd@op.pl	456456465	poland	2018-01-07	19:12:54.026263	2018-01-07	19:15:57.202343
2	1	1	mada	rucinski	1992-12-20	ruvisdaasd@op.pl	456456465	poland	2018-01-07	19:12:54.026263	2018-01-07	19:18:09.239694
3	1	1	madaasdada	rucinski	1992-12-20	ruvisdaasd@op.pl	456456465	poland	2018-01-07	19:12:54.026263	2018-01-07	19:22:42.822976
\.


--
-- Name: personal_datas_arch_id_personal_data_arch_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('personal_datas_arch_id_personal_data_arch_seq', 3, true);


--
-- Name: personal_datas_id_personal_data_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('personal_datas_id_personal_data_seq', 1, true);


--
-- Data for Name: post_comments; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY post_comments (id_comment, post_id, user_id, comment, create_date, create_time, edited, last_edit_date, last_edit_time, active) FROM stdin;
1	1	1	cccc	2018-01-07	16:57:49.2102	t	2018-01-07	17:22:55.481968	t
\.


--
-- Data for Name: post_comments_edit; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY post_comments_edit (id_comment_edit, post_id, comment_id, user_id, comment, create_date, create_time, edit_date, edit_time) FROM stdin;
1	1	1	1	aaaa	2018-01-07	16:57:49.2102	2018-01-07	17:22:07.971681
2	1	1	1	bbbb	2018-01-07	16:57:49.2102	2018-01-07	17:22:55.481968
\.


--
-- Name: post_comments_edit_id_comment_edit_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('post_comments_edit_id_comment_edit_seq', 2, true);


--
-- Name: post_comments_id_comment_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('post_comments_id_comment_seq', 1, true);


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY posts (id_post, user_id, tags, content, create_date, create_time, edited, last_edit_date, last_edit_time, active) FROM stdin;
2	1	bbb	bbb	2018-01-07	12:24:19.953943	f	\N	\N	t
1	1	#aaaa#jjjjjc	aaagggggg	2018-01-07	12:24:17.086939	t	2018-01-07	12:25:15.437635	t
\.


--
-- Data for Name: posts_edit; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY posts_edit (id_posts_edit, post_id, user_id, tags, content, create_date, create_time, edit_date, edit_time) FROM stdin;
1	1	1	aaa	aaa	2018-01-07	12:24:17.086939	2018-01-07	12:25:15.437635
\.


--
-- Name: posts_edit_id_posts_edit_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('posts_edit_id_posts_edit_seq', 1, true);


--
-- Name: posts_id_post_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('posts_id_post_seq', 2, true);


--
-- Data for Name: stats; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY stats (id_stat, post_id, user_id, rate, selection_date, selection_time) FROM stdin;
1	1	1	f	2018-01-07	18:09:06.641078
2	1	1	f	2018-01-07	18:11:58.199313
\.


--
-- Data for Name: stats_arch; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY stats_arch (id_stat_arch, stat_id, post_id, user_id, rate, selection_date, selection_time, change_date, change_time) FROM stdin;
1	1	1	1	t	2018-01-07	18:09:06.641078	2018-01-07	18:13:10.998623
2	2	1	1	t	2018-01-07	18:11:58.199313	2018-01-07	18:13:10.998623
\.


--
-- Name: stats_arch_id_stat_arch_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('stats_arch_id_stat_arch_seq', 2, true);


--
-- Name: stats_id_stat_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('stats_id_stat_seq', 2, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: adam
--

COPY users (id_user, login, account_type, is_active) FROM stdin;
1	adam	1	t
\.


--
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: adam
--

SELECT pg_catalog.setval('users_id_user_seq', 1, true);


--
-- Name: account_types_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY account_types
    ADD CONSTRAINT account_types_pkey PRIMARY KEY (id_account_type);


--
-- Name: passwords_arch_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY passwords_arch
    ADD CONSTRAINT passwords_arch_pkey PRIMARY KEY (id_password);


--
-- Name: passwords_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY passwords
    ADD CONSTRAINT passwords_pkey PRIMARY KEY (id_password);


--
-- Name: personal_datas_arch_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY personal_datas_arch
    ADD CONSTRAINT personal_datas_arch_pkey PRIMARY KEY (id_personal_data_arch);


--
-- Name: personal_datas_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY personal_datas
    ADD CONSTRAINT personal_datas_pkey PRIMARY KEY (id_personal_data);


--
-- Name: post_comments_edit_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments_edit
    ADD CONSTRAINT post_comments_edit_pkey PRIMARY KEY (id_comment_edit);


--
-- Name: post_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments
    ADD CONSTRAINT post_comments_pkey PRIMARY KEY (id_comment);


--
-- Name: posts_edit_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY posts_edit
    ADD CONSTRAINT posts_edit_pkey PRIMARY KEY (id_posts_edit);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id_post);


--
-- Name: stats_arch_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats_arch
    ADD CONSTRAINT stats_arch_pkey PRIMARY KEY (id_stat_arch);


--
-- Name: stats_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_pkey PRIMARY KEY (id_stat);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- Name: t_edited_comment; Type: TRIGGER; Schema: public; Owner: adam
--

CREATE TRIGGER t_edited_comment AFTER UPDATE ON post_comments FOR EACH ROW EXECUTE PROCEDURE edited_comment();


--
-- Name: t_edited_post; Type: TRIGGER; Schema: public; Owner: adam
--

CREATE TRIGGER t_edited_post AFTER UPDATE ON posts FOR EACH ROW EXECUTE PROCEDURE edited_post();


--
-- Name: t_move_pass_to_arch; Type: TRIGGER; Schema: public; Owner: adam
--

CREATE TRIGGER t_move_pass_to_arch AFTER UPDATE ON passwords FOR EACH ROW EXECUTE PROCEDURE move_pass_to_arch();


--
-- Name: t_move_pass_to_arch; Type: TRIGGER; Schema: public; Owner: adam
--

CREATE TRIGGER t_move_pass_to_arch AFTER UPDATE ON personal_datas FOR EACH ROW EXECUTE PROCEDURE move_personal_to_arch();


--
-- Name: t_stats_edit; Type: TRIGGER; Schema: public; Owner: adam
--

CREATE TRIGGER t_stats_edit AFTER UPDATE ON stats FOR EACH ROW EXECUTE PROCEDURE stat_archiwe();


--
-- Name: passwords_arch_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY passwords_arch
    ADD CONSTRAINT passwords_arch_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: passwords_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY passwords
    ADD CONSTRAINT passwords_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: personal_datas_arch_personal_data_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY personal_datas_arch
    ADD CONSTRAINT personal_datas_arch_personal_data_id_fkey FOREIGN KEY (personal_data_id) REFERENCES personal_datas(id_personal_data);


--
-- Name: personal_datas_arch_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY personal_datas_arch
    ADD CONSTRAINT personal_datas_arch_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: personal_datas_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY personal_datas
    ADD CONSTRAINT personal_datas_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: post_comments_edit_comment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments_edit
    ADD CONSTRAINT post_comments_edit_comment_id_fkey FOREIGN KEY (comment_id) REFERENCES post_comments(id_comment);


--
-- Name: post_comments_edit_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments_edit
    ADD CONSTRAINT post_comments_edit_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id_post);


--
-- Name: post_comments_edit_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments_edit
    ADD CONSTRAINT post_comments_edit_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: post_comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments
    ADD CONSTRAINT post_comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id_post);


--
-- Name: post_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY post_comments
    ADD CONSTRAINT post_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: posts_edit_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY posts_edit
    ADD CONSTRAINT posts_edit_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id_post);


--
-- Name: posts_edit_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY posts_edit
    ADD CONSTRAINT posts_edit_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: posts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: stats_arch_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats_arch
    ADD CONSTRAINT stats_arch_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id_post);


--
-- Name: stats_arch_stat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats_arch
    ADD CONSTRAINT stats_arch_stat_id_fkey FOREIGN KEY (stat_id) REFERENCES stats(id_stat);


--
-- Name: stats_arch_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats_arch
    ADD CONSTRAINT stats_arch_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: stats_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_post_id_fkey FOREIGN KEY (post_id) REFERENCES posts(id_post);


--
-- Name: stats_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY stats
    ADD CONSTRAINT stats_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id_user);


--
-- Name: users_account_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: adam
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_account_type_fkey FOREIGN KEY (account_type) REFERENCES account_types(id_account_type);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

