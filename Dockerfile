FROM tomcat:8.5.82-jdk8-openjdk-slim-buster

ARG WAR_FILE
ARG CONTEXT

COPY ${WAR_FILE} /usr/local/tomcat/webapps/${CONTEXT}.war