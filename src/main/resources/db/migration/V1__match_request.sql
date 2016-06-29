CREATE SEQUENCE match_request_id_seq;

GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO springpong;

CREATE TABLE match_request (
  id BIGINT PRIMARY KEY DEFAULT nextval('match_request_id_seq'),
  uuid VARCHAR(255) NOT NULL,
  requester_id VARCHAR(255) NOT NULL,

  CONSTRAINT unique_uuid UNIQUE (uuid)
);
