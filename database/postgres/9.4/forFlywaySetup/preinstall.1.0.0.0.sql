DROP DATABASE IF EXISTS pong_matcher_spring_development;
DROP USER IF EXISTS springpong;

CREATE ROLE springpong PASSWORD 'springpong' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
CREATE DATABASE pong_matcher_spring_development WITH OWNER = springpong ENCODING = 'UTF8';

\c pong_matcher_spring_development;

GRANT ALL ON DATABASE pong_matcher_spring_development TO springpong;
