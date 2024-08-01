# Stage 1: Build stage
FROM maven:3.8.1-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src 
RUN mvn clean package -DskipTests

# Stage 2: Run stage
FROM openjdk:17-jdk-slim 
WORKDIR /app
COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

# Correct CMD syntax
CMD ["java", "-jar", "app.jar"]
