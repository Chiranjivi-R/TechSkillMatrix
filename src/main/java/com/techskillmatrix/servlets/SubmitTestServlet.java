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

        // 🔐 Session validation
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("index.jsp?sessionExpired=true");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String category = normalize(req.getParameter("category"));
        String column = resolveColumn(category);

        // 📌 Fetch submitted question ID list
        List<Integer> questionIds = extractIds(req.getParameterValues("questionIds"));
        if (questionIds.isEmpty()) {
            resp.sendRedirect("test.jsp?category=" + category + "&status=noQuestions");
            return;
        }

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // 📥 real answers from DB
            Map<Integer, String> answerKey = getCorrectAnswers(conn, questionIds);

            // 🧮 evaluate score
            int total = answerKey.size();
            int correct = calculateCorrect(req, answerKey);
            int score = (total == 0) ? 0 : (correct * 100 / total);

            // 💾 store in DB
            ResultsService.ensureResultsRow(conn, userId);
            ResultsService.updateCategoryScore(conn, userId, column, score);

            int[] scores = ResultsService.fetchScores(conn, userId);
            String recommendation = generateCareer(scores);
            ResultsService.updateRecommendation(conn, userId, recommendation);

            conn.commit();

            // ↪ Forward to result.jsp (not test.jsp anymore — FIXED)
            req.setAttribute("category", category.substring(0,1).toUpperCase()+category.substring(1));
            req.setAttribute("score", score);
            req.setAttribute("recommendation", recommendation);

            req.getRequestDispatcher("result.jsp").forward(req, resp);

        } catch (Exception ex) {
            try { if (conn!=null) conn.rollback(); } catch (Exception ignore) {}
            req.setAttribute("errorMessage", "Submission failed: " + ex.getMessage());
            req.getRequestDispatcher("dashboard.jsp").forward(req, resp); // FIX: no more returning to test.jsp

        } finally {
            DatabaseConnection.close(conn);
        }
    }

    // ------------------------------ Helper Methods ------------------------------

    private List<Integer> extractIds(String[] raw) {
        List<Integer> list = new ArrayList<>();
        if (raw != null) {
            for (String s : raw) {
                try { list.add(Integer.parseInt(s)); } catch (Exception ignore) {}
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
        int count = 0;
        for (int id : key.keySet()) {
            String ans = req.getParameter("q_" + id);
            if (ans != null && ans.equalsIgnoreCase(key.get(id))) count++;
        }
        return count;
    }

    private String generateCareer(int[] s) {
        int max = Math.max(Math.max(s[0],s[1]),Math.max(s[2],s[3]));
        if (max == 0) return "Take more tests for accurate prediction.";

        if (s[2]==max) return "Software Developer / Backend Engineer";
        if (s[1]==max) return "Data Analyst / Logical Computing Roles";
        if (s[0]==max) return "Business Analyst / Quantitative Roles";
        return "Communication / HR / Client Management Roles";
    }

    private String normalize(String s) {
        return (s==null)?"aptitude":s.trim().toLowerCase();
    }

    private String resolveColumn(String c) {
        if (c.equals("logic")) return "logic";
        if (c.equals("tech") || c.equals("technical")) return "tech";
        if (c.equals("english")) return "english";
        return "aptitude"; // default
    }
}
