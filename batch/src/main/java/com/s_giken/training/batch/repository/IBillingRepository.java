package com.s_giken.training.batch.repository;

import java.time.LocalDate;

public interface IBillingRepository {

    Integer checkBillingStatus(LocalDate targetMonth);

    int deleteBillingDetailData(LocalDate targetMonth);

    int deleteBillingData(LocalDate targetMonth);

    int deleteBillingStatus(LocalDate targetMonth);

    int insertBillingStatus(LocalDate targetMonth);

    int insertBillingData(LocalDate targetMonth, LocalDate lastDay);

    int insertBillingDetailData(LocalDate targetMonth, LocalDate lastDay);

}
