-- 今は、JPA(Hibername)のDDL自動生成および自動適用機能を利用。
-- 以下の記事も参照
-- https://spring.pleiades.io/spring-boot/docs/current/reference/html/howto.html#howto.data-initialization.using-basic-sql-scripts

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
