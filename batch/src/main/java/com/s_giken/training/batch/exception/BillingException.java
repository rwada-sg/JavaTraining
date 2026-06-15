package com.s_giken.training.batch.exception;

import org.springframework.dao.DataAccessException;

public class BillingException extends DataAccessException {

    public BillingException(String msg, Throwable cause) {
        super(msg, cause);
    }
}
