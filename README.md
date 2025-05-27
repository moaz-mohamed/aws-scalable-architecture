# Scalable and Highly Available AWS Architecture

This repository documents a highly available, secure, and scalable AWS architecture designed for hosting web applications with fault tolerance, monitoring, and automation.

---

## 🌐 Architecture Overview

The architecture is deployed in **AWS Region `eu-central-1`** and spans **two Availability Zones (AZs)** to ensure high availability and fault tolerance.

---

## 🧩 Key Components

### 1. **Route 53**
- Acts as the DNS service to route user traffic to the Application Load Balancer (ALB).
- Supports routing policies like weighted, latency, and failover.

### 2. **AWS WAF (Web Application Firewall)**
- Additional protection against commmon web attacks using specified criteria.
- Attached to the ALB for filtering and blocking malicious traffic.

### 3. **Internet Gateway (IGW)**
- Provides internet access to public subnets.
- Allows users to reach the ALB and Bastion Host.

### 4. **Application Load Balancer (ALB)**
- Public-facing ALB distributes incoming web traffic to backend EC2 instances.
- Supports path-based routing and health checks.

### 5. **IAM Roles and Policies**
- Secure access control for EC2, RDS, and monitoring services.
- Ensures least-privilege principle for automation and user access.

### 6. **Public Subnets**
- **Bastion Host** (for secure SSH access to private EC2s)
- **NAT Gateway** (to enable outbound internet access for EC2s in private subnets)

### 7. **Private Subnets**
- **Web Servers** (EC2 instances in Auto Scaling group)
- **Amazon RDS** (primary and standby database instances)

### 8. **Auto Scaling Group**
- Ensures scalability and high availability of web servers.
- Automatically adjusts the number of EC2 instances based on demand.

### 9. **Amazon RDS (with Multi-AZ)**
- Provides a managed relational database with automatic failover.
- **Primary DB instance** and **Standby instance** are in separate AZs for HA.

### 10. **CloudWatch & SNS**
- **CloudWatch** monitors metrics and triggers alarms on failures or performance issues.
- **SNS** sends notifications (email alerts) to DevOps engineers upon alarm triggers.

---

## 🔄 Request Flow (Workflow)

1. **User requests** are routed through **Route 53** to the **WAF-protected ALB**.
2. **AWS WAF** filters out malicious requests before reaching the ALB.
3. **ALB** forwards valid traffic to EC2 **Web Servers** in private subnets.
4. Web servers may query the **Amazon RDS** database in private subnets.
5. **CloudWatch** monitors system health and triggers alarms.
6. **SNS** sends alerts to subscribed DevOps Egnineers via email.
7. **Auto Scaling** increases or decreases EC2 capacity based on demand.
8. **NAT Gateway** provides secure outbound internet access for private instances.
9. **Bastion Host** is used to securely SSH into private EC2s.
10. **IAM Roles** manage secure access to AWS services for automation and users.

---

## 🔐 Security Considerations

- Web servers are in private subnets — not directly accessible from the internet.
- SSH access is restricted via a **Bastion Host** in a public subnet.
- **Security Groups** are configured to allow traffic only from trusted sources.
- **IAM roles** applied to control access to AWS services.

---

## 📌 Benefits

- High Availability through multi-AZ deployment
- Scalability via Auto Scaling Group
- Secure architecture with private subnets and a bastion host
- Automated monitoring and alerting via CloudWatch and SNS
- Managed and fault-tolerant database using Amazon RDS Multi-AZ

