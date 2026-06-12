# Project Bedrock – Production-Grade Microservices on AWS EKS

## Overview

Project Bedrock is the inaugural production Kubernetes deployment for InnovateMart Inc. The objective was to provision a secure Amazon EKS environment using Infrastructure as Code and deploy the AWS Retail Store Sample Application while integrating managed AWS services, observability, secure developer access, serverless components, and CI/CD automation.

## Project Information

* Company: InnovateMart Inc.
* Role: Cloud DevOps Engineer
* Project: Project Bedrock
* AWS Region: us-east-1
* EKS Cluster Name: project-bedrock-cluster
* Namespace: retail-app
* VPC Name: project-bedrock-vpc

---

## Architecture Summary

### Networking

* VPC: project-bedrock-vpc
* Region: us-east-1
* Public subnets across multiple Availability Zones
* Private subnets across multiple Availability Zones
* Internet Gateway
* NAT Gateway for outbound private subnet connectivity

### Kubernetes

* Amazon EKS Cluster: project-bedrock-cluster
* Namespace: retail-app
* AWS Load Balancer Controller
* Application Load Balancer (ALB) Ingress
* EKS Managed Node Group

### Data Layer

Managed AWS services replaced in-cluster databases:

#### Amazon RDS MySQL

* Database: retail_catalog

#### Amazon RDS PostgreSQL

* Database: retail_orders

#### Amazon DynamoDB

* Table: retail-carts-v2

### Event-Driven Services

#### Amazon S3

Bucket:
bedrock-assets-moshood-owolabi

#### AWS Lambda

Function:
bedrock-asset-processor

Flow:

1. User uploads an object to S3.
2. S3 Event Notification triggers Lambda.
3. Lambda logs the uploaded filename to CloudWatch Logs.

### Observability

EKS Control Plane Logging Enabled:

* API
* Audit
* Authenticator
* Controller Manager
* Scheduler

CloudWatch Log Groups:

* /aws/eks/project-bedrock-cluster/cluster
* /aws/lambda/bedrock-asset-processor

---

## Application Deployment

The AWS Retail Store Sample Application was deployed into the retail-app namespace.

Ingress was configured using AWS Load Balancer Controller and exposed through an Application Load Balancer.

Retail Store URL:

http://k8s-retailap-retailst-b0ad5bb5a6-1450657713.us-east-1.elb.amazonaws.com

---

## Secure Developer Access

IAM User:

bedrock-dev-view

Permissions:

* AWS ReadOnlyAccess
* S3 PutObject access to the assets bucket

Kubernetes Access:

Mapped to Kubernetes view role.

Verification:

kubectl get pods -n retail-app → Allowed

kubectl delete pod → Denied

---

## Terraform Remote State

Terraform state is stored remotely using Amazon S3.

Backend Configuration:

Bucket:
bedrock-terraform-state-moshood

Key:
project-bedrock/terraform.tfstate

Region:
us-east-1

This prevents local state dependency and supports CI/CD workflows.

---

## CI/CD Pipeline

GitHub Actions workflow file:

.github/workflows/terraform.yml

Pipeline Behaviour:

### Pull Requests

* Trigger Terraform Init
* Run Terraform Plan

### Push to Main

* Trigger Terraform Init
* Execute Terraform Apply

Infrastructure changes are automatically deployed after merging approved changes.

---

## Terraform Outputs

The repository includes grading.json generated from:

terraform output -json > grading.json

---

## Repository

GitHub Repository:

https://github.com/Msolabs/project-bedrock

---

## Cleanup

To avoid unnecessary AWS charges, destroy or stop resources when no longer required.

Examples:

terraform destroy

Delete ALBs, RDS instances, and EKS resources if the environment is no longer needed.

---

## Author

Moshood Owolabi

Project Bedrock Submission for InnovateMart Inc.
