# Use the Maven OpenJDK image as the base image
FROM maven:3.8.1-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and the project source code
COPY pom.xml .
COPY src ./src
COPY .env .

# Package the application
RUN mvn clean package -DskipTests

# Use the official OpenJDK image to run the application
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Copy the packaged jar file from the build stage
COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar .
COPY --from=build /app/.env .

# Expose the port the application runs on
EXPOSE 8080

# Run the application with .env variables
ENTRYPOINT ["sh", "-c", "java -jar rihal-0.0.1-SNAPSHOT.jar"]
