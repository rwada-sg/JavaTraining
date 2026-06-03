package com.s_giken.training.webapp.service;

import java.util.List;
import java.util.Optional;

import com.s_giken.training.webapp.model.entity.Charge;
import com.s_giken.training.webapp.model.entity.ChargeSearchCondition;

public interface IChargeService {

    /**
     * 加入者を1件取得する
     * 
     * @param id 加入者ID
     * @return 加入者IDに一致した加入者情報
     */
    public Optional<Charge> findById(Long id);

    /**
     * 加入者を条件検索する
     * 
     * @param chargeSearchCondition 加入者検索条件
     * @return 条件に一致した加入者情報
     */
    public List<Charge> findByConditions(ChargeSearchCondition chargeSearchCondition);

    /**
     * 加入者を登録する
     *
     * @param charge 登録する加入者情報。 memberIdが Null であること。
     */
    public void add(Charge charge);

    /**
     * 加入者情報を更新する
     * 
     * @param charge 更新する加入者情報。memberId が NULL でないこと
     */
    public void update(Charge charge);

    /**
     * 加入者を削除する
     * 
     * @param id 加入者情報のID
     */
    public void deleteById(Long id);

}
