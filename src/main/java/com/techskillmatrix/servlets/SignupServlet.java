package com.techskillmatrix.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.techskillmatrix.db.DatabaseConnection;

/**
 * Signup Servlet
 * Handles new user registration
 */
@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (name == null || email == null || password == null
                || name.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        try {
            try (Connection conn = DatabaseConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                         "INSERT INTO students (name, email, password) VALUES (?, ?, ?)",
                         Statement.RETURN_GENERATED_KEYS)) {

                pstmt.setString(1, name.trim());
                pstmt.setString(2, email.trim());
                pstmt.setString(3, password.trim());

                int affectedRows = pstmt.executeUpdate();
                if (affectedRows == 0) {
                    request.setAttribute("errorMessage", "Registration failed. Please try again.");
                    request.getRequestDispatcher("signup.jsp").forward(request, response);
                    return;
                }

                try (ResultSet keys = pstmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        int userId = keys.getInt(1);
                        HttpSession session = request.getSession();
                        session.setAttribute("userId", userId);
                        session.setAttribute("userName", name.trim());
                        response.sendRedirect("dashboard.jsp");
                        return;
                    }
                }

                request.setAttribute("errorMessage", "Unable to complete registration. Please try again.");
                request.getRequestDispatcher("signup.jsp").forward(request, response);
            }
        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            request.setAttribute("errorMessage", "Email already registered. Try logging in.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("signup.jsp");
    }
}

