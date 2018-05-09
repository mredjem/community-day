# BUILD PHASE
FROM maven:3.5-jdk-8
WORKDIR /app
ADD .   /app/
RUN ["mvn", "package", "-Dmaven.test.skip=true"]

# RUN PHASE
FROM openjdk:8-jre-alpine
COPY --from=0 /app/my-app.jar ./my-app/
WORKDIR /my-app
CMD ["java", "-jar", "my-app.jar"]
