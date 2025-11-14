FROM gradle:jdk-25-and-25-alpine AS build
WORKDIR /app
COPY build.gradle.kts .
COPY gradlew .
COPY gradle gradle
COPY src src
RUN ./gradlew build

FROM httpd:latest AS dni
WORKDIR /app
RUN rm -rf /usr/local/apache2/htdocs

RUN echo 'Include conf/httpd-auth.conf' >> /usr/local/apache2/conf/httpd.conf


FROM eclipse-temurin:25-jre-alpine AS run
COPY --from=build /app/build/libs/*SNAPSHOT.jar /app/helloWorld.jar
ENTRYPOINT ["java","-jar","/app/helloWorld.jar"]
