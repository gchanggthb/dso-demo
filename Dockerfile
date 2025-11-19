FROM maven:3.9.11-eclipse-temurin-21 AS BUILD
WORKDIR /app
COPY .  .
RUN mvn package -DskipTests


FROM eclipse-temurin:21 as RUN
WORKDIR /run
COPY --from=BUILD /app/target/demo-0.0.1-SNAPSHOT.jar demo.jar
EXPOSE 8080
CMD java  -jar /run/demo.jar

