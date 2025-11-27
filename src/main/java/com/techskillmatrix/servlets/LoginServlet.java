package com.techskillmatrix.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.techskillmatrix.db.DatabaseConnection;

@WebServlet("/LoginServlet")   // 🔥 This is the FIX — now URL matches
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 🔹 Basic validation
        if(email == null || password == null || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Email and Password required.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }

        try(Connection conn = DatabaseConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                    "SELECT id, name FROM students WHERE email=? AND password=?")) {

            stmt.setString(1, email.trim());
            stmt.setString(2, password.trim());

            ResultSet rs = stmt.executeQuery();

            if(rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name"));
                
                response.sendRedirect("dashboard.jsp"); // 🟢 Login success
            } else {
                request.setAttribute("errorMessage", "Invalid email or password");
                request.getRequestDispatcher("index.jsp").forward(request, response);
            }

        } catch (ClassNotFoundException | SQLException e) {
            request.setAttribute("errorMessage", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
}
