FROM openjdk:11
EXPOSE 8080
ARG JAR_FILE=target/*.jar
USER k8s-pipeline
RUN groupadd pipeline && adduser k8s-pipeline pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]
