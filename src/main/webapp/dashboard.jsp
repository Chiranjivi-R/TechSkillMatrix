<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.techskillmatrix.db.ResultsService"%>
<%@ page import="com.techskillmatrix.model.UserResults"%>

<%
    // Session validation
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    UserResults results = null;
    boolean hasScores = false;

    try {
        results = ResultsService.fetchUserResults(userId);
        hasScores = results != null && results.hasData();
    } catch(Exception e) {
        hasScores = false;
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Dashboard | TechSkill Matrix</title>

<style>
*{margin:0;padding:0;font-family:'Segoe UI';box-sizing:border-box}
body{background:#f3f5ff}
nav{
 background:linear-gradient(135deg,#667eea,#764ba2);
 padding:14px 30px;color:white;
 display:flex;justify-content:space-between;align-items:center
}
nav h2{font-size:22px}
nav .r a{color:white;padding:8px 14px;border-radius:5px;text-decoration:none}
nav .r a:hover{background:rgba(255,255,255,.25)}
.container{max-width:1150px;margin:30px auto;padding:10px}

.card{
 background:white;padding:24px;margin-bottom:18px;
 border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,.08)
}

.score-table{width:100%;margin-top:12px;border-collapse:collapse}
.score-table th{background:#ece8ff;padding:10px;color:#423a75}
.score-table td{padding:10px;border-bottom:1px solid #e3e3e3}

.rec-box{
 background:#eaf0ff;padding:15px;margin-top:15px;
 border-radius:8px;border-left:4px solid #5270ff;font-size:15px
}

.grid{
 display:grid;gap:20px;margin-top:22px;
 grid-template-columns:repeat(auto-fill,minmax(260px,1fr))
}
.box{
 background:white;padding:20px;border-radius:10px;text-align:left;
 box-shadow:0 2px 10px rgba(0,0,0,.1);transition:.25s
}
.box:hover{transform:translateY(-4px)}
.box h3{color:#667eea;margin-bottom:8px}
.box-btn{
 background:linear-gradient(135deg,#667eea,#764ba2);
 color:white;text-decoration:none;padding:8px 18px;border-radius:5px;
 display:inline-block;margin-top:10px
}
.box-btn:hover{opacity:.9}
</style>
</head>

<body>

<nav>
    <h2>TechSkill Matrix</h2>
    <div class="r">
    Welcome <b><%= userName %></b> 👋 &nbsp;
    <a href="logout">Logout</a>
	</div>

</nav>

<div class="container">

    <!-- Welcome Header -->
    <div class="card">
        <h2>Dashboard Overview</h2>
        <p>Track your performance & explore test modules to improve skill mapping.</p>
    </div>

    <!-- Score Section -->
    <div class="card">
        <h3>Your Results Summary</h3>

        <% if(!hasScores){ %>

            <p>No results found yet — take your first test now! 🚀</p>

        <% } else { %>

        <table class="score-table">
            <tr><th>Aptitude</th><td><%= results.getAptitude() %>%</td></tr>
            <tr><th>Logical Reasoning</th><td><%= results.getLogic() %>%</td></tr>
            <tr><th>Technical</th><td><%= results.getTech() %>%</td></tr>
            <tr><th>English</th><td><%= results.getEnglish() %>%</td></tr>
        </table>

        <div class="rec-box">
            <b>Recommended Career:</b><br>
            <%= results.getRecommendation() != null ? results.getRecommendation() : "Take tests to reveal best suited career path" %>
        </div>

        <% } %>

    </div>

    <!-- Test/Navigation Cards -->
    <div class="grid">

        <div class="box"><h3>📊 Aptitude</h3><p>Numbers, reasoning & maths intelligence.</p>
        <a href="test.jsp?category=aptitude" class="box-btn">Start Test</a></div>

        <div class="box"><h3>🧠 Logic</h3><p>Puzzles, patterns & analytical thinking.</p>
        <a href="test.jsp?category=logic" class="box-btn">Start Test</a></div>

        <div class="box"><h3>💻 Technical</h3><p>Programming & engineering concepts.</p>
        <a href="test.jsp?category=tech" class="box-btn">Start Test</a></div>

        <div class="box"><h3>✍ English</h3><p>Language structure & comprehension test.</p>
        <a href="test.jsp?category=english" class="box-btn">Start Test</a></div>

        <div class="box"><h3>📄 Summary</h3><p>Full report → skills + recommended field.</p>
        <a href="result.jsp" class="box-btn">View Result</a></div>

    </div>
</div>

</body>
</html>
