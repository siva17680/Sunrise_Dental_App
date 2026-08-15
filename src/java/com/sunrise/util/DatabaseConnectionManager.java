package com.sunrise.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Singleton class to manage database connections.
 */
public class DatabaseConnectionManager {

    private static DatabaseConnectionManager instance;
    private Connection connection;

    private static final String URL = "jdbc:mysql://localhost:3306/sunrise_dental";
    private static final String USER = "root"; // Update if necessary
    private static final String PASSWORD = ""; // Update if necessary

    private DatabaseConnectionManager() {
        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
            throw new RuntimeException("DB Connection Failed: " + ex.getMessage(), ex);
        }
    }

    public static synchronized DatabaseConnectionManager getInstance() {
        if (instance == null) {
            instance = new DatabaseConnectionManager();
        } else {
            try {
                if (instance.getConnection().isClosed()) {
                    instance = new DatabaseConnectionManager();
                }
            } catch (SQLException ex) {
                Logger.getLogger(DatabaseConnectionManager.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }
}
