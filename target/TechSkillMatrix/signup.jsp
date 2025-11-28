<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>TechSkill Matrix - Sign Up</title>

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:'Segoe UI',sans-serif;}

    body{
        height:100vh;
        background:linear-gradient(135deg,#6a82fb,#fc5c7d);
        display:flex;justify-content:center;align-items:center;
        padding:20px;
    }

    .card{
        width:100%;max-width:430px;
        background:rgba(255,255,255,0.13);
        backdrop-filter:blur(12px);
        border-radius:16px;
        padding:38px;
        color:white;
        box-shadow:0 8px 25px rgba(0,0,0,.25);
        animation:fade 0.8s ease-in-out;
    }
    @keyframes fade{from{opacity:0;transform:scale(.93);}to{opacity:1;}}

    h2{text-align:center;margin-bottom:10px;font-size:28px;font-weight:600;}
    p{text-align:center;margin-bottom:25px;font-size:14px;opacity:.9;}

    .form-group{margin-bottom:18px;}
    label{font-size:15px;font-weight:500;display:block;margin-bottom:6px;}
    
    input{
        width:100%;padding:12px;border-radius:8px;border:none;
        font-size:15px;outline:none;color:#222;
    }

    input:focus{border:2px solid #6a82fb;}

    .btn{
        width:100%;padding:12px;margin-top:8px;
        border:none;border-radius:8px;
        background:#6a82fb;color:white;
        font-size:16px;font-weight:600;
        cursor:pointer;transition:.25s;
    }
    .btn:hover{transform:translateY(-2px);background:#4e65f6;}

    .error, .success{
        padding:12px;border-left:5px solid;
        margin-bottom:18px;border-radius:6px;
        font-size:14px;background:#fff;color:#222;
    }
    .error{border-color:#ff4c4c;background:#ffecec;}
    .success{border-color:#13ce66;background:#e9ffe9;}

    .login{
        text-align:center;margin-top:15px;font-size:14px;
    }
    .login a{color:#fff;font-weight:600;}
    .login a:hover{text-decoration:underline;}
</style>
</head>

<body>

<div class="card">
    
    <h2>Create Account</h2>
    <p>Join TechSkill Matrix and track your skill growth</p>

    <!-- Alerts -->
    <% if(request.getAttribute("errorMessage") != null){ %>
        <div class="error"><%= request.getAttribute("errorMessage") %></div>
    <% } %>
    <% if(request.getAttribute("successMessage") != null){ %>
        <div class="success"><%= request.getAttribute("successMessage") %></div>
    <% } %>

    <!-- Sign up Form -->
    <form action="signup" method="post">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="name" placeholder="Enter your name" required>
        </div>

        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="Enter email" required>
        </div>

        <div class="form-group">
            <label>Create Password</label>
            <input type="password" name="password" placeholder="Minimum 6 characters" required minlength="6">
        </div>

        <button class="btn">Register Now</button>
    </form>

    <div class="login">
        Already have an account? <a href="index.jsp">Login here</a>
    </div>
</div>

</body>
</html>
