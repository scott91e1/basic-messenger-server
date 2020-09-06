--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.0

-- Started on 2020-09-06 15:41:34 BST

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
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3197 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 213 (class 1259 OID 16561)
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    server integer NOT NULL,
    "user" integer NOT NULL,
    content text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16559)
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.messages ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 205 (class 1259 OID 16495)
-- Name: password_reset_questions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_questions (
    id integer NOT NULL,
    question text NOT NULL
);


ALTER TABLE public.password_reset_questions OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16493)
-- Name: password_reset_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.password_reset_questions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.password_reset_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 203 (class 1259 OID 16410)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16536)
-- Name: server_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.server_users (
    id integer NOT NULL,
    "user" integer NOT NULL,
    server integer NOT NULL,
    role text NOT NULL
);


ALTER TABLE public.server_users OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16534)
-- Name: server_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.server_users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.server_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 209 (class 1259 OID 16526)
-- Name: servers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servers (
    id integer NOT NULL,
    name text NOT NULL,
    address text NOT NULL
);


ALTER TABLE public.servers OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 16524)
-- Name: servers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.servers ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.servers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 202 (class 1259 OID 16402)
-- Name: statuses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.statuses (
    id text NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.statuses OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 16505)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    status text NOT NULL,
    password_reset_question integer NOT NULL,
    password_reset_answer text NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16503)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3058 (class 2606 OID 16568)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- TOC entry 3050 (class 2606 OID 16502)
-- Name: password_reset_questions password_reset_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_questions
    ADD CONSTRAINT password_reset_questions_pkey PRIMARY KEY (id);


--
-- TOC entry 3056 (class 2606 OID 16543)
-- Name: server_users server_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_users
    ADD CONSTRAINT server_users_pkey PRIMARY KEY (id);


--
-- TOC entry 3054 (class 2606 OID 16533)
-- Name: servers servers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servers
    ADD CONSTRAINT servers_pkey PRIMARY KEY (id);


--
-- TOC entry 3048 (class 2606 OID 16417)
-- Name: roles user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);


--
-- TOC entry 3046 (class 2606 OID 16409)
-- Name: statuses user_status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.statuses
    ADD CONSTRAINT user_status_pkey PRIMARY KEY (id);


--
-- TOC entry 3052 (class 2606 OID 16512)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3060 (class 2606 OID 16518)
-- Name: users password_reset_question; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT password_reset_question FOREIGN KEY (password_reset_question) REFERENCES public.password_reset_questions(id);


--
-- TOC entry 3063 (class 2606 OID 16554)
-- Name: server_users role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_users
    ADD CONSTRAINT role FOREIGN KEY (role) REFERENCES public.roles(id);


--
-- TOC entry 3062 (class 2606 OID 16549)
-- Name: server_users server; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_users
    ADD CONSTRAINT server FOREIGN KEY (server) REFERENCES public.servers(id);


--
-- TOC entry 3064 (class 2606 OID 16569)
-- Name: messages server; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT server FOREIGN KEY (server) REFERENCES public.servers(id);


--
-- TOC entry 3059 (class 2606 OID 16513)
-- Name: users status; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT status FOREIGN KEY (status) REFERENCES public.statuses(id);


--
-- TOC entry 3061 (class 2606 OID 16544)
-- Name: server_users user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.server_users
    ADD CONSTRAINT "user" FOREIGN KEY ("user") REFERENCES public.users(id);


--
-- TOC entry 3065 (class 2606 OID 16574)
-- Name: messages user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT "user" FOREIGN KEY ("user") REFERENCES public.users(id);


-- Completed on 2020-09-06 15:41:35 BST

--
-- PostgreSQL database dump complete
--

