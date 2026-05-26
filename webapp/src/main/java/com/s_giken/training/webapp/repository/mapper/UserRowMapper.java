package com.s_giken.training.webapp.repository.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.s_giken.training.webapp.model.entity.User;

@Component
public class UserRowMapper implements RowMapper<User> {
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {
        User user = new User();
        user.setUserName(rs.getString("userName"));
        user.setPassword(rs.getString("password"));
        user.setIsEnabled(rs.getBoolean("enabled"));
        return user;
    }
}
