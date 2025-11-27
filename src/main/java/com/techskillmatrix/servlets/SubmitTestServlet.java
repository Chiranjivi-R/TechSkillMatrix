package com.techskillmatrix.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.techskillmatrix.db.DatabaseConnection;
import com.techskillmatrix.db.ResultsService;

@WebServlet("/SubmitTestServlet")
public class SubmitTestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect("index.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String category = normalizeCategory(request.getParameter("category"));
        String categoryColumn = getColumnName(category);

        if(categoryColumn == null) categoryColumn = "aptitude";

        String[] questionIdParams = request.getParameterValues("questionIds");
        List<Integer> questionIds = parseQuestionIds(questionIdParams);

        if(questionIds.isEmpty()){
            response.sendRedirect("test.jsp?category=" + category + "&status=invalid");
            return;
        }

        Connection conn = null;

        try{
            conn = DatabaseConnection.getConnection();
            conn.setAutoCommit(false);

            Map<Integer,String> correctAnswers = loadCorrectAnswers(conn, questionIds);

            int correctCount = evaluateAnswers(request, correctAnswers);
            int total = correctAnswers.size();
            int score = total == 0 ? 0 : (int)Math.round((correctCount/(double)total)*100);

            ResultsService.ensureResultsRow(conn, userId);
            ResultsService.updateCategoryScore(conn, userId, categoryColumn, score);

            int[] updatedScores = ResultsService.fetchScores(conn, userId);

            String recommendation = determineRecommendation(updatedScores);
            if(recommendation == null) recommendation = "Needs more tests to analyze profile.";

            ResultsService.updateRecommendation(conn, userId, recommendation);
            conn.commit();

            request.setAttribute("category", toTitleCase(category));
            request.setAttribute("score", score);

            forwardToResults(request,response);

        }catch(Exception e){
            try{ if(conn!=null) conn.rollback(); }catch(SQLException ignored){}
            request.setAttribute("errorMessage", "Test submit failed: "+e.getMessage());
            request.getRequestDispatcher("test.jsp?category="+category).forward(request,response);
        }
        finally{
            DatabaseConnection.closeConnection(conn);
        }
    }

    private List<Integer> parseQuestionIds(String[] list){
        List<Integer> ids = new ArrayList<>();
        if(list!=null){
            for(String id:list){
                try{ ids.add(Integer.parseInt(id)); }catch(NumberFormatException ignored){}
            }
        }
        return ids;
    }

    private Map<Integer,String> loadCorrectAnswers(Connection conn,List<Integer> ids) throws SQLException{
        Map<Integer,String> map = new HashMap<>();
        if(ids.isEmpty()) return map;

        StringBuilder sql = new StringBuilder("SELECT id,correct_option FROM questions WHERE id IN(");
        for(int i=0;i<ids.size();i++){ sql.append("?").append(i<ids.size()-1?",":""); }
        sql.append(")");

        PreparedStatement ps = conn.prepareStatement(sql.toString());
        for(int i=0;i<ids.size();i++) ps.setInt(i+1,ids.get(i));

        ResultSet rs = ps.executeQuery();
        while(rs.next()) map.put(rs.getInt("id"),rs.getString("correct_option"));
        return map;
    }

    private int evaluateAnswers(HttpServletRequest req, Map<Integer,String> correct){
        int count = 0;
        for(Map.Entry<Integer,String> x: correct.entrySet()){
            String ans = req.getParameter("q_"+x.getKey());
            if(ans!=null && x.getValue()!=null && x.getValue().equalsIgnoreCase(ans)) count++;
        }
        return count;
    }

    private String determineRecommendation(int[] s){
        int max = Math.max(Math.max(s[0],s[1]),Math.max(s[2],s[3]));

        if(max==0) return null;
        if(s[2]==max) return "Software Developer / Backend Engineer";
        if(s[1]==max) return "Data Analyst / Problem Solving Roles";
        if(s[0]==max) return "Product & Quantitative Decision Roles";
        return "Client Communication, HR & Coordination Jobs";
    }

    private void forwardToResults(HttpServletRequest req,HttpServletResponse resp)
            throws ServletException, IOException{
        req.getRequestDispatcher("result.jsp").forward(req,resp);
    }

    private String normalizeCategory(String c){
        return (c==null?"aptitude":c.trim().toLowerCase());
    }

    private String toTitleCase(String c){
        return c.substring(0,1).toUpperCase()+c.substring(1);
    }

    private String getColumnName(String c){
        switch(c){
            case "aptitude":return "aptitude";
            case "logic":return "logic";
            case "tech":
            case "technical":return "tech";
            case "english":return "english";
        }
        return null;
    }
}
