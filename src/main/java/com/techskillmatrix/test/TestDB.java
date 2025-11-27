package com.techskillmatrix.test;

import com.techskillmatrix.db.DatabaseConnection;

public class TestDB {
    public static void main(String[] args) {
        boolean status = DatabaseConnection.testConnection();
        if (status) {
            System.out.println("🔥 Database Connected Successfully");
        } else {
            System.out.println("❌ Connection Failed");
        }
    }
}