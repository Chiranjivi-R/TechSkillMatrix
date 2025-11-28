#################### 1) BUILD WAR ####################
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy full project (source code only)
COPY . .

# Build WAR → output goes to /app/target/*.war
RUN mvn -DskipTests=true package


#################### 2) RUN IN TOMCAT ####################
FROM tomcat:9.0-jdk17-temurin

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/ROOT*

# Copy generated WAR & deploy as ROOT
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
