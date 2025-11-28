<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,com.techskillmatrix.db.DatabaseConnection"%>

<%
    // Session Protection
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String category = (request.getParameter("category") == null) 
                        ? "aptitude" : request.getParameter("category").trim().toLowerCase();

    List<Map<String,Object>> questions = new ArrayList<>();
    String categoryTitle = category.substring(0,1).toUpperCase()+category.substring(1);

    try(Connection conn = DatabaseConnection.getConnection()){
        PreparedStatement st = conn.prepareStatement(
            "SELECT id,question,optionA,optionB,optionC,optionD FROM questions WHERE category=? ORDER BY RAND() LIMIT 10"
        );
        st.setString(1, category);
        ResultSet rs = st.executeQuery();

        while(rs.next()){
            Map<String,Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("question", rs.getString("question"));
            map.put("A", rs.getString("optionA"));
            map.put("B", rs.getString("optionB"));
            map.put("C", rs.getString("optionC"));
            map.put("D", rs.getString("optionD"));
            questions.add(map);
        }
    }catch(Exception e){
        out.println("<p style='color:red;font-weight:bold'>Error loading questions → "+e.getMessage()+"</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
<title><%=categoryTitle%> Test | TechSkill Matrix</title>

<style>
    *{margin:0;padding:0;box-sizing:border-box;font-family:"Segoe UI",sans-serif;}
    body{background:#eef0ff;}

    /* Navbar */
    .navbar{background:linear-gradient(135deg,#667eea,#764ba2);
            padding:14px 30px;color:#fff;
            display:flex;justify-content:space-between;align-items:center;}
    .navbar a{color:#fff;text-decoration:none;margin-left:12px;
              font-weight:500;padding:6px 12px;border-radius:6px;}
    .navbar a:hover{background:rgba(255,255,255,.25);}

    /* Main Container */
    .container{max-width:900px;margin:40px auto;padding:0 20px;}
    .card{background:#fff;padding:30px;border-radius:12px;
          box-shadow:0 10px 35px rgba(0,0,0,.08);}

    .subtitle{color:#666;margin-bottom:20px;}

    /* Question Box */
    .qbox{background:#f9fbff;border-radius:10px;padding:18px;margin-bottom:16px;
          border:1px solid #e4e7ff;}

    h3{font-size:18px;margin-bottom:10px;color:#4a54e1;}

    /* Options */
    .option{
        display:block;padding:10px 14px;margin:6px 0;
        background:#fff;border-radius:8px;border:1px solid #ccd3ff;cursor:pointer;
        transition:.3s;font-size:15px;}
    .option:hover{border-color:#667eea;transform:scale(1.01);}
    input[type="radio"]{margin-right:8px;cursor:pointer;}

    /* Submit Button */
    .btn{
        width:100%;padding:14px;border:none;
        border-radius:8px;margin-top:18px;font-size:17px;
        background:linear-gradient(135deg,#667eea,#764ba2);color:#fff;
        cursor:pointer;font-weight:bold;transition:.25s;}
    .btn:hover{transform:scale(1.03);}

    .noq{padding:20px;color:#d00;font-size:20px;font-weight:bold;text-align:center;}
    .back{display:inline-block;margin-top:15px;color:#667eea;font-weight:bold;text-decoration:none;}
    .back:hover{text-decoration:underline;}
</style>

</head>
<body>

<nav class="navbar">
    <h2>TechSkill Matrix</h2>
    <div>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="LogoutServlet">Logout</a>
    </div>
</nav>

<div class="container">
<div class="card">

<h2><%=categoryTitle%> Test</h2>
<p class="subtitle">Choose the correct answer for each MCQ below 👇</p>

<% if(questions.size()==0){ %>

    <div class="noq">⚠ No Questions Available</div>
    <a class="back" href="dashboard.jsp">← Back to Dashboard</a>

<% } else { %>

<form action="submit-test" method="post">
<input type="hidden" name="category" value="<%=category%>">

<%
int qNo = 1;
for(Map<String,Object> q : questions){
%>

<div class="qbox">
    <h3>Q<%=qNo++%>. <%=q.get("question")%></h3>
    <input type="hidden" name="questionIds" value="<%=q.get("id")%>">

    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="A" required> A) <%=q.get("A")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="B" required> B) <%=q.get("B")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="C" required> C) <%=q.get("C")%></label>
    <label class="option"><input type="radio" name="q_<%=q.get("id")%>" value="D" required> D) <%=q.get("D")%></label>
</div>

<% } %>

<button class="btn">Submit Test →</button>
</form>

<% } %>

</div>
</div>

</body>
</html>
