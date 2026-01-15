# ECS Terraform Infrastructure

## Overview
This repository contains Terraform configurations for deploying and managing Amazon ECS (Elastic Container Service) infrastructure.

## Prerequisites
- Terraform >= 1.0
- AWS CLI configured with credentials
- Docker (for container images)

## Project Structure
```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── modules/
```

## Usage
1. Initialize Terraform:
    ```bash
    terraform init
    ```

2. Plan the deployment:
    ```bash
    terraform plan
    ```

3. Apply the configuration:
    ```bash
    terraform apply
    ```

## Configuration
Update `terraform.tfvars` with your environment-specific values.

## Outputs
Key outputs including load balancer DNS, ECS cluster name, and service endpoints will be displayed after deployment.

## Contributing
Follow standard Git workflow for changes.

## License
