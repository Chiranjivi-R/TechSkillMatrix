package com.techskillmatrix.db;

import java.sql.Connection;

public class DBTest {
    public static void main(String[] args) {
        try {
            Connection conn = DatabaseConnection.getConnection();
            if (conn != null) {
                System.out.println("✔✔ Railway DB Connected Successfully!");
                conn.close();
            } else {
                System.out.println("❌ Connection returned NULL.");
            }
        } catch (Exception e) {
            System.out.println("❌ DB ERROR: " + e.getMessage());
        }
    }
}
