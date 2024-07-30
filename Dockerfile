# Use the Maven image with OpenJDK 17 to build the application
FROM maven:3.8.1-openjdk-17 AS build

# Set the working directory to /app
WORKDIR /app

# Copy the pom.xml and the source code to the container
COPY pom.xml /app/
COPY src /app/src

# Package the application without running tests
RUN mvn clean package -DskipTests

# Use a lightweight OpenJDK image to run the application
FROM openjdk:17-jdk-slim

# Set the working directory to /app
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar /app/rihal-0.0.1-SNAPSHOT.jar

# Expose port 8080
EXPOSE 8080

# Set environment variables for MySQL connection
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3307/usersystem?useSSL=false&serverTimezone=UTC&createDatabaseIfNotExist=true&allowPublicKeyRetrieval=true
ENV SPRING_DATASOURCE_USERNAME=root
ENV SPRING_DATASOURCE_PASSWORD=root
ENV SPRING_JPA_HIBERNATE_DDL_AUTO=update
ENV SPRING_JPA_SHOW_SQL=true

# Run the Spring Boot application
ENTRYPOINT ["sh", "-c", "java -jar /app/rihal-0.0.1-SNAPSHOT.jar || (echo 'Application failed, sleeping indefinitely' && sleep infinity)"]
