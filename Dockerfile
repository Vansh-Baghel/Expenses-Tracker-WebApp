#———stage1 - jar builder ————-

# Maven image
FROM maven:3.8.3-openjdk-17 AS builder 

# Set working directory
WORKDIR /app

# Copy source code from local to container
COPY . /app

# Build application and skip test cases
RUN mvn clean install -DskipTests=true

#--------------------------------------
# Stage 2 - app build
#--------------------------------------

# Import specific version of java image
FROM openjdk:17-slim

WORKDIR /app 

# Copy build from stage 1 (builder)
COPY --from=builder /app/target/*.jar /app/target/expenseapp.jar

# Expose application port 
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "/app/target/expenseapp.jar"]
