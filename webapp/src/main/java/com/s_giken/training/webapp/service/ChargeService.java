package com.s_giken.training.webapp.service;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.s_giken.training.webapp.exception.AttributeErrorException;
import com.s_giken.training.webapp.model.entity.Charge;
import com.s_giken.training.webapp.model.entity.ChargeSearchCondition;
import com.s_giken.training.webapp.repository.IChargeRepository;

@Service
public class ChargeService implements IChargeService {

    private final IChargeRepository chargeRepository;

    private void validateDateRange(Charge charge) {

        if (charge.getEndDate() != null && charge.getStartDate().isAfter(charge.getEndDate())) {
            throw new AttributeErrorException("error.date.range");
        }
    }

    public ChargeService(IChargeRepository chargeRepository) {
        this.chargeRepository = chargeRepository;
    }

    /**
     * 加入者を1件取得する
     * 
     * @param id 加入者ID
     * @return 加入者IDに一致した加入者情報
     */
    @Override
    public Optional<Charge> findById(Long id) {

        return chargeRepository.findById(id);
    }

    /**
     * 加入者を条件検索する
     * 
     * @param chargeSearchCondition 加入者検索条件
     * @return 条件に一致した加入者情報
     */
    @Override
    public List<Charge> findByConditions(ChargeSearchCondition chargeSearchCondition) {

        return chargeRepository.findByChargeNameLike(chargeSearchCondition.getChargeName());
    }

    /**
     * 加入者を登録する
     *
     * @param charge 登録する加入者情報。 memberIdが Null であること。
     */
    @Override
    public void add(Charge charge) {

        validateDateRange(charge);
        if (charge.getId() != null) {
            throw new AttributeErrorException("加入者IDが指定されていると登録できません。");
        }

        chargeRepository.add(charge);
    }

    /**
     * 加入者情報を更新する
     * 
     * @param charge 更新する加入者情報。memberId が NULL でないこと
     */
    @Override
    public void update(Charge charge) {

        validateDateRange(charge);
        if (charge.getId() == null) {
            throw new AttributeErrorException("加入者IDが指定されていません。");
        }

        chargeRepository.update(charge);
    }

    /**
     * 加入者を削除する
     * 
     * @param id 加入者情報のID
     */
    @Override
    public void deleteById(Long id) {

        chargeRepository.deleteById(id);
    }

}
