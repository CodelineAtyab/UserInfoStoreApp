FROM maven:3.8.1-openjdk-17 AS build

WORKDIR /app

COPY ./app/src ./src
COPY ./app/LICENSE .
COPY ./app/mvnw.cmd .
COPY ./app/mvnw .
COPY ./app/pom.xml .


RUN mvn clean package -DskipTests

WORKDIR /app/target




CMD ["java", "-jar", "rihal-0.0.1-SNAPSHOT.jar"]
