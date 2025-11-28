package com.techskillmatrix.servlets;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.techskillmatrix.db.DatabaseConnection;
import com.techskillmatrix.db.ResultsService;

@WebServlet("/submit-test")   // final mapped URL
public class SubmitTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ------------------ SESSION CHECK ------------------
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("index.jsp?sessionExpired=true");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String category = normalize(req.getParameter("category"));
        String column = resolveColumn(category);

        // ------------------ FETCH QUESTION IDS ------------------
        List<Integer> questionIds = extractIds(req.getParameterValues("questionIds"));
        if (questionIds.isEmpty()) {
            resp.sendRedirect("test.jsp?category=" + category + "&status=noQuestions");
            return;
        }

        Connection conn = null;

        try {
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            // answer key from db
            Map<Integer, String> answers = loadAnswerKey(conn, questionIds);

            int total = answers.size();
            int correct = evaluate(req, answers);
            int score = (total == 0) ? 0 : (correct * 100 / total);

            // store result
            ResultsService.ensureResultsRow(conn, userId);
            ResultsService.updateCategoryScore(conn, userId, column, score);

            int[] sc = ResultsService.fetchScores(conn, userId);
            String recommendation = generateCareer(sc);
            ResultsService.updateRecommendation(conn, userId, recommendation);

            conn.commit();

            // send to result.jsp
            req.setAttribute("category", capitalize(category));
            req.setAttribute("score", score);
            req.setAttribute("recommendation", recommendation);

            req.getRequestDispatcher("result.jsp").forward(req, resp);

        } catch (Exception ex) {
            try { if (conn != null) conn.rollback(); } catch (Exception ignore) {}
            req.setAttribute("errorMessage", "Error submitting exam → " + ex.getMessage());
            req.getRequestDispatcher("test.jsp?category=" + category).forward(req, resp);

        } finally {
            DatabaseConnection.close(conn);   // 🔥 Correct final fix
        }
    }

    // =============================================================
    // Utility Methods
    // =============================================================

    private List<Integer> extractIds(String[] raw) {
        List<Integer> ids = new ArrayList<>();
        if (raw != null)
            for (String x : raw)
                try { ids.add(Integer.parseInt(x)); } catch(Exception ignored){}
        return ids;
    }

    private Map<Integer,String> loadAnswerKey(Connection conn, List<Integer> ids) throws SQLException {
        Map<Integer,String> map = new HashMap<>();
        if (ids.isEmpty()) return map;

        String list = ids.toString().replace("[","").replace("]","");

        PreparedStatement ps = conn.prepareStatement(
            "SELECT id,correct_option FROM questions WHERE id IN ("+list+")"
        );

        ResultSet rs = ps.executeQuery();
        while (rs.next()) map.put(rs.getInt(1), rs.getString(2));
        return map;
    }

    private int evaluate(HttpServletRequest req, Map<Integer,String> key) {
        int correct = 0;
        for (int id : key.keySet()) {
            String ans = req.getParameter("q_" + id);
            if (ans != null && ans.equalsIgnoreCase(key.get(id)))
                correct++;
        }
        return correct;
    }

    private String generateCareer(int[] s) {
        int max = Math.max(Math.max(s[0],s[1]),Math.max(s[2],s[3]));
        if (max == 0) return "Complete more tests for proper evaluation";

        if (s[2] == max) return "Software Developer / Backend Engineer";
        if (s[1] == max) return "Data Analyst & Logical Computing Roles";
        if (s[0] == max) return "Product / Business Analyst & Quant Roles";
        return "Communication / Client Facing / HR Roles";
    }

    private String normalize(String s){
        return (s==null)?"aptitude":s.toLowerCase().trim();
    }

    private String capitalize(String s){
        return s.substring(0,1).toUpperCase() + s.substring(1);
    }

    private String resolveColumn(String c){
        switch(c){
            case "logic": return "logic";
            case "tech": 
            case "technical": return "tech";
            case "english": return "english";
            default: return "aptitude";
        }
    }
}
