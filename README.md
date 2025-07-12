# Scalable, Highly Available and Secure AWS Infrastructure
- This project showcases a **Sclalable, Highly Available and Secure Cloud Infrastructure** built on **AWS** using **Terraform** (First Method) and **AWS Management Console** (Second Method). 
- It utilizes various AWS services such as Route 53, VPC, EC2, RDS, ALB, Auto Scaling, WAF, Cloudwatch, SNS and more to create a robust infrastructure.  
- It implements a **two-tier architecture**—a scalable web tier using EC2 Auto Scaling, and a data tier using Amazon RDS (MySQL). 
- A Flask web app is deployed to demonstrate the functionality of the infrastructure.


## 🌐 Architecture Overview

- The infrastructure is deployed in a single VPC spanning  **two Availability Zones (AZs)** within the **AWS Region** to ensure high availability and fault tolerance.
- It includes public subnets (for ALB, NAT Gateway, Bastion Host) and private subnets (for EC2 Auto Scaling instances and RDS). 
- Traffic flows securely from Route 53 → ALB → private EC2 instances → RDS instance, with outbound internet access via the NAT Gateway.

![Architecture Diagram](./Images/AWS%20Scalable%20Architecture.png)

##  key Components

| Component | Purpose |
|----------|---------|
| **Route 53** | Acts as the DNS service to route user traffic to the Application Load Balancer (ALB) |
| **VPC** | Custom Virtual Private Cloud with public and private subnets across two AZ for high availability |
| **Public Subnets** | Hosts the ALB, NAT Gateway, and Bastion Host for secure SSH access |
| **Private Subnets** | Hosts EC2 instances in an Auto Scaling Group and Amazon RDS database |
| **Internet Gateway (IGW)** | Provides internet access to public subnets |
| **NAT Gateway** | Allows EC2 instances in private subnets to access the internet (e.g., for package installs) |
| **Application Load Balancer (ALB)** | Public-facing, distributes traffic to EC2 instances in private subnets and performs health checks |
| **Target Groups** | Groups EC2 instances for the ALB to route traffic to |
| **Auto Scaling Group (ASG)** | Automatically adjusts the number of EC2 instances based on demand, ensuring scalability and fault tolerance |
| **Launch Template** | Defines the configuration for EC2 instances in the ASG, including AMI, instance type, security group, and key pair |
| **AMI** | Custom Amazon Machine Image created from a pre-configured EC2 instance with the Flask app installed |
| **Flask App** | CRUD application running as systemd service on EC2 instances, retrieves database credentials from AWS Secrets Manager and connects to RDS |
| **EC2 Instances** | Act as the web server (Hosts the Flask web app, launched via AMI) |
| **Amazon RDS (MySQL, Multi-AZ)** | Managed relational database with automatic failover across AZs |
| **AWS WAF** | Attached to the ALB for additional protection against commmon web attacks |
| **AWS Secrets Manager** | Secure storage of database credentials used by the Flask app |
| **Bastion Host** |  Jump server in a public subnet for secure SSH access to private EC2 instances |
| **IAM Roles & Policies** |  Secure access control for EC2, RDS, and monitoring services, ensures least-privilege access |
| **CloudWatch** | Monitors metrics and triggers alarms on failures of any ALB targets |
| **SNS** | Sends notifications (email alerts) to DevOps engineers upon alarm triggers |

---

## Implementation Steps using Terraform (First Method)

The entire infrastructure is provisioned using Terraform with modular structure for better organization and reusability.


### 📦 Modules

- `network`: Custom VPC, subnets (public/private), route tables, IGW, and NAT Gateway
- `security`: Security groups for ALB, EC2, RDS, and Bastion Host
- `rds`: RDS MySQL instance (Multi-AZ)
- `secrets`: AWS Secrets Manager for storing RDS credentials
- `bastion`: Bastion Host for secure SSH access
- `alb`: Application Load Balancer, Target Groups, Listener, and WAF
- `asg`: Auto Scaling group, Launch Template, and Auto Scaling Policies
- `monitoring`: Cloudwatch alarms, SNS topic, and subscription

### 📂 File Structure

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── alb/
│   ├── asg/
│   ├── bastion/
│   ├── monitoring/
│   ├── network/
│   ├── rds/
│   ├── secrets/
│   └── security/
```

---

## Deployment Steps
 
### Prerequisites
- AWS account with necessary permissions to create resources.
- Terraform installed on your local machine.
- AWS CLI configured with your credentials.
- An SSH key pair created for accessing the Bastion Host.
- Change the `key_name` variable in modules/asg/variables.tf to your SSH key pair name.
- Create an AMI from a temporary EC2 instance with your application installed and configured.
- Change the `flask_ami_id` variable in modules/asg/variables.tf to the AMI ID you created.
  
### Steps to Deploy
1. Clone the repo and run
   ```bash
   terraform init
   ```
2. Set environment variables for RDS credentials
      ```bash
   export TF_VAR_db_username="your_db_username" # Set your RDS username
   export TF_VAR_db_password="your_db_password" # Set your RDS password
   ```
   Or enter value when prompted during `terraform apply`

   Or you can create a `terraform.tfvars` file that contains the varaibles

3. Run the following commands to deploy the infrastructure
   ```bash
   terraform plan # Review the plan before applying
   terraform apply
   ```

4. Wait for the resources to be created. After successful creation, you will see the ALB DNS name in the output, use it to access the Flask app from the browser.
[![Flask App](./Images/Flask%20App.png)](./Images/Flask%20App.png)

5. Destroy the infrastructure when done
    ```bash
    terraform destroy 
    ```

## Implementation Steps using AWS Management Console (Second Method)

### 1️⃣ Networking Setup
- Created a custom VPC across two Availability Zones.
- Created **public subnets** for ALB, NAT Gateway, and Bastion Host.
- Created **private subnets** for EC2 app servers and RDS database.
- Attached an **Internet Gateway (IGW)** to the VPC for external connectivity.
- Created a **NAT Gateway** in a public subnet to enable private EC2 instances to access the internet securely.
- Configured route tables to ensure proper traffic flow between components.
![Network Diagram](./Images/Network%20Diagram.png)

### 2️⃣ Security Setup
- Created security groups:
  - **ALB SG**: allows inbound HTTP (port 80) from the internet.
  - **EC2 SG**: allows HTTP only from ALB SG.
  - **RDS SG**: allows MySQL (port 3306) only from EC2 SG.
  - **Bastion SG**: allows SSH (port 22) from trusted IPs.
- Created an **IAM role** for EC2 instances to access AWS Secrets Manager for DB credentials.

### 3️⃣ Database Setup
- Deployed an **Amazon RDS MySQL (Multi-AZ)** instance in private subnets.
![RDS](./Images/RDS.png)
- Attached **RDS SG** to allow access from EC2 instances.
- Stored RDS credentials securely in **AWS Secrets Manager**.
![Secrets Manager](./Images/Secrets%20Manager.png)

### 4️⃣ App Server Preparation
- Launched a temporary EC2 instance in a private subnet.
- Installed Flask app, Gunicorn, and configured `systemd` service for auto-start on boot.
- Configured the app to retrieve database credentials from **AWS Secrets Manager**.
- Tested the app locally on port 80.
- Created an **AMI** from this EC2 instance to be used in **ASG Launch Template**.
![AMI](./Images/AMI.png)

### 5️⃣ Auto Scaling + ALB
- Created a **Launch Template** using the custom **AMI**.
- Configured the template with:
  - Instance type: `t3.micro`
  - Security group: **EC2 SG**
  - Key pair for SSH access from the Bastion Host.
- Set up an **Auto Scaling Group (ASG)** using this template, with private subnets.
- Target Scaling Policy to scale out/in based on average CPU utilization (target 70%).
![Target Scaling](./Images/Target%20Scaling.png)
- Deployed an **Application Load Balancer (ALB)** in public subnets across two AZs.
- Configured ALB with:
  - HTTP listener on port 80.
  - Target group linked to the ASG.
  - Health checks on `/` to monitor instance health.
  
  ![ALB](./Images/ALB.png)
  ![ALB with ASG](./Images/ALB%20with%20ASG.png)

### 6️⃣ Security Hardening
- Attached **AWS WAF** to ALB with rules to block common web attacks (SQL injection, XSS).
![WAF](./Images/WAF.png)

### 7️⃣ Bastion Host
- Deployed a **Bastion Host** in a public subnet for secure SSH access to private EC2 instances.

### 8️⃣ Monitoring + Notifications
- Configured **CloudWatch alarm** to trigger when the ALB has unhealthy hosts.
![CloudWatch Alarm](./Images/Cloudwatch%20Alarm.png)
- Set up an **SNS topic** and subscribed an email address for receiving alerts.
![SNS](./Images/SNS.png)
- Configured the alarm to send notifications to the SNS topic when triggered.
![Alarm Trigger](./Images/Alarm%20Trigger.png)


## 🔐 Security Considerations

- Web servers are in private subnets — not directly accessible from the internet.
- SSH access is restricted via a **Bastion Host** in a public subnet.
- **Security Groups** are configured to allow traffic only from trusted sources.
- **IAM roles** applied to control access to AWS services with least-privilege permissions.
- **AWS WAF** provides an additional layer of security against common web attacks.
- **AWS Secrets Manager** is used to securely store and manage database credentials.

---

This project was developed during my learning journey to prepare for **AWS Certified Solutions Architect - Associate** certification. Feel free to reach out if you have any questions or suggestions for improvements 
[LinkedIn](https://www.linkedin.com/in/moaz-farrag) - [Email](mailto:moaz.farrag@outlook.com)

