# Eclipse Setup Guide - Step by Step

## Quick Setup Instructions

### Step 1: Import Project
1. Open **Eclipse IDE**
2. Go to **File** → **Import**
3. Select **General** → **Existing Projects into Workspace**
4. Click **Next**
5. Click **Browse** and select the `TechSkillMatrix` folder
6. Ensure the project is checked
7. Click **Finish**

### Step 2: Convert to Dynamic Web Project
1. Right-click on **TechSkillMatrix** project
2. Select **Properties**
3. Navigate to **Project Facets**
4. Check **Dynamic Web Module** (select version 4.0)
5. Check **Java** (select version 1.8 or higher)
6. Click **Apply and Close**

### Step 3: Add MySQL Connector
1. Download MySQL Connector/J from: https://dev.mysql.com/downloads/connector/j/
2. Extract `mysql-connector-java-8.0.x.jar`
3. Copy the JAR file to: `WebContent/WEB-INF/lib/` folder
4. If the folder doesn't exist, create it: `WebContent/WEB-INF/lib/`
5. Right-click project → **Refresh** (F5)

### Step 4: Configure Tomcat Server
1. In Eclipse, go to **Window** → **Show View** → **Servers**
   - If Servers view is not visible, go to **Window** → **Show View** → **Other** → **Server** → **Servers**
2. Right-click in the Servers view → **New** → **Server**
3. Select **Apache** → **Tomcat v9.0 Server** (or your installed version)
4. Click **Next**
5. Browse to your Tomcat installation directory
6. Click **Next** → **Finish**

### Step 5: Add Project to Tomcat
1. Right-click on the **Tomcat server** in Servers view
2. Select **Add and Remove...**
3. In the left panel, select **TechSkillMatrix**
4. Click **Add >** to move it to the right panel
5. Click **Finish**

### Step 6: Setup MySQL Database
1. Open MySQL Command Line or MySQL Workbench
2. Run the following SQL commands:

```sql
CREATE DATABASE techskillmatrix;
USE techskillmatrix;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    skill_name VARCHAR(100) NOT NULL,
    score INT NOT NULL CHECK (score >= 0 AND score <= 100),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_skill (user_id, skill_name)
);
```

3. Update database credentials in `src/com/techskillmatrix/db/DatabaseConnection.java`:
   - Change `DB_USERNAME` if not using "root"
   - Change `DB_PASSWORD` to your MySQL password

### Step 7: Run the Application
1. Right-click on the **Tomcat server** in Servers view
2. Select **Start**
3. Wait for server to start (check Console for "Server startup" message)
4. Open your web browser
5. Navigate to: `http://localhost:8080/TechSkillMatrix/`

## Verification Checklist

- [ ] Project imported successfully
- [ ] Dynamic Web Module facet enabled
- [ ] MySQL connector JAR in `WebContent/WEB-INF/lib/`
- [ ] Tomcat server configured
- [ ] Project added to Tomcat server
- [ ] MySQL database created with tables
- [ ] Database credentials updated in `DatabaseConnection.java`
- [ ] Server starts without errors
- [ ] Application accessible in browser

## Troubleshooting

### Issue: "ClassNotFoundException: com.mysql.cj.jdbc.Driver"
**Solution**: Ensure `mysql-connector-java-8.0.x.jar` is in `WebContent/WEB-INF/lib/` and refresh the project.

### Issue: "404 - Page Not Found"
**Solution**: 
- Verify project is added to Tomcat server
- Check that `WebContent` folder is set as deployment source
- Restart Tomcat server

### Issue: "Database connection error"
**Solution**:
- Verify MySQL server is running
- Check database name, username, and password in `DatabaseConnection.java`
- Ensure database and tables are created

### Issue: "Project Facets" option not available
**Solution**: 
- Ensure you're using Eclipse IDE for Enterprise Java and Web Developers
- Install "Eclipse Java EE Developer Tools" from Help → Install New Software

## Default URLs

- Login: `http://localhost:8080/TechSkillMatrix/index.jsp`
- Signup: `http://localhost:8080/TechSkillMatrix/signup.jsp`
- Dashboard: `http://localhost:8080/TechSkillMatrix/dashboard.jsp`
- Test: `http://localhost:8080/TechSkillMatrix/test.jsp`
- Results: `http://localhost:8080/TechSkillMatrix/result.jsp`

## Project Structure Verification

Your project should have this structure:
```
TechSkillMatrix/
├── src/
│   └── com/
│       └── techskillmatrix/
│           ├── db/
│           │   └── DatabaseConnection.java
│           └── servlets/
│               ├── LoginServlet.java
│               ├── SignupServlet.java
│               ├── TestServlet.java
│               └── LogoutServlet.java
├── WebContent/
│   ├── WEB-INF/
│   │   ├── lib/
│   │   │   └── mysql-connector-java-8.0.x.jar
│   │   └── web.xml
│   ├── index.jsp
│   ├── signup.jsp
│   ├── dashboard.jsp
│   ├── test.jsp
│   └── result.jsp
└── lib/
    └── README.txt
```

