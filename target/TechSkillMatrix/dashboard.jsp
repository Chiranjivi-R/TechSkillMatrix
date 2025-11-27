<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.techskillmatrix.db.ResultsService"%>
<%@ page import="com.techskillmatrix.model.UserResults"%>

<%
    // Validate session
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    UserResults results = null;
    boolean hasScores = false;
    String dashboardError = null;

    try {
        results = ResultsService.fetchUserResults(userId);
        hasScores = results != null && results.hasData();
    } catch (Exception e) {
        dashboardError = "❗ Unable to load score details.";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TechSkill Matrix - Dashboard</title>

<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Segoe UI',sans-serif;background:#f5f5f5}

.navbar{
background:linear-gradient(135deg,#667eea,#764ba2);
color:#fff;padding:15px 30px;display:flex;
justify-content:space-between;align-items:center;
box-shadow:0 2px 10px rgba(0,0,0,0.1)
}

.navbar h1{font-size:1.5em}
.navbar .user-info{display:flex;gap:18px}
.navbar a{color:#fff;text-decoration:none;padding:8px 15px;border-radius:5px}
.navbar a:hover{background:rgba(255,255,255,0.25)}

.container{max-width:1200px;margin:30px auto;padding:0 20px}

.welcome-card,.scores-card{
background:#fff;border-radius:10px;padding:30px;margin-bottom:25px;
box-shadow:0 2px 10px rgba(0,0,0,0.1)
}

.welcome-card h2{color:#667eea;margin-bottom:8px}

.scores-card h3{color:#5b47c5;margin-bottom:12px}
.scores-empty{color:#666;font-size:15px;margin-bottom:15px}

.scores-table{
width:100%;border-collapse:collapse;margin-top:10px
}
.scores-table th{background:#f4f1ff;color:#4a3c79;padding:12px;text-align:left}
.scores-table td{padding:12px;border-bottom:1px solid #eee}

.recommendation{
background:#eef4ff;padding:15px;margin-top:15px;border-radius:10px;
border-left:4px solid #4b6cff;color:#1f2c65;font-size:15px
}

.cards-grid{
margin-top:25px;display:grid;
grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:22px
}
.card{
background:#fff;padding:25px;border-radius:10px;
box-shadow:0 2px 10px rgba(0,0,0,0.1);
transition:.3s
}
.card:hover{transform:translateY(-4px);box-shadow:0 8px 20px rgba(0,0,0,0.18)}
.card h3{color:#667eea;margin-bottom:10px}
.card p{color:#666;margin-bottom:18px;line-height:1.5}
.card-btn{
background:linear-gradient(135deg,#667eea,#764ba2);
color:#fff;text-decoration:none;padding:10px 20px;
border-radius:6px;display:inline-block;transition:.2s
}
.card-btn:hover{transform:translateY(-2px)}
</style>
</head>

<body>

<nav class="navbar">
    <h1>TechSkill Matrix</h1>
    <div class="user-info">
        <span>Welcome, <%= userName %> 👋</span>
        <a href="LogoutServlet">Logout</a>
    </div>
</nav>

<div class="container">

    <div class="welcome-card">
        <h2>Your Dashboard</h2>
        <p>View your scores & continue your growth assessments.</p>
    </div>

    <div class="scores-card">
        <h3>Your Skill Scores</h3>

        <% if (dashboardError != null) { %>
            <p class="scores-empty"><%= dashboardError %></p>

        <% } else if (!hasScores) { %>
            <p class="scores-empty">No test taken yet — attempt one to unlock your matrix.</p>

        <% } else { %>

            <table class="scores-table">
                <tr><th>Aptitude</th><td><%= results.getAptitude() %></td></tr>
                <tr><th>Logical Reasoning</th><td><%= results.getLogic() %></td></tr>
                <tr><th>Technical</th><td><%= results.getTech() %></td></tr>
                <tr><th>English</th><td><%= results.getEnglish() %></td></tr>
            </table>

            <div class="recommendation">
                <strong>Recommended Career Path →</strong><br>
                <%= results.getRecommendation() == null || results.getRecommendation().isEmpty()
                        ? "Take minimum one test to unlock insights."
                        : results.getRecommendation() %>
            </div>

        <% } %>

    </div>

    <div class="cards-grid">
        <div class="card">
            <h3>📊 Aptitude</h3><p>Core quantitative & numerical thinking.</p>
            <a class="card-btn" href="test.jsp?category=aptitude">Start Test</a>
        </div>

        <div class="card">
            <h3>🧠 Logical Reasoning</h3><p>Patterns, sequences & analytical logic.</p>
            <a class="card-btn" href="test.jsp?category=logic">Start Test</a>
        </div>

        <div class="card">
            <h3>💻 Technical Knowledge</h3><p>Programming & computer science MCQs.</p>
            <a class="card-btn" href="test.jsp?category=tech">Start Test</a>
        </div>

        <div class="card">
            <h3>✍ English</h3><p>Grammar, comprehension & communication.</p>
            <a class="card-btn" href="test.jsp?category=english">Start Test</a>
        </div>

        <div class="card">
            <h3>📄 View Result Summary</h3><p>Check past scores & improvement guidance.</p>
            <a class="card-btn" href="result.jsp">Open Results</a>
        </div>
    </div>
</div>

</body>
</html>
