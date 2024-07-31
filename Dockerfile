# Create image for the application
FROM maven:3.8.1-openjdk-17 AS build

#Set the working directory
WORKDIR /app

#Copy pom.xml to current working directory
COPY pom.xml .
RUN mvn dependency:go-offline -B 

#Copy the source code into the source of the current
COPY src ./src
RUN mvn clean package -DskipTests

# Use the Maven image as the runtime image 
FROM maven:3.8.1-openjdk-17 

# Set the working directory for the maven 
WORKDIR /app

COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]