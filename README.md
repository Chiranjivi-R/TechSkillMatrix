# TechSkill Matrix

A Java Web Application for tracking and assessing technical skills using JSP, Servlets, and MySQL.

## Project Structure

```
TechSkillMatrix/
├── src/
│   ├── com.techskillmatrix.servlets/     # All servlet files
│   └── com.techskillmatrix.db/           # Database connection class
├── WebContent/
│   ├── index.jsp                         # Login page
│   ├── signup.jsp                        # Registration page
│   ├── dashboard.jsp                     # User dashboard
│   ├── test.jsp                          # Skill assessment test
│   └── result.jsp                         # Test results display
├── WEB-INF/
│   └── web.xml                           # Servlet mappings
└── lib/                                  # MySQL connector JAR
```

## Prerequisites

- Java JDK 8 or higher
- Eclipse IDE for Enterprise Java and Web Developers
- Apache Tomcat 9.0 or higher
- MySQL Server 5.7 or higher
- MySQL Connector/J (mysql-connector-java-8.0.x.jar)

## Database Setup

1. Create a MySQL database:
```sql
CREATE DATABASE techskillmatrix;
USE techskillmatrix;
```

2. Create the required tables:
```sql
-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- User skills table
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
   - DB_URL: `jdbc:mysql://localhost:3306/techskillmatrix`
   - DB_USERNAME: Your MySQL username (default: `root`)
   - DB_PASSWORD: Your MySQL password

## Eclipse Setup Instructions

### Step 1: Import Project into Eclipse

1. Open Eclipse IDE
2. Go to **File** → **Import**
3. Select **General** → **Existing Projects into Workspace**
4. Click **Next**
5. Browse to the `TechSkillMatrix` folder
6. Ensure the project is checked
7. Click **Finish**

### Step 2: Convert to Dynamic Web Project

1. Right-click on the project in Project Explorer
2. Select **Properties**
3. Go to **Project Facets**
4. Check **Dynamic Web Module** (version 4.0 or higher)
5. Check **Java** (version 1.8 or higher)
6. Click **Apply and Close**

### Step 3: Configure Build Path

1. Right-click on the project → **Properties**
2. Go to **Java Build Path** → **Source**
3. Ensure `src` is listed as a source folder
4. Go to **Libraries** tab
5. Click **Add External JARs...**
6. Navigate to and select `mysql-connector-java-8.0.x.jar` (download if needed)
7. Click **OK**

### Step 4: Add MySQL Connector to WebContent/lib

1. Download MySQL Connector/J from: https://dev.mysql.com/downloads/connector/j/
2. Copy `mysql-connector-java-8.0.x.jar` to `WebContent/WEB-INF/lib/` folder
3. If `lib` folder doesn't exist, create it: `WebContent/WEB-INF/lib/`

### Step 5: Configure Tomcat Server

1. In Eclipse, go to **Window** → **Show View** → **Servers**
2. Right-click in the Servers view → **New** → **Server**
3. Select **Apache** → **Tomcat v9.0 Server** (or your version)
4. Browse to your Tomcat installation directory
5. Click **Next** → **Finish**

### Step 6: Add Project to Tomcat

1. Right-click on the Tomcat server in Servers view
2. Select **Add and Remove...**
3. Move `TechSkillMatrix` from Available to Configured
4. Click **Finish**

### Step 7: Run the Application

1. Right-click on the Tomcat server
2. Select **Start**
3. Wait for server to start
4. Open browser and navigate to: `http://localhost:8080/TechSkillMatrix/`

## Features

- **User Registration**: New users can create accounts
- **User Login**: Secure authentication system
- **Skill Assessment**: Take tests for various technical skills
- **Results Tracking**: View and track skill scores over time
- **Dashboard**: Centralized view of all features

## Default Pages

- **Login**: `http://localhost:8080/TechSkillMatrix/index.jsp`
- **Signup**: `http://localhost:8080/TechSkillMatrix/signup.jsp`
- **Dashboard**: `http://localhost:8080/TechSkillMatrix/dashboard.jsp`
- **Test**: `http://localhost:8080/TechSkillMatrix/test.jsp`
- **Results**: `http://localhost:8080/TechSkillMatrix/result.jsp`

## Troubleshooting

### Common Issues

1. **ClassNotFoundException for MySQL Driver**
   - Ensure `mysql-connector-java-8.0.x.jar` is in `WebContent/WEB-INF/lib/`
   - Refresh the project in Eclipse
   - Restart Tomcat server

2. **Database Connection Error**
   - Verify MySQL server is running
   - Check database credentials in `DatabaseConnection.java`
   - Ensure database and tables are created

3. **404 Error on Pages**
   - Verify project is added to Tomcat server
   - Check `web.xml` servlet mappings
   - Ensure `WebContent` folder structure is correct

4. **Session Issues**
   - Clear browser cookies
   - Restart Tomcat server

## Technology Stack

- **Backend**: Java Servlets
- **Frontend**: JSP (JavaServer Pages)
- **Database**: MySQL with JDBC
- **Server**: Apache Tomcat
- **IDE**: Eclipse IDE

## Notes

- This project uses plain JSP and Servlets (no Spring Framework)
- All servlet classes are in `com.techskillmatrix.servlets` package
- Database connection utility is in `com.techskillmatrix.db` package
- Session management is used for user authentication

