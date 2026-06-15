/*
DROP TABLE IF EXISTS t_user;
DROP TABLE IF EXISTS t_member;
DROP TABLE IF EXISTS t_charge;
DROP TABLE IF EXISTS t_billing_detail_data;
DROP TABLE IF EXISTS t_billing_data;
DROP TABLE IF EXISTS t_billing_status;

DROP SEQUENCE IF EXISTS t_member_seq;
DROP SEQUENCE IF EXISTS t_charge_seq;
*/

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

-- DROP TABLE IF EXISTS t_billing_detail_data;

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
-- 請求詳細データ
CREATE TABLE IF NOT EXISTS t_billing_detail_data (
    billing_ym      DATE NOT NULL,
    member_id       BIGINT NOT NULL,
    charge_id       BIGINT NOT NULL,
    name            VARCHAR(2) NOT NULL,                                /* 127 から 2 に変更 */
    amount          NUMERIC(9,0) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE,
    created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (billing_ym, member_id, charge_id),
    FOREIGN KEY (billing_ym, member_id) 
        REFERENCES t_billing_data(billing_ym, member_id)
);
*/