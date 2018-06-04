# BUILD PHASE
FROM maven:3.5-jdk-8

WORKDIR /build
ADD .   /build/

RUN mvn clean package -Dmaven.test.skip=true \
 && cp target/my-api.jar ./my-api.jar

# RUN PHASE
FROM openjdk:8-jre-alpine

COPY --from=0 /build/my-api.jar ./my-api/

WORKDIR /my-api

CMD ["java", "-jar", "my-api.jar"]
