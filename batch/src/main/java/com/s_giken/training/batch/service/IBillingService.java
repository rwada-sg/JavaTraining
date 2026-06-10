package com.s_giken.training.batch.service;

import java.time.LocalDate;

public interface IBillingService {

    void processBilling(LocalDate targetMonth, LocalDate lastDay);

}
