<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.techskillmatrix.db.ResultsService"%>
<%@ page import="com.techskillmatrix.model.UserResults"%>

<%
    // 🔹 Session validation
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    Integer userId = (Integer) session.getAttribute("userId");
    String userName = (String) session.getAttribute("userName");

    Integer aptitudeScore = null, logicScore = null, techScore = null, englishScore = null;
    String recommendation = null;
    boolean hasResults = false;

    try {
        UserResults results = ResultsService.fetchUserResults(userId);
        if (results != null && results.hasData()) {
            hasResults = true;
            aptitudeScore = results.getAptitude();
            logicScore = results.getLogic();
            techScore = results.getTech();
            englishScore = results.getEnglish();
            recommendation = results.getRecommendation();
        }
    } catch (Exception e) {
        request.setAttribute("errorMessage", "Unable to load results: " + e.getMessage());
    }

    String latestCategory = (String) request.getAttribute("category");
    Integer latestScore = (Integer) request.getAttribute("score");
%>

<!DOCTYPE html>
<html>
<head>
<title>TechSkill Matrix - Results</title>
<meta charset="UTF-8">
<style>
*{margin:0;padding:0;box-sizing:border-box;}
body{background:#f4f6ff;font-family:sans-serif;}

.navbar{
    background:linear-gradient(135deg,#6578ff,#7b42e2);
    padding:15px 30px;color:#fff;
    display:flex;justify-content:space-between;align-items:center;
}
.navbar a{
    color:#fff;text-decoration:none;
    margin-left:15px;padding:6px 12px;border-radius:6px;
}
.navbar a:hover{background:rgba(255,255,255,0.2);}

.container{max-width:900px;margin:40px auto;padding:20px;}
.card{
    background:#fff;padding:32px;border-radius:14px;
    box-shadow:0 15px 40px rgba(0,0,0,0.07);
}

h2{color:#4a5cff;margin-bottom:6px;}
.subtitle{color:#666;margin-bottom:18px;}

.message{
    padding:12px;border-left:5px solid;
    margin-bottom:20px;border-radius:6px;font-weight:600;
}
.error{background:#ffe6e6;border-color:#ff4d4d;}
.success{background:#eaffea;border-color:#17b357;}

table{width:100%;border-collapse:collapse;margin-top:10px;}
th,td{
    padding:12px;border-bottom:1px solid #eee;
    text-align:left;font-size:15px;
}
th{background:#eef1ff;color:#4a52d1;font-weight:bold;}

.btn{
    background:linear-gradient(135deg,#6578ff,#7b42e2);
    color:#fff;padding:11px 22px;border-radius:8px;
    text-decoration:none;margin-right:10px;
    font-weight:600;display:inline-block;
}
.btn:hover{
    opacity:.9;transform:translateY(-2px);
    transition:.2s;
}

.career-box{
    margin-top:25px;padding:20px;
    background:#eaf1ff;border-left:5px solid #4b6cff;
    border-radius:12px;
}
.career-box h3{margin-bottom:10px;color:#253a8c;}

.summary-box{
    margin-top:25px;padding:18px;
    background:#fff8e6;border-left:7px solid #ff9800;
    border-radius:10px;
}
.summary-box h3{
    color:#d47a00;margin-bottom:12px;
    font-size:19px;
}
.summary-box ul{
    list-style:none;line-height:1.6;font-size:16px;
}
.summary-box li{margin-bottom:8px;}

/* 🔥 Progress Bars */
.progress-container{
    width:100%;background:#e6e6e6;height:12px;
    border-radius:10px;margin-top:5px;overflow:hidden;
}
.progress-bar{
    height:100%;transition:0.5s;border-radius:10px;
}
.low{background:#ff4d4d;}      /* < 50 */
.mid{background:#ffb74d;}      /* 50–74 */
.good{background:#66e07c;}     /* 75–89 */
.excellent{background:#4da3ff;}/* 90+ */
</style>
</head>

<body>

<nav class="navbar">
    <h2 style="color:white;">TechSkill Matrix</h2>
    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <!-- always send a default category -->
        <a href="test.jsp?category=aptitude">Take Test</a>
        <!-- must match @WebServlet("/Logout") -->
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">
<div class="card">

<h2>Hi, <%= userName %> 👋</h2>
<p class="subtitle">Here are your performance analytics.</p>

<% if (latestCategory != null && latestScore != null) { %>
    <div class="message success">
        Latest <b><%= latestCategory %></b> score updated → <b><%= latestScore %>%</b>
    </div>
<% } %>

<% if (request.getAttribute("errorMessage") != null) { %>
    <div class="message error">
        <%= request.getAttribute("errorMessage") %>
    </div>
<% } %>

<% if (!hasResults) { %>
    <h3>No test data found ⚠</h3>
    <br>
    <a href="test.jsp?category=aptitude" class="btn">Take Test</a>

<% } else { %>

    <!-- Score Table with Progress Bars -->
    <table>
        <tr><th>Skill</th><th>Score</th></tr>

        <tr>
          <td>Aptitude</td>
          <td>
            <%= aptitudeScore %>%
            <div class="progress-container">
                <div class="progress-bar 
                    <%= aptitudeScore < 50 ? "low" : aptitudeScore < 75 ? "mid" : aptitudeScore < 90 ? "good" : "excellent" %>" 
                    style="width:<%= aptitudeScore %>%"></div>
            </div>
          </td>
        </tr>

        <tr>
          <td>Logical Reasoning</td>
          <td>
            <%= logicScore %>%
            <div class="progress-container">
                <div class="progress-bar 
                    <%= logicScore < 50 ? "low" : logicScore < 75 ? "mid" : logicScore < 90 ? "good" : "excellent" %>" 
                    style="width:<%= logicScore %>%"></div>
            </div>
          </td>
        </tr>

        <tr>
          <td>Technical</td>
          <td>
            <%= techScore %>%
            <div class="progress-container">
                <div class="progress-bar 
                    <%= techScore < 50 ? "low" : techScore < 75 ? "mid" : techScore < 90 ? "good" : "excellent" %>" 
                    style="width:<%= techScore %>%"></div>
            </div>
          </td>
        </tr>

        <tr>
          <td>English</td>
          <td>
            <%= englishScore %>%
            <div class="progress-container">
                <div class="progress-bar 
                    <%= englishScore < 50 ? "low" : englishScore < 75 ? "mid" : englishScore < 90 ? "good" : "excellent" %>" 
                    style="width:<%= englishScore %>%"></div>
            </div>
          </td>
        </tr>
    </table>

    <!-- Career Box -->
    <div class="career-box">
        <h3>Recommended Career Path</h3>
        <p>
            <%= (recommendation == null || recommendation.isEmpty())
                    ? "Take more tests to refine insights."
                    : recommendation %>
        </p>
    </div>

    <!-- Summary Insights -->
    <div class="summary-box">
        <h3>📊 Performance Summary</h3>
        <ul>
            <%-- Weak Areas (<50) --%>
            <% if (aptitudeScore < 50) { %>
                <li>🔻 Improve Aptitude accuracy & speed.</li>
            <% } %>
            <% if (logicScore < 50) { %>
                <li>🔻 Logical thinking needs more puzzle practice.</li>
            <% } %>
            <% if (techScore < 50) { %>
                <li>🔻 Technical coding fundamentals need work.</li>
            <% } %>
            <% if (englishScore < 50) { %>
                <li>🔻 Strengthen English grammar & vocabulary.</li>
            <% } %>

            <%-- Medium Scores 50–79 --%>
            <% if (aptitudeScore >= 50 && aptitudeScore < 80) { %>
                <li>📌 Aptitude good — aim for faster solving.</li>
            <% } %>
            <% if (logicScore >= 50 && logicScore < 80) { %>
                <li>📌 Logic improving — keep practicing patterns.</li>
            <% } %>
            <% if (techScore >= 50 && techScore < 80) { %>
                <li>📌 Technical sound — try more coding tasks.</li>
            <% } %>
            <% if (englishScore >= 50 && englishScore < 80) { %>
                <li>📌 English good — more reading boosts fluency.</li>
            <% } %>

            <%-- High Scores (80+) --%>
            <% if (aptitudeScore >= 80) { %>
                <li>🌟 Excellent Aptitude — quant reasoning strong.</li>
            <% } %>
            <% if (logicScore >= 80) { %>
                <li>🌟 Logic exceptional — strong analytical mind.</li>
            <% } %>
            <% if (techScore >= 80) { %>
                <li>🌟 Technical strong — coding ability sharp.</li>
            <% } %>
            <% if (englishScore >= 80) { %>
                <li>🌟 Fluent English — communication great.</li>
            <% } %>
        </ul>
    </div>

    <br>
    <a href="dashboard.jsp" class="btn">Back to Dashboard</a>
    <a href="test.jsp?category=aptitude" class="btn">Take Another Test</a>

<% } %>

</div>
</div>

</body>
</html>
