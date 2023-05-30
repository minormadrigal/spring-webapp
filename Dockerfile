FROM openjdk:11-jre-slim

ADD target/service.jar service.jar

ENTRYPOINT ["java", "-jar", "service.jar"]
