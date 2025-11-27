package com.techskillmatrix.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.techskillmatrix.model.UserResults;

/**
 * Central place for reading and mutating assessment scores.
 */
public final class ResultsService {

    private ResultsService() {
        // utility
    }

    public static void ensureResultsRow(Connection conn, int userId) throws SQLException {
        try (PreparedStatement check = conn.prepareStatement(
                "SELECT id FROM results WHERE student_id = ?")) {
            check.setInt(1, userId);
            try (ResultSet rs = check.executeQuery()) {
                if (rs.next()) {
                    return;
                }
            }
        }

        try (PreparedStatement insert = conn.prepareStatement(
                "INSERT INTO results (student_id, aptitude, logic, tech, english, recommended_career) "
                        + "VALUES (?, 0, 0, 0, 0, NULL)")) {
            insert.setInt(1, userId);
            insert.executeUpdate();
        }
    }

    public static void updateCategoryScore(Connection conn, int userId, String columnName, int score)
            throws SQLException {
        String sql = "UPDATE results SET " + columnName + " = ? WHERE student_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, score);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    public static int[] fetchScores(Connection conn, int userId) throws SQLException {
        int[] scores = new int[] {0, 0, 0, 0};
        try (PreparedStatement stmt = conn.prepareStatement(
                "SELECT aptitude, logic, tech, english FROM results WHERE student_id = ?")) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    scores[0] = rs.getInt("aptitude");
                    scores[1] = rs.getInt("logic");
                    scores[2] = rs.getInt("tech");
                    scores[3] = rs.getInt("english");
                }
            }
        }
        return scores;
    }

    public static void updateRecommendation(Connection conn, int userId, String recommendation)
            throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "UPDATE results SET recommended_career = ? WHERE student_id = ?")) {
            if (recommendation == null) {
                stmt.setNull(1, java.sql.Types.VARCHAR);
            } else {
                stmt.setString(1, recommendation);
            }
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    public static UserResults fetchUserResults(int userId) throws SQLException, ClassNotFoundException {
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                     "SELECT aptitude, logic, tech, english, recommended_career "
                             + "FROM results WHERE student_id = ?")) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return UserResults.builder()
                            .hasData(true)
                            .aptitude(rs.getInt("aptitude"))
                            .logic(rs.getInt("logic"))
                            .tech(rs.getInt("tech"))
                            .english(rs.getInt("english"))
                            .recommendation(rs.getString("recommended_career"))
                            .build();
                }
            }
        }

        return UserResults.builder()
                .hasData(false)
                .aptitude(0)
                .logic(0)
                .tech(0)
                .english(0)
                .recommendation(null)
                .build();
    }
}


