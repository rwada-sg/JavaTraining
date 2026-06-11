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