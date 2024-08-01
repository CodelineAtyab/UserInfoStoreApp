#Adding required system
FROM maven:3.8.1-openjdk-17 AS build
 
# Set the working directory
WORKDIR /app
 
# Copy the pom.xml and install dependencies
COPY pom.xml /app/
COPY src /app/src
 
#Run command
RUN mvn clean package -DskipTests

# contents of the target
RUN ls -l target/
 
# Use OpenJDK for running the application
FROM openjdk:17-jdk-slim
 
# Set the working directory
WORKDIR /app
 
# Copy the built JAR file from the Maven build stage
COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar rihal-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["sh", "-c","java", "-jar", "rihal-0.0.1-SNAPSHOT.jar"]
 
# Expose the application port
EXPOSE 8080