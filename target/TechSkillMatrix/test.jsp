<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,com.techskillmatrix.db.DatabaseConnection"%>

<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String category = request.getParameter("category") == null ? "aptitude" 
                     : request.getParameter("category").trim().toLowerCase();

    List<Map<String, Object>> questions = new ArrayList<>();
    String categoryTitle = category.substring(0,1).toUpperCase() + category.substring(1);

    try(Connection conn = DatabaseConnection.getConnection()){
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT id,question,optionA,optionB,optionC,optionD FROM questions WHERE category=? ORDER BY RAND() LIMIT 10"
        );
        stmt.setString(1, category);
        ResultSet rs = stmt.executeQuery();
        while(rs.next()){
            Map<String,Object> q = new HashMap<>();
            q.put("id", rs.getInt("id"));
            q.put("question", rs.getString("question"));
            q.put("A", rs.getString("optionA"));
            q.put("B", rs.getString("optionB"));
            q.put("C", rs.getString("optionC"));
            q.put("D", rs.getString("optionD"));
            questions.add(q);
        }
    } catch(Exception e){
        out.println("<p style='color:red'>Error Loading Questions: "+e.getMessage()+"</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>TechSkill Matrix - <%= categoryTitle %> Test</title>

<style>
    *{margin:0;padding:0;box-sizing:border-box;}
    body{font-family:Segoe UI;background:#f5f5f5;}
    .navbar{background:linear-gradient(135deg,#667eea,#764ba2);color:#fff;padding:15px 30px;display:flex;justify-content:space-between}
    .navbar a{color:white;text-decoration:none;padding:8px 15px;border-radius:6px;}
    .navbar a:hover{background:rgba(255,255,255,0.25);}
    .container{max-width:850px;margin:30px auto;}
    .card{background:#fff;padding:30px;border-radius:12px;box-shadow:0 15px 40px rgba(0,0,0,0.07);}
    .qbox{padding:18px;margin:12px 0;background:#fafbff;border:1px solid #ececec;border-radius:10px;}
    .option{display:flex;align-items:center;padding:8px;margin-top:8px;background:white;border-radius:8px;transition:.2s;border:1px solid transparent;}
    .option:hover{border-color:#b9ccff;}
    .btn{width:100%;padding:13px;background:linear-gradient(135deg,#667eea,#764ba2);
         border:none;color:#fff;border-radius:9px;font-size:16px;margin-top:10px;cursor:pointer;}
    .btn:hover{transform:scale(1.01);}
</style>

</head>
<body>

<nav class="navbar">
    <h2>TechSkill Matrix</h2>
    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="logout">Logout</a>
    </div>
</nav>

<div class="container">
<div class="card">

<h2><%=categoryTitle%> Assessment</h2>
<p>Select the correct answer for each question below 👇</p>
<br>

<% if(questions.size()==0){ %>

    <h3>No Questions Available ❗</h3>
    <a href="dashboard.jsp">← Go Back</a>

<% } else { %>

<form action="SubmitTestServlet" method="post">
<input type="hidden" name="category" value="<%=category%>">

<%
int no=1;
for(Map<String,Object> q:questions){
%>
<div class="qbox">
    <h3>Q<%=no++%>. <%=q.get("question")%></h3>
    <input type="hidden" name="questionIds" value="<%=q.get("id")%>">

    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="A" required> A) <%=q.get("A")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="B" required> B) <%=q.get("B")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="C" required> C) <%=q.get("C")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="D" required> D) <%=q.get("D")%></label>
</div>
<% } %>

<button class="btn">→ Submit Test</button>
</form>

<% } %>

</div>
</div>

</body>
</html>
