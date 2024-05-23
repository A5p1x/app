# PetProject
## Overview
This project is designed to demonstrate the CI/CD process of deploying an application to an AWS environment.

### Technology Stack
- AWS: Cloud platform used for hosting and infrastructure management.
- Terraform: Infrastructure as Code (IaC) tool for provisioning and managing AWS resources.
- GitHub Actions: CI/CD tool used for automating build, test, and deployment processes.
- Docker: Containerization platform used for packaging and running the application.
- Bash / Python: Scripting languages used for automation and application development.
### Features
* Flask API: A simple Flask application (app.py) with two endpoints (/red and /green) representing the "Ramzor" (traffic light) API.
* CI/CD Pipeline:
* Build and Test: GitHub Actions workflows are configured to build and test the Docker image.
* Docker Image Deployment: The Docker image is uploaded to AWS ECR (Elastic Container Registry).
* Infrastructure Deployment: Terraform is used within GitHub Actions to provision AWS resources, including:
-- IAM roles and permissions
-- EC2 instance
-- Security groups and networking
* Application Deployment: The EC2 instance downloads the Docker image from ECR and runs the application, making it accessible on port 80.
- 
This version provides a clear and concise overview of the project, highlighting the technology stack, key features, and the overall workflow of the CI/CD process.
