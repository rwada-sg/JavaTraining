package com.s_giken.training.webapp.repository;

import org.springframework.stereotype.Repository;

import com.s_giken.training.webapp.model.entity.User;

@Repository
public interface IUserRepository {
    public User findByUsername(String userName);
}
