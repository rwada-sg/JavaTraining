#!/bin/bash

psql -h database -U trainingapp -W trainingapp <<'__EOS__'

/*
CREATE SEQUENCE IF NOT EXISTS t_member_seq AS BIGINT START WITH 1 INCREMENT BY 1 NO CYCLE;

CREATE SEQUENCE IF NOT EXISTS t_charge_seq AS BIGINT START WITH 1 INCREMENT BY 1 NO CYCLE;

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

CREATE TABLE IF NOT EXISTS t_charge (
    charge_id       BIGINT NOT NULL,
    name            VARCHAR(127) NOT NULL,
    amount          NUMERIC(9,0) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (charge_id)
);

CREATE TABLE IF NOT EXISTS t_billing_status (
    billing_ym      DATE PRIMARY KEY,
    is_commit       BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS t_billing_data (
    billing_ym      DATE NOT NULL,
    member_id       BIGINT NOT NULL,
    mail            VARCHAR(255) NOT NULL,
    name            VARCHAR(31) NOT NULL,
    address         VARCHAR(127) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    payment_method  INTEGER NOT NULL,
    amount          NUMERIC(10,0) NOT NULL,
    tax_ratio       NUMERIC(5,2) NOT NULL,
    total           NUMERIC(10,0) NOT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (billing_ym, member_id),
    FOREIGN KEY (billing_ym) 
        REFERENCES t_billing_status(billing_ym)
);

CREATE TABLE IF NOT EXISTS t_billing_detail_data (
    billing_ym      DATE NOT NULL,
    member_id       BIGINT NOT NULL,
    charge_id       BIGINT NOT NULL,
    name            VARCHAR(127) NOT NULL,
    amount          NUMERIC(9,0) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (billing_ym, member_id, charge_id),
    FOREIGN KEY (billing_ym, member_id) 
        REFERENCES t_billing_data(billing_ym, member_id)
);

BEGIN;

SELECT setval('t_member_seq', 1, false);
ALTER SEQUENCE t_charge_seq RESTART WITH 1;


DROP TABLE IF EXISTS t_user;
DROP TABLE IF EXISTS t_member;
DROP TABLE IF EXISTS t_charge;
DROP TABLE IF EXISTS t_billing_detail_data;
DROP TABLE IF EXISTS t_billing_data;
DROP TABLE IF EXISTS t_billing_status;

DROP SEQUENCE IF EXISTS t_member_seq;
DROP SEQUENCE IF EXISTS t_charge_seq;


INSERT INTO t_user VALUES ('user', '$argon2id$v=19$m=14,t=2,p=1$eVczdXhrMWlDZERWUnZWdA$HjSDtkidFBp49L0k8ZlvtTVcKkC//uOkIjDRiYbGIWg', true);

INSERT INTO t_member VALUES (nextval('t_member_seq'), 'yamada@example.com', '山田　太郎', '東京都千代田区1-1-1', '2026-01-01', NULL, 1, NOW(), NOW());

INSERT INTO t_charge VALUES (nextval('t_charge_seq'), '毎日銀行', 30000, '2026-01-01', NULL, NOW(), NOW());
INSERT INTO t_charge VALUES (nextval('t_charge_seq'), '水道料金', 10000, '2022-04-01', NULL, NOW(), NOW());
INSERT INTO t_charge VALUES (nextval('t_charge_seq'), '電気料金', 5000,  '2022-04-01', NULL, NOW(), NOW());
INSERT INTO t_charge VALUES (nextval('t_charge_seq'), 'ガス料金', 3000,  '2023-07-07', '2025-10-08', NOW(), NOW());

COMMIT;
*/

/**********************************************************************************************************************************/

DROP TABLE IF EXISTS t_user;
DROP TABLE IF EXISTS t_member;
DROP TABLE IF EXISTS t_charge;
DROP TABLE IF EXISTS t_delete_preventer;        -- DELETE文エラー発生用テーブル
DROP TABLE IF EXISTS t_billing_detail_data;
DROP TABLE IF EXISTS t_billing_data;
DROP TABLE IF EXISTS t_billing_status;
DROP TABLE IF EXISTS t_insert_preventer;        -- INSERT文エラー発生用テーブル

DROP SEQUENCE IF EXISTS t_member_seq;
DROP SEQUENCE IF EXISTS t_charge_seq;


CREATE TABLE IF NOT EXISTS t_user (
    username        VARCHAR(255)  NOT NULL,
    password        VARCHAR(255)  NOT NULL,
    enabled         BOOLEAN       NOT NULL,
    PRIMARY KEY (userName)
);

-- 加入者情報
CREATE SEQUENCE IF NOT EXISTS t_member_seq AS BIGINT START WITH 1 INCREMENT BY 1 NO CYCLE CACHE 1; 

CREATE TABLE IF NOT EXISTS t_member (
    member_id       BIGINT, 
    mail            VARCHAR(255) NOT NULL,
    name            VARCHAR(31) NOT NULL,
    address         VARCHAR(127) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    payment_method  INTEGER NOT NULL,   
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (member_id)
);

-- 料金情報
CREATE SEQUENCE IF NOT EXISTS t_charge_seq AS BIGINT START WITH 1 INCREMENT BY 1 NO CYCLE CACHE 1; 

CREATE TABLE IF NOT EXISTS t_charge (
    charge_id       BIGINT, 
    name            VARCHAR(127) NOT NULL,
    amount          NUMERIC(9,0) NOT nULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (charge_id)
);

-- 請求データ情報
CREATE TABLE IF NOT EXISTS t_billing_status (
    billing_ym      DATE PRIMARY KEY,
    is_commit       BOOLEAN NOT NULL DEFAULT FALSE
);

/*
-- 請求データ情報（SELECT文エラー発生用テーブル）
CREATE TABLE IF NOT EXISTS t_billing_status (
    billing_ym      DATE PRIMARY KEY
);
*/

/*
-- ダミーテーブル（INSERT文エラー発生用テーブル）
CREATE TABLE IF NOT EXISTS t_insert_preventer (
    billing_ym      DATE,
    member_id       BIGINT NOT NULL,
    is_commit       BOOLEAN NOT NULL DEFAULT FALSE,
    --PRIMARY KEY (billing_ym)
    PRIMARY KEY (billing_ym, member_id)
);
*/

/*
-- 請求データ情報（INSERT文エラー発生用テーブル）
CREATE TABLE IF NOT EXISTS t_billing_status (
    billing_ym      DATE PRIMARY KEY,
    is_commit       BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (billing_ym)
        REFERENCES t_insert_preventer(billing_ym)
);
*/

-- 請求データ
CREATE TABLE IF NOT EXISTS t_billing_data (
    billing_ym      DATE NOT NULL,
    member_id       BIGINT NOT NULL,
    mail            VARCHAR(255) NOT nULL,
    name            VARCHAR(31) NOT NULL,
    address         VARCHAR(127) NOT nULL,
    start_date      DATE NOT NULL,
    end_date        DATE,    
    payment_method  INTEGER NOT NULL,
    amount          NUMERIC(10,0) NOT NULL,
    tax_ratio       NUMERIC(5,2) NOT NULL,
    total           NUMERIC(10,0) NOT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (billing_ym, member_id),
    FOREIGN KEY (billing_ym) 
        REFERENCES t_billing_status(billing_ym)
);


/*
-- 請求データ（INSERT文エラー発生用テーブル）
CREATE TABLE IF NOT EXISTS t_billing_data (
    billing_ym      DATE NOT NULL,
    member_id       BIGINT NOT NULL,
    mail            VARCHAR(255) NOT NULL,
    name            VARCHAR(31) NOT NULL,
    address         VARCHAR(127) NOT nULL,
    start_date      DATE NOT NULL,
    end_date        DATE,    
    payment_method  INTEGER NOT NULL,
    amount          NUMERIC(10,0) NOT NULL,
    tax_ratio       NUMERIC(5,2) NOT NULL,
    total           NUMERIC(10,0) NOT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (billing_ym, member_id),
    FOREIGN KEY (billing_ym) 
        REFERENCES t_insert_preventer(billing_ym)
);
*/

-- 請求詳細データ
CREATE TABLE IF NOT EXISTS t_billing_detail_data (
    billing_ym      DATE NOT NULL,
    member_id       BIGINT NOT NULL,
    charge_id       BIGINT NOT NULL,
    name            VARCHAR(127) NOT NULL,
    amount          NUMERIC(9,0) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (billing_ym, member_id, charge_id),
    FOREIGN KEY (billing_ym, member_id) 
        REFERENCES t_billing_data(billing_ym, member_id)
);

/*
-- 請求詳細データ（INSERT文エラー発生用テーブル）
CREATE TABLE IF NOT EXISTS t_billing_detail_data (
    billing_ym      DATE NOT NULL,
    member_id       BIGINT NOT NULL,
    charge_id       BIGINT NOT NULL,
    name            VARCHAR(2) NOT NULL,
    amount          NUMERIC(9,0) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (billing_ym, member_id, charge_id),
    FOREIGN KEY (billing_ym, member_id) 
        REFERENCES t_insert_preventer(billing_ym, member_id)
);
*/

/*
-- ダミーテーブル（DELETE文エラー発生用テーブル）
CREATE TABLE IF NOT EXISTS t_delete_preventer (
    billing_ym      DATE,
    member_id       BIGINT NOT NULL,
    charge_id       BIGINT NOT NULL,

    PRIMARY KEY (billing_ym),
    FOREIGN KEY (billing_ym, member_id, charge_id)
        REFERENCES t_billing_detail_data(billing_ym, member_id, charge_id)
        --REFERENCES t_billing_data(billing_ym, member_id)
        --REFERENCES t_billing_status(billing_ym)
);
*/

BEGIN;

DELETE FROM t_user;
DELETE FROM t_member;
DELETE FROM t_charge;
--DELETE FROM t_delete_preventer;
DELETE FROM t_billing_detail_data;
DELETE FROM t_billing_data;
DELETE FROM t_billing_status;
--DELETE FROM t_insert_preventer;

SELECT setval('t_member_seq', 1, false);
SELECT setval('t_charge_seq', 1, false);


-- SELECT文true用データの挿入
--INSERT INTO t_billing_status (billing_ym, is_commit) VALUES ('2023-09-01', true) ON CONFLICT (billing_ym) DO NOTHING;


-- DELETE文エラー発生用データの挿入
--INSERT INTO t_billing_status (billing_ym, is_commit) VALUES ('2280-04-01', false) ON CONFLICT (billing_ym) DO NOTHING;
--INSERT INTO t_billing_data VALUES ('2280-04-01', 10000, 'sample@example.com', 'サンプル', 'サンプル100-100-100', '2000-04-01', NULL, '1', 10000, 0.1, 11000, NOW(), NOW()) ON CONFLICT (billing_ym, member_id) DO NOTHING;
--INSERT INTO t_billing_detail_data VALUES ('2280-04-01', 10000, 10000, 'サンプルサービス', 1111, '2000-04-01', NULL, NOW(), NOW()) ON CONFLICT (billing_ym, member_id, charge_id) DO NOTHING;

-- DELETE文エラー発生用データの挿入
--INSERT INTO t_delete_preventer (billing_ym, member_id, charge_id) VALUES ('2280-04-01', 10000, 10000) ON CONFLICT (billing_ym) DO NOTHING;


INSERT INTO t_user (username, password, enabled)
VALUES ('user', '$argon2id$v=19$m=14,t=2,p=1$eVczdXhrMWlDZERWUnZWdA$HjSDtkidFBp49L0k8ZlvtTVcKkC//uOkIjDRiYbGIWg', true)
ON CONFLICT (username)
DO NOTHING;

-- 加入者情報
INSERT INTO t_member (member_id, mail, name, address, start_date, end_date, payment_method, created_at, modified_at)
VALUES (nextval('t_member_seq'), 'yamada@example.com', '山田　太郎', '東京都千代田区1-1-1', '2022-04-01', '2023-09-22', 1, NOW(), NOW())
ON CONFLICT (member_id)
DO NOTHING;

INSERT INTO t_member (member_id, mail, name, address, start_date, end_date, payment_method, created_at, modified_at)
VALUES (nextval('t_member_seq'), 'yamada@example.com', '山田　花子', '東京都世田谷区2-2-2', '2023-09-01', NULL, 2, NOW(), NOW())
ON CONFLICT (member_id)
DO NOTHING;

INSERT INTO t_member (member_id, mail, name, address, start_date, end_date, payment_method, created_at, modified_at)
VALUES (nextval('t_member_seq'), 'sato@example.com', '佐藤　一郎', '東京都品川区3-3-3', '2023-09-30', '2023-10-01', 1, NOW(), NOW())
ON CONFLICT (member_id)
DO NOTHING;

INSERT INTO t_member (member_id, mail, name, address, start_date, end_date, payment_method, created_at, modified_at)
VALUES (nextval('t_member_seq'), 'suzuki@example.com', '鈴木　次郎', '東京都渋谷区4-4-4', '2023-10-01', NULL, 2, NOW(), NOW())
ON CONFLICT (member_id)
DO NOTHING;

-- 料金情報
INSERT INTO t_charge (charge_id, name, amount, start_date, end_date, created_at, modified_at)
VALUES (nextval('t_charge_seq'), '基本料金', 10000, '2022-01-01', NULL, NOW(), NOW())
ON CONFLICT (charge_id)
DO NOTHING;

INSERT INTO t_charge (charge_id, name, amount, start_date, end_date, created_at, modified_at)
VALUES (nextval('t_charge_seq'), '期間限定広告非表示オプション', 300, '2023-09-01', '2023-09-14', NOW(), NOW())
ON CONFLICT (charge_id)
DO NOTHING;

INSERT INTO t_charge (charge_id, name, amount, start_date, end_date, created_at, modified_at)
VALUES (nextval('t_charge_seq'), '期間限定見放題パック', 1500, '2023-09-30', '2024-08-31', NOW(), NOW())
ON CONFLICT (charge_id)
DO NOTHING;

INSERT INTO t_charge (charge_id, name, amount, start_date, end_date, created_at, modified_at)
VALUES (nextval('t_charge_seq'), 'プレミアム会員パス', 4000, '2023-10-01', NULL, NOW(), NOW())
ON CONFLICT (charge_id)
DO NOTHING;

COMMIT;
__EOS__