package com.s_giken.training.webapp.repository;

import java.sql.Types;
import java.util.List;
import java.util.Optional;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.s_giken.training.webapp.model.entity.Charge;

@Repository
public class ChargeRepository implements IChargeRepository {

    private final JdbcTemplate jdbcTemplate;
    private final RowMapper<Charge> rowMapper;

    public ChargeRepository(JdbcTemplate jdbcTemplate, RowMapper<Charge> rowMapper) {
        this.jdbcTemplate = jdbcTemplate;
        this.rowMapper = rowMapper;
    }

    /**
     * 指定した加入者IDの加入者情報を取得する。
     * 
     * @param id 加入者ID
     * @return Optional型の Chargeオブジェクト
     */
    @Override
    public Optional<Charge> findById(Long id) {

        String sql = "SELECT * FROM t_charge WHERE charge_id = ?";
        Object[] args = { id };
        int[] argTypes = { Types.BIGINT };

        Charge charge;
        try {
            charge = jdbcTemplate.queryForObject(sql, args, argTypes, rowMapper);
        } catch (EmptyResultDataAccessException e) {
            charge = null;
        }

        return Optional.ofNullable(charge);
    }

    /**
     * 料金名の一部にマッチする加入者情報リストを取得する。
     * 
     * @param chargeName 検索したい料金名の一部
     * @return Chargeオブジェクトの List
     */
    @Override
    public List<Charge> findByChargeNameLike(String chargeName) {

        if (chargeName == null) {
            throw new IllegalStateException("chargeName is null");
        }

        String sql = "SELECT * FROM t_charge WHERE name LIKE ?";
        Object[] args = { "%" + chargeName + "%" };
        int[] argTypes = { Types.VARCHAR };

        List<Charge> result = jdbcTemplate.query(sql, args, argTypes, rowMapper);

        return result;
    }

    /**
     * 加入者情報をデータベースへ登録する。
     * 
     * @param charge 追加するChargeオブジェクト。 idプロパティの値は null としなくてはならない。
     * @return 処理した件数
     */
    @Override
    public int add(Charge charge) {

        Long id = charge.getId();
        if (id == null) {
            id = jdbcTemplate.queryForObject("SELECT nextval('t_charge_seq')", Long.class);
            charge.setId(id);
        }

        String sql = """
                INSERT INTO t_charge (
                    charge_id,
                    name,
                    amount,
                    start_date,
                    end_date,
                    created_at,
                    modified_at)
                VALUES (
                    ?,
                    ?,
                    ?,
                    ?,
                    ?,
                    CURRENT_TIMESTAMP,
                    CURRENT_TIMESTAMP
                )
            """;

        int processed_count = jdbcTemplate
                .update(sql, id, charge.getChargeName(), charge.getMonthlyCharge(), charge.getStartDate(),
                        charge.getEndDate());

        return processed_count;
    }

    /**
     * データベースの加入者情報を更新する。
     * 
     * @param charge 更新するChargeオブジェクト。 idプロパティには値が設定されている必要がある。
     * @return 処理した件数
     */
    @Override
    public int update(Charge charge) {

        String sql = """
                UPDATE t_charge
                SET name = ?,
                    amount = ?,
                    start_date = ?,
                    end_date = ?,
                    modified_at = CURRENT_TIMESTAMP
                WHERE charge_id = ?
            """;

        int processed_count = jdbcTemplate
                .update(sql, charge.getChargeName(), charge.getMonthlyCharge(), charge.getStartDate(),
                        charge.getEndDate(), charge.getId());

        return processed_count;
    }

    /**
     * データベースから指定した加入者IDの加入者情報を削除する。
     * 
     * @param id 加入者ID
     * @return 処理した件数
     */
    @Override
    public int deleteById(Long id) {

        String sql = "DELETE FROM t_charge WHERE charge_id = ?";

        int processed_count = jdbcTemplate.update(sql, id);

        return processed_count;
    }

}
