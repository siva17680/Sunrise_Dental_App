package com.sunrise.factory;

import com.sunrise.model.User;

/**
 * Factory class to create User objects based on role.
 */
public class UserFactory {

    public static User createUser(String role) {
        User user = new User();
        user.setRole(role.toUpperCase());
        return user;
    }
}
