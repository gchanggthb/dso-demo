FROM maven:3.9.11-eclipse-temurin-21 AS BUILD
WORKDIR /app
COPY .  .
RUN mvn package -DskipTests


FROM eclipse-temurin:21.0.9_10-jdk-ubi9-minimal as RUN
WORKDIR /run
COPY --from=BUILD /app/target/demo-0.0.1-SNAPSHOT.jar demo.jar

ARG USER=devops
ENV HOME /home/$USER
RUN adduser $USER && \ 
    chown $USER:$USER /run/demo.jar

HEALTHCHECK --interval=30s --timeout=10s --retries=2 --start-period=20s \
CMD curl -f http://localhost:8080/ || exit 1

USER $USER

EXPOSE 8080
CMD java  -jar /run/demo.jar

