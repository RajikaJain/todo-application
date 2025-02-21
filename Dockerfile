# write your Docker file code here
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /home/labuser/Desktop/Project

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM openjdk:17-jdk-slim

WORKDIR /home/labuser/Desktop/Project

COPY --from=builder /home/labuser/Desktop/Project/target/*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java","-jar","app.jar"]

