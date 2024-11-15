FROM maven:3.8.5-openjdk-17-slim AS MAVEN_BUILD

LABEL maintainer=""

WORKDIR /build/

COPY pom.xml /build/
COPY src /build/src/

RUN mvn clean package -DskipTests


FROM adoptopenjdk/openjdk11:alpine-jre

# ARG JAR_FILE=target/blog.jar

ARG PROFILE=dev

WORKDIR /opt/app

COPY opentelemetry-javaagent.jar /opt/app/opentelemetry-javaagent.jar

COPY --from=MAVEN_BUILD /build/target/*.jar blog.jar

ENV OTEL_SERVICE_NAME=zerofiltre-backend-opeyemi19-${PROFILE}

COPY entrypoint.sh entrypoint.sh

RUN chmod 755 entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]