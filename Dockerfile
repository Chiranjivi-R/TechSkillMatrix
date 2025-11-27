FROM tomcat:9.0-jdk11-temurin

# Remove default ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT*

# Copy WAR
COPY target/TechSkillMatrix.war /usr/local/tomcat/webapps/ROOT.war

# Force Tomcat to unpack WAR & load app as ROOT
ENV JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 \
              -Dorg.apache.catalina.startup.ExpandWar=true \
              -Dorg.apache.catalina.startup.ContextConfig.jarsToSkip=NONE"

EXPOSE 8080
CMD ["catalina.sh", "run"]
