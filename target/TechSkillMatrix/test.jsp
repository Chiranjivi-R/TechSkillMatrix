<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,com.techskillmatrix.db.DatabaseConnection"%>

<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String category = request.getParameter("category") == null ? "aptitude" 
                     : request.getParameter("category").trim().toLowerCase();

    List<Map<String,Object>> questions = new ArrayList<>();
    String categoryTitle = category.substring(0,1).toUpperCase() + category.substring(1);

    try(Connection conn = DatabaseConnection.getConnection()) {
        PreparedStatement st = conn.prepareStatement(
            "SELECT id,question,optionA,optionB,optionC,optionD FROM questions WHERE category=? ORDER BY RAND() LIMIT 10"
        );
        st.setString(1, category);
        ResultSet rs = st.executeQuery();

        while(rs.next()) {
            Map<String,Object> q = new HashMap<>();
            q.put("id", rs.getInt("id"));
            q.put("question", rs.getString("question"));
            q.put("A", rs.getString("optionA"));
            q.put("B", rs.getString("optionB"));
            q.put("C", rs.getString("optionC"));
            q.put("D", rs.getString("optionD"));
            questions.add(q);
        }
    }catch(Exception e){
        out.println("<h3 style='color:red'>Error Loading Questions → "+e.getMessage()+"</h3>");
    }
%>

<!DOCTYPE html>
<html>
<head>
<title><%=categoryTitle%> Test | TechSkill Matrix</title>

<style>
    body{background:#eef0ff;font-family:'Segoe UI';margin:0;}
    .navbar{background:#6b75ff;padding:14px 30px;color:#fff;display:flex;justify-content:space-between}
    .navbar a{color:#fff;text-decoration:none;margin-left:12px;padding:6px 12px;border-radius:6px;}
    .navbar a:hover{background:rgba(255,255,255,0.3);}
    .container{max-width:900px;margin:40px auto;}
    .card{background:#fff;padding:30px;border-radius:12px;box-shadow:0 10px 35px rgba(0,0,0,0.08);}
    .qbox{background:#f8faff;border-radius:10px;padding:15px;margin-bottom:14px;border:1px solid #dfe3ff;}
    h3{margin-bottom:10px;color:#4452ff;}
    .option{display:block;background:white;border-radius:8px;border:1px solid #cfd6ff;padding:8px;margin:5px 0;}
    .option:hover{border-color:#6b75ff;background:#eef2ff;}
    input[type=radio]{margin-right:8px;}
    .btn{width:100%;padding:15px;font-size:18px;font-weight:bold;background:#6b75ff;color:white;border:none;border-radius:8px;margin-top:18px;}
    .btn:hover{transform:scale(1.03);cursor:pointer;}
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

<div class="container"><div class="card">

<h2><%=categoryTitle%> Test</h2>
<p>Select the correct answers below 👇</p>

<%
if(questions.isEmpty()){
%>
    <h3 style="color:red">No Questions Found ❗</h3>
    <a href="dashboard.jsp">Back</a>

<% }else{ %>

<form action="submit-test" method="post">
<input type="hidden" name="category" value="<%=category%>">

<% int i=1; for(Map<String,Object> q : questions){ %>

<div class="qbox">
    <h3>Q<%=i++%>. <%=q.get("question")%></h3>

    <!-- FIXED: No [] now -->
    <input type="hidden" name="questionIds" value="<%=q.get("id")%>">

    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="A" required> <%=q.get("A")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="B"> <%=q.get("B")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="C"> <%=q.get("C")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="D"> <%=q.get("D")%></label>
</div>

<% } %>

<button class="btn">Submit Test →</button>
</form>

<% } %>

</div></div>
</body>
</html>
