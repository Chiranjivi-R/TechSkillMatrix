🧠 TechSkill Matrix

A Java-based Skill Assessment & Analytics Platform
Built using JSP + Servlets + MySQL + Tomcat, designed to evaluate Aptitude, Logical Reasoning, Technical & English ability with automated scoring + career recommendations.

📌 Features
Feature	Status
User Signup + Login (Session Auth)	✔
Random MCQ Test Generation	✔
Score Evaluation & Storage	✔
Dashboard Progress Overview	✔
AI-Style Career Recommendation	✔
Live Deployment on Railway	✔ Working
📁 Project Structure
TechSkillMatrix/
├── src/main/java/com/techskillmatrix/
│   ├── servlets/            # Signup, Login, Logout, Test, Result
│   ├── db/                  # DB connection + ResultService
│   └── model/               # Result Model (Builder)
│
├── src/main/webapp/
│   ├── index.jsp            # Login Page
│   ├── signup.jsp           # New user registration
│   ├── dashboard.jsp        # Score Overview + Options
│   ├── test.jsp             # Random exam (10 questions)
│   ├── result.jsp           # Score + Recommendation output
│   └── WEB-INF/web.xml      # Servlet Mappings
│
└── Dockerfile (if used)     # Deployment build

🛢 Database Setup
CREATE DATABASE techskillmatrix;
USE techskillmatrix;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255)
);

CREATE TABLE results (
    student_id INT PRIMARY KEY,
    aptitude INT DEFAULT 0,
    logic INT DEFAULT 0,
    tech INT DEFAULT 0,
    english INT DEFAULT 0,
    recommended_career VARCHAR(255),
    FOREIGN KEY(student_id) REFERENCES users(id) ON DELETE CASCADE
);


🔥 Table column fixed — student_it → student_id

🔧 Installation Guide (Eclipse + Tomcat)
Step	Action
1	Import project → Eclipse
2	Convert to Dynamic Web Project
3	Add MySQL Connector jar to WEB-INF/lib
4	Configure & Start Tomcat Server
5	Create DB tables & update DB credentials
6	Run app on browser → http://localhost:8080/TechSkillMatrix/
🌐 Deployment (Railway / Docker)
mvn clean package -DskipTests


Generated WAR → /target/TechSkillMatrix.war

Deploy manually OR auto-build using Docker:

FROM tomcat:9.0-jdk11-temurin
RUN rm -rf /usr/local/tomcat/webapps/ROOT*
COPY target/TechSkillMatrix.war /usr/local/tomcat/webapps/ROOT.war
CMD ["catalina.sh","run"]


Live Test URL (working):
🔗 https://techskillmatrix-production.up.railway.app/

🚀 Future Enhancements
Idea	Impact
Timer for test attempts	⏳ Improve challenge level
Track previous attempt history	📊 Progress improvement view
Admin Panel for adding questions	🛠 Fully dynamic platform
PDF report export of results	📄 Great for job placements
Graph-based score visualization	📈 Better analytics UI
📜 License

Free to use for learning, projects, portfolio, or skill development.
Contributions & improvements are always welcome 🤝
