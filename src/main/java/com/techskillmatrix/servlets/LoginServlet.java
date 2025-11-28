package com.techskillmatrix.servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.techskillmatrix.db.DatabaseConnection;

@WebServlet("/login")  
// LIVE URL → https://techskillmatrix-production.up.railway.app/login
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if(email.isBlank() || password.isBlank()) {
            request.setAttribute("errorMessage", "Email & Password required.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        try(Connection conn = DatabaseConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT id,name FROM users WHERE email=? AND password=? LIMIT 1"
        )) {
            stmt.setString(1, email.trim());
            stmt.setString(2, password.trim());

            ResultSet rs = stmt.executeQuery();

            if(rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));

                response.sendRedirect("dashboard.jsp"); 
            } else {
                request.setAttribute("errorMessage", "❌ Invalid credentials");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Database Error: " + ex.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
