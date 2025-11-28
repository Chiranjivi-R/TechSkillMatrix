<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TechSkill Matrix - Login</title>

<style>
/* ——— Existing Styling Kept Same ——— */
*{margin:0;padding:0;box-sizing:border-box}
body{
    font-family:'Segoe UI',sans-serif;
    background:linear-gradient(135deg,#667eea,#764ba2);
    min-height:100vh;display:flex;justify-content:center;align-items:center
}
.container{
    background:#fff;padding:40px;border-radius:15px;
    width:100%;max-width:450px;box-shadow:0 10px 40px rgba(0,0,0,0.2)
}
h1{text-align:center;color:#667eea;margin-bottom:6px}
.subtitle{text-align:center;color:#666;margin-bottom:25px}
.form-group{margin-bottom:18px}
label{font-weight:600;color:#444;margin-bottom:6px;display:block}

input[type=email],input[type=password]{
    width:100%;padding:12px;font-size:1em;border-radius:8px;
    border:2px solid #ddd;transition:.3s
}
input:focus{border-color:#667eea;outline:none}

.btn{
    width:100%;padding:12px;border:none;border-radius:8px;
    background:linear-gradient(135deg,#667eea,#764ba2);
    color:white;font-weight:600;font-size:1em;cursor:pointer;
    transition:.3s
}
.btn:hover{transform:translateY(-2px);box-shadow:0 4px 18px rgba(102,126,234,.45)}

.error-message,.success-message{
    margin-bottom:15px;padding:12px;border-radius:8px;font-weight:500
}
.error-message{background:#fee;color:#b00;border-left:4px solid #b00}
.success-message{background:#efe;color:#080;border-left:4px solid #080}

.signup-link{text-align:center;margin-top:18px;color:#555}
.signup-link a{color:#667eea;font-weight:600;text-decoration:none}
.signup-link a:hover{text-decoration:underline}
</style>
</head>

<body>

<div class="container">
    <h1>TechSkill Matrix</h1>
    <p class="subtitle">Assess. Improve. Grow.</p>

    <%-- Alert Messages --%>
    <% if(request.getAttribute("errorMessage")!=null){ %>
        <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
    <% } %>
    <% if(request.getAttribute("successMessage")!=null){ %>
        <div class="success-message"><%= request.getAttribute("successMessage") %></div>
    <% } %>

    <!-- 🔥 FIXED form submission URL -->
    <form action="login" method="post">
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required autocomplete="off">
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>

        <button type="submit" class="btn">Login</button>
    </form>

    <div class="signup-link">
        New here? <a href="signup.jsp">Create account</a>
    </div>
</div>

</body>
</html>
