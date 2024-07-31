# Use Maven to build the application
FROM maven:3.8.1-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and install dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Use OpenJDK for running the application
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the Maven build stage
COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar /app/rihal-0.0.1-SNAPSHOT.jar

# Expose the application port
EXPOSE 8080

# Set environment variables
ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3307/usersystem?useSSL=false&serverTimezone=UTC&createDatabaseIfNotExist=true&allowPublicKeyRetrieval=true \
    SPRING_DATASOURCE_USERNAME=root \
    SPRING_DATASOURCE_PASSWORD=root \
    SPRING_JPA_HIBERNATE_DDL_AUTO=update \
    SPRING_JPA_SHOW_SQL=true

# Define the command to run the application
CMD ["java", "-jar", "rihal-0.0.1-SNAPSHOT.jar"]
