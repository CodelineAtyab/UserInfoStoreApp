# Build the application using Maven and OpenJDK 17 & setting the working diroctory
FROM maven:3.8.1-openjdk-17 AS build

WORKDIR /app

# using the provided files (e.g. pom.xml)
COPY pom.xml .

COPY src ./src

# -DskipTests to skip tests
RUN mvn clean package -DskipTests

# contents of the target
RUN ls -l target/

# Create image
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar app.jar

# Expose
EXPOSE 8080

# Define the entry point
ENTRYPOINT ["java", "-jar", "app.jar"]