package com.s_giken.training.batch.repository;

import java.sql.Types;
import java.time.LocalDate;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class BillingRepository implements IBillingRepository {

    private final JdbcTemplate jdbcTemplate;

    public BillingRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public Integer checkBillingStatus(LocalDate targetMonth) {

        String sql = """
            SELECT
                COUNT(*)
            FROM
                t_billing_status
            WHERE
                billing_ym = ? AND is_commit = TRUE
            """;
        Object[] queryArgs = { targetMonth };
        int[] argTypes = { Types.DATE };

        return jdbcTemplate.queryForObject(sql, queryArgs, argTypes, Integer.class);
    }

    @Override
    public int deleteBillingDetailData(LocalDate targetMonth) {

        return jdbcTemplate.update("DELETE FROM t_billing_detail_data WHERE billing_ym = ?", targetMonth);
    }

    @Override
    public int deleteBillingData(LocalDate targetMonth) {

        return jdbcTemplate.update("DELETE FROM t_billing_data WHERE billing_ym = ?", targetMonth);
    }

    @Override
    public int deleteBillingStatus(LocalDate targetMonth) {

        return jdbcTemplate.update("DELETE FROM t_billing_status WHERE billing_ym = ", targetMonth);
    }

    @Override
    public int insertBillingStatus(LocalDate targetMonth) {

        return jdbcTemplate
                .update("INSERT INTO t_billing_status (billing_ym, is_commit) VALUES (?, ?)", targetMonth, false);
    }

    @Override
    public int insertBillingData(LocalDate targetMonth, LocalDate lastDay) {

        String sql = """
            INSERT INTO t_billing_data
                (billing_ym, member_id, mail, name, address, start_date, end_date, payment_method, amount, tax_ratio, total)
            SELECT
                billing_ym,
                member_id,
                mail,
                name,
                address,
                start_date,
                end_date,
                payment_method,
                calc_amount amount,
                calc_tax_ratio tax_ratio,
                FLOOR(calc_amount * (1 + calc_tax_ratio)) total
            FROM (
                SELECT
                    ? billing_ym,
                    member_id,
                    mail,
                    name,
                    address,
                    start_date,
                    end_date,
                    payment_method,
                    (SELECT
                         COALESCE(SUM(amount), 0)
                     FROM
                         t_charge
                     WHERE
                         start_date <= ? AND (end_date IS NULL OR end_date >= ?)) calc_amount,
                    0.1 calc_tax_ratio
                FROM
                    t_member
                WHERE
                    start_date <= ? AND (end_date IS NULL OR end_date >= ?)
            ) sub_t_member;
            """;

        return jdbcTemplate.update(sql, targetMonth, lastDay, targetMonth, lastDay, targetMonth);
    }

    @Override
    public int insertBillingDetailData(LocalDate targetMonth, LocalDate lastDay) {

        String sql = """
            INSERT INTO t_billing_detail_data
                (billing_ym, member_id, charge_id, name, amount, start_date, end_date)
            SELECT
                ? billing_ym,
                mt.member_id,
                ct.charge_id,
                ct.name,
                ct.amount,
                ct.start_date,
                ct.end_date
            FROM
                t_member mt,
                t_charge ct
            WHERE
                mt.start_date <= ? AND (mt.end_date IS NULL OR mt.end_date >= ?) AND
                ct.start_date <= ? AND (ct.end_date IS NULL OR ct.end_date >= ?)
            """;

        return jdbcTemplate.update(sql, targetMonth, lastDay, targetMonth, lastDay, targetMonth);
    }

}
