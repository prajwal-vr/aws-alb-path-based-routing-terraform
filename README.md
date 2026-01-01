# aws-alb-path-based-routing-terraform
AWS lab project implementing path-based routing with Application Load Balancer, EC2 instances, S3, and modular Terraform

# AWS Application Load Balancer with Path-Based Routing (Terraform)

![Architecture Diagram](./docs/screenshots/Architecture.png)

**Path-Based Routing Architecture** – ALB routes `/red*` to Red instance and `/blue*` to Blue instance.

## Project Overview

This repository automates the deployment of a load-balanced web application using **AWS Application Load Balancer (ALB)** with **path-based routing**, based on the **Digital Cloud Training** lab: *Load Balanced Architecture with Advanced Request Routing*.

**Key Features Implemented**:
- Two EC2 instances ("Red" and "Blue") serving different custom websites
- Static assets stored in S3 and pulled during instance boot via user data
- ALB with listener rules:
  - `/red*` → Red target group
  - `/blue*` → Blue target group
  - Default → 404 response
- Fully Infrastructure-as-Code using **modular Terraform**
- Uses **default VPC** for simplicity and cost efficiency

### Blue page

![Blue page served via ALB](./docs/screenshots/Blue%20Path.png)

URL used: `http://<alb-dns-name>/blue`

### Red page

![Red page served via ALB](./docs/screenshots/Red%20Path.png)

URL used: `http://<alb-dns-name>/red`

## Prerequisites

- AWS Free Tier account
- Terraform installed
- AWS CLI configured (`aws configure`)

## Deployment

```bash
git clone https://github.com/prajwal-vr/aws-alb-path-based-routing-terraform.git
cd aws-alb-path-based-routing-terraform

terraform init
terraform plan
terraform apply
