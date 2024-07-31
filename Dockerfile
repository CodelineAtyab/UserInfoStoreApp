
FROM maven:3.8.1-openjdk-17 AS build

WORKDIR /app


COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests


FROM openjdk:17-jdk-slim


WORKDIR /app


COPY --from=build /app/target/rihal-0.0.1-SNAPSHOT.jar /app/rihal-0.0.1-SNAPSHOT.jar


EXPOSE 8080


ENV SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3307/usersystem?useSSL=false&serverTimezone=UTC&createDatabaseIfNotExist=true&allowPublicKeyRetrieval=true \
    SPRING_DATASOURCE_USERNAME=root \
    SPRING_DATASOURCE_PASSWORD=root \
    SPRING_JPA_HIBERNATE_DDL_AUTO=update \
    SPRING_JPA_SHOW_SQL=true


CMD ["java", "-jar", "rihal-0.0.1-SNAPSHOT.jar"]
