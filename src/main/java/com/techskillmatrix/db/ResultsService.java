package com.techskillmatrix.db;

import java.sql.*;
import com.techskillmatrix.model.UserResults;

/**
 * Handles all operations related to student assessment results.
 * (CRUD for aptitude, logic, tech, english & career recommendation)
 */
public final class ResultsService {

    private ResultsService() {} // Prevent instantiation (Utility class)

    /** Creates a row for student only if not exists */
    public static void ensureResultsRow(Connection conn, int userId) throws SQLException {
        String check = "SELECT 1 FROM results WHERE student_id = ? LIMIT 1";
        try (PreparedStatement ps = conn.prepareStatement(check)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                try (PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO results (student_id, aptitude, logic, tech, english, recommended_career) " +
                    "VALUES (?, 0, 0, 0, 0, NULL)"
                )) {
                    insert.setInt(1, userId);
                    insert.executeUpdate();
                    System.out.println("📌 New Results Row Created For User: " + userId);
                }
            }
        }
    }

    /** Updates the score of a specific category */
    public static void updateCategoryScore(Connection conn, int userId, String subject, int score)
            throws SQLException {

        // Validate column to avoid SQL injection
        if (!subject.matches("aptitude|logic|tech|english")) {
            throw new SQLException("❌ Invalid Score Column: " + subject);
        }

        String sql = "UPDATE results SET " + subject + " = ? WHERE student_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, score);
            ps.setInt(2, userId);
            ps.executeUpdate();
            System.out.println("✔ Score Updated → " + subject + " = " + score);
        }
    }

    /** Fetches the four category scores */
    public static int[] fetchScores(Connection conn, int userId) throws SQLException {
        int[] score = new int[4];
        try (PreparedStatement ps = conn.prepareStatement(
            "SELECT aptitude, logic, tech, english FROM results WHERE student_id = ?")) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                score[0] = rs.getInt(1);
                score[1] = rs.getInt(2);
                score[2] = rs.getInt(3);
                score[3] = rs.getInt(4);
            }
        }
        return score;
    }

    /** Stores recommended career in DB */
    public static void updateRecommendation(Connection conn, int userId, String rec) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE results SET recommended_career = ? WHERE student_id = ?")) {
            ps.setString(1, rec);
            ps.setInt(2, userId);
            ps.executeUpdate();
            System.out.println("⭐ Career Updated: " + rec);
        }
    }

    /** Fetches user report with recommendation */
    public static UserResults fetchUserResults(int userId)
            throws SQLException, ClassNotFoundException {

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT aptitude, logic, tech, english, recommended_career " +
                 "FROM results WHERE student_id = ?")) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return UserResults.builder()
                    .hasData(true)
                    .aptitude(rs.getInt(1))
                    .logic(rs.getInt(2))
                    .tech(rs.getInt(3))
                    .english(rs.getInt(4))
                    .recommendation(rs.getString(5))
                    .build();
            }
        }

        return UserResults.builder().hasData(false).build();
    }
}
