package com.techskillmatrix.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.techskillmatrix.db.DatabaseConnection;
import com.techskillmatrix.db.ResultsService;

@WebServlet("/submit-test")
public class SubmitTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 🔐 Check login session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("index.jsp?sessionExpired=true");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String category = normalize(req.getParameter("category"));
        String column = resolveColumn(category);

        // 📌 Read submitted question IDs
        List<Integer> questionIds = extractIds(req.getParameterValues("questionIds"));
        if (questionIds.isEmpty()) {
            resp.sendRedirect("dashboard.jsp?error=noQuestionsSubmitted");
            return;
        }

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // GET correct answers from DB
            Map<Integer, String> answerKey = getCorrectAnswers(conn, questionIds);

            // Evaluate score
            int total = answerKey.size();
            int correct = calculateCorrect(req, answerKey);
            int score = total == 0 ? 0 : (correct * 100 / total);

            // Update DB results
            ResultsService.ensureResultsRow(conn, userId);
            ResultsService.updateCategoryScore(conn, userId, column, score);

            int[] allScores = ResultsService.fetchScores(conn, userId);
            String recommendation = generateCareer(allScores);
            ResultsService.updateRecommendation(conn, userId, recommendation);

            conn.commit();

            // Redirect to result.jsp ✔ (NOT BACK to test.jsp)
            req.setAttribute("category", capitalize(category));
            req.setAttribute("score", score);
            req.setAttribute("recommendation", recommendation);
            req.getRequestDispatcher("result.jsp").forward(req, resp);

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            req.setAttribute("error", "Error while submitting: " + e.getMessage());
            req.getRequestDispatcher("dashboard.jsp").forward(req, resp); // SAFE fallback page
        } finally {
            DatabaseConnection.close(conn);
        }
    }

    // ----------------------- Utility Methods -----------------------

    private List<Integer> extractIds(String[] raw) {
        List<Integer> list = new ArrayList<>();
        if (raw != null) {
            for (String id : raw) {
                try { list.add(Integer.parseInt(id)); } catch (Exception ignore) {}
            }
        }
        return list;
    }

    private Map<Integer,String> getCorrectAnswers(Connection conn, List<Integer> ids) throws SQLException {
        Map<Integer,String> map = new HashMap<>();
        if (ids.isEmpty()) return map;

        String list = ids.toString().replace("[","").replace("]","");
        PreparedStatement ps = conn.prepareStatement(
                "SELECT id, correct_option FROM questions WHERE id IN (" + list + ")"
        );

        ResultSet rs = ps.executeQuery();
        while (rs.next())
            map.put(rs.getInt("id"), rs.getString("correct_option"));

        return map;
    }

    private int calculateCorrect(HttpServletRequest req, Map<Integer,String> key) {
        int correct = 0;
        for (int id : key.keySet()) {
            String ans = req.getParameter("q_" + id);
            if (ans != null && ans.equalsIgnoreCase(key.get(id)))
                correct++;
        }
        return correct;
    }

    private String generateCareer(int[] s) {
        int max = Math.max(Math.max(s[0], s[1]), Math.max(s[2], s[3]));
        if (max == 0) return "Take more tests for better evaluation.";

        if (s[2] == max) return "Software Developer / Backend Engineer";
        if (s[1] == max) return "Data Analyst / Logical Problem Solving Roles";
        if (s[0] == max) return "Business Analyst / Quantitative Roles";
        return "Communication / HR / Client Management Roles";
    }

    private String normalize(String s){
        return (s == null) ? "aptitude" : s.toLowerCase().trim();
    }

    private String capitalize(String c){
        return c.substring(0,1).toUpperCase() + c.substring(1);
    }

    // ⭐ FINAL CORRECT version — only ONE method
    private String resolveColumn(String c) {
        return c.equals("logic") ? "logic" :
               (c.equals("tech") || c.equals("technical")) ? "tech" :
               c.equals("english") ? "english" :
               "aptitude";
    }
}
