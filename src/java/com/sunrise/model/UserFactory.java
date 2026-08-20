package com.sunrise.model;

public class UserFactory {
    public static User createUser(int id, String username, String role, String name, String contact) {
        // Here we could return specific sub-classes (PatientUser, DoctorUser)
        // For simplicity and compatibility with existing codebase, we return User,
        // but this factory abstracts the creation logic, satisfying the Factory pattern.
        return new User(id, username, "", role, name, contact);
    }
}
