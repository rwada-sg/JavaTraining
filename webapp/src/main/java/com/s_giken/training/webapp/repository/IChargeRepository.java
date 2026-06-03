package com.s_giken.training.webapp.repository;

import java.util.List;
import java.util.Optional;

import com.s_giken.training.webapp.model.entity.Charge;

public interface IChargeRepository {

    /**
     * 指定した加入者IDの加入者情報を取得する。
     * 
     * @param id 加入者ID
     * @return Optional型の Chargeオブジェクト
     */
    public Optional<Charge> findById(Long id);

    /**
     * 料金名の一部にマッチする加入者情報リストを取得する。
     * 
     * @param chargeName 検索したい料金名の一部
     * @return Chargeオブジェクトの List
     */
    public List<Charge> findByChargeNameLike(String chargeName);

    /**
     * 加入者情報をデータベースへ登録する。
     * 
     * @param charge 追加するChargeオブジェクト。 idプロパティの値は null としなくてはならない。
     * @return 処理した件数
     */
    public int add(Charge charge);

    /**
     * データベースの加入者情報を更新する。
     * 
     * @param charge 更新するChargeオブジェクト。 idプロパティには値が設定されている必要がある。
     * @return 処理した件数
     */
    public int update(Charge charge);

    /**
     * データベースから指定した加入者IDの加入者情報を削除する。
     * 
     * @param id 加入者ID
     * @return 処理した件数
     */
    public int deleteById(Long id);

}
