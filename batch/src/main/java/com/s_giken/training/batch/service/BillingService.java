package com.s_giken.training.batch.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.s_giken.training.batch.repository.IBillingRepository;

@Service
public class BillingService implements IBillingService {

    private final Logger logger = LoggerFactory.getLogger(BillingService.class);
    private final IBillingRepository billingRepository;

    private static String phase = null;

    @Transactional
    private void executeBillingProcess(LocalDate targetMonth, LocalDate lastDay) {

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy年MM月");
        String formattedTargetMonth = targetMonth.format(formatter);

        logger.info("{}分の請求情報を確認しています。", formattedTargetMonth);

        Integer commitStatus = billingRepository.checkBillingStatus(targetMonth);
        if (commitStatus != 0) {
            logger.info("{}分の請求情報は確定済みです。", formattedTargetMonth);
        } else {
            phase = "請求明細データ情報の削除";
            billingRepository.deleteBillingDetailData(targetMonth);

            phase = "請求データ情報の削除";
            billingRepository.deleteBillingData(targetMonth);

            phase = "請求ステータス情報の削除";
            billingRepository.deleteBillingStatus(targetMonth);

            logger.info("データベースから{}分の未確定請求情報を削除しました。", formattedTargetMonth);

            logger.info("{}分の請求ステータス情報を追加しています。", formattedTargetMonth);
            phase = "請求ステータス情報の追加";
            int cntStatus = billingRepository.insertBillingStatus(targetMonth);
            logger.info("{}件追加しました。", cntStatus);

            logger.info("{}分の請求データ情報を追加しています。", formattedTargetMonth);
            phase = "請求データ情報の追加";
            int cntData = billingRepository.insertBillingData(targetMonth, lastDay);
            logger.info("{}件追加しました。", cntData);

            logger.info("{}分の請求明細データ情報を追加しています。", formattedTargetMonth);
            phase = "請求明細データ情報の追加";
            int cntDetailData = billingRepository.insertBillingDetailData(targetMonth, lastDay);
            logger.info("{}件追加しました。", cntDetailData);
        }
    }

    public BillingService(IBillingRepository billingRepository) {
        this.billingRepository = billingRepository;
    }

    @Override
    public void processBilling(LocalDate targetMonth, LocalDate lastDay) {

        try {
            executeBillingProcess(targetMonth, lastDay);
        } catch (DataAccessException e) {
            logger.error("{}中にエラーが発生しました。メッセージ：{}", phase, e.getMessage());

            throw e;
        }
    }

}
