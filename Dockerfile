FROM openjdk:11
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN groupadd pipeline 
RUN useradd -ms /bin/bash k8s-pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]
