FROM openjdk:11
MAINTAINER ravindra
EXPOSE 8080
COPY target/devops-integration.jar devops-integration.jar
ENTRYPOINT ["java","-jar","/devops-integration.jar"] 