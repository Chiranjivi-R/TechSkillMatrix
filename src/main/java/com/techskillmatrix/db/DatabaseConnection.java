package com.techskillmatrix.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * 🔥 Railway MySQL – Stable DB Connector
 * Optimized for Production & Auto-Reconnect
 */
public class DatabaseConnection {

    // Railway Public URL (Use external if public access required)
    private static final String DB_URL =
            "jdbc:mysql://maglev.proxy.rlwy.net:46074/railway"
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&autoReconnect=true"
            + "&connectTimeout=8000"
            + "&socketTimeout=15000"
            + "&reconnectAtTxEnd=true";

    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "vGEcqAXgODeSJgLAVmsErGXPVdOnDMwp";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✔ JDBC Driver Loaded Successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ JDBC Driver Missing: " + e.getMessage());
        }
    }

    /** Returns new DB connection */
    public static Connection getConnection() {
        try {
            Connection con = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            System.out.println("✔ Railway Database Connected");
            return con;
        } catch (SQLException e) {
            System.err.println("\n❌ DB Connection Failed");
            System.err.println("Reason ➤ " + e.getMessage());
            System.err.println("⚠ Check → Host/Port/Password/Network/SSL settings\n");
            return null;
        }
    }

    /** Safe Close */
    public static void close(Connection con) {
        try {
            if (con != null && !con.isClosed()) {
                con.close();
                System.out.println("🔻 DB Connection Closed");
            }
        } catch (Exception e) {
            System.err.println("⚠ Close Error: " + e.getMessage());
        }
    }
}
