#!/bin/bash

psql -h database -U trainingapp -W trainingapp <<'__EOS__'
CREATE SEQUENCE IF NOT EXISTS t_member_seq AS BIGINT START WITH 1 INCREMENT BY 1 NO CYCLE; 

CREATE TABLE IF NOT EXISTS t_user (
    username        VARCHAR(255)  NOT NULL,
    password        VARCHAR(255)  NOT NULL,
    enabled         BOOLEAN       NOT NULL,
    PRIMARY KEY (userName)
);

CREATE TABLE IF NOT EXISTS t_member (
    member_id	    BIGINT NOT NULL,
    mail	        VARCHAR(255) NOT NULL,
    name	        VARCHAR(31) NOT NULL,
    address	        TEXT NOT NULL,
    start_date	    DATE NOT NULL,
    end_date	    DATE,
    payment_method	INT NOT NULL,
    created_at	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at	    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (member_id)
);

BEGIN;

DELETE FROM T_MEMBER;
DELETE FROM T_USER;

INSERT INTO T_USER VALUES ('user', '$argon2id$v=19$m=14,t=2,p=1$eVczdXhrMWlDZERWUnZWdA$HjSDtkidFBp49L0k8ZlvtTVcKkC//uOkIjDRiYbGIWg', true);

INSERT INTO T_MEMBER VALUES (nextval('t_member_seq'), 'yamada@example.com', '山田　太郎', '東京都千代田区1-1-1', '2026-01-01', NULL, 1, NOW(), NOW());

COMMIT;
__EOS__