package com.techskillmatrix.servlets;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.techskillmatrix.db.DatabaseConnection;

@WebServlet("/signup")   // 🚀 cleaner URL → /signup
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic Validation
        if(name.isBlank() || email.isBlank() || password.isBlank()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
            return;
        }

        try(Connection conn = DatabaseConnection.getConnection()) {

            PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO users (name, email, password) VALUES (?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );

            stmt.setString(1, name.trim());
            stmt.setString(2, email.trim());
            stmt.setString(3, password.trim());  // 🔹 plain-text (Hash soon)

            int rows = stmt.executeUpdate();

            if(rows > 0) {
                ResultSet key = stmt.getGeneratedKeys();
                if(key.next()) {

                    int userId = key.getInt(1);

                    HttpSession session = request.getSession();
                    session.setAttribute("userId", userId);
                    session.setAttribute("userName", name.trim());

                    response.sendRedirect("dashboard.jsp");  // SIGNUP SUCCESS ✔
                    return;
                }
            }

            request.setAttribute("errorMessage", "Registration failed. Try again.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);

        } catch (SQLIntegrityConstraintViolationException e) {
            request.setAttribute("errorMessage", "Email already registered. Login instead.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database Error: " + e.getMessage());
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("signup.jsp");
    }
}
