package com.s_giken.training.webapp.repository;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.s_giken.training.webapp.model.entity.User;

@Repository
public class UserRepository implements IUserRepository {
    private final JdbcTemplate jdbcTemplaete;
    private final RowMapper<User> userRowMapper;

    public UserRepository(JdbcTemplate jdbcTemplate, RowMapper<User> userRowMapper) {
        this.jdbcTemplaete = jdbcTemplate;
        this.userRowMapper = userRowMapper;
    }

    public User findByUsername(String userName) {
        String sql = "SELECT * FROM T_USER WHERE userName = ?";
        User user = null;
        try {
            user = jdbcTemplaete.queryForObject(sql, userRowMapper, userName);
        } catch(EmptyResultDataAccessException e) {
            user = null;
        }
        return user;
    }
}
