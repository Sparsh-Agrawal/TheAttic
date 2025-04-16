# Simple Time Service – AWS EKS Deployment with Terraform & Helm

This project demonstrates how to:
- Build and containerize a Python-based application
- Push the Docker image to Docker Hub
- Provision an AWS EKS cluster using Terraform
- Deploy the app using Helm with a LoadBalancer service

---

##  Project Structure

```
TheAttic/
├── app/      # Python app with Dockerfile
│   ├── Dockerfile
│	└── main.py
├── terraform/
│	├── main.tf               # Main Terraform configuration
│	├── variables.tf          # Input variables
│	├── terraform.tfvars      # Variable values
│	├── outputs.tf            # Outputs like LoadBalancer DNS
│	└── helm/
│		└── simple-time-service/    # Helm chart for deployment
│			├── Chart.yaml
│			├──	values.yaml
│			└── templates/
│				├── deployment.yaml
│				└── service.yaml
└── README.md       # Project documentation
```

---

## Clone the repository

```bash
git clone https://github.com/Sparsh-Agrawal/TheAttic.git
cd TheAttic
```

## Task 1: Build and Push Docker Image

### Step 1: Navigate to the app directory

```bash
cd app
```

### Step 2: Build the Docker image

```bash
docker build -t sparshagrawal/simpletimeservice:latest .
```

> Replace `sparshagrawal` with your actual Docker Hub ID.

### Step 3: Run the image locally (for testing)

```bash
docker run -p 7000:7000 sparshagrawal/simpletimeservice:latest
```

###  Step 4: Push to Docker Hub

```bash
docker login
docker push sparshagrawal/simpletimeservice:latest
```

---

##  Task 2: Infrastructure and Deployment Using Terraform

### Step 1: Navigate to the terraform directory

```bash
cd terraform
```

###  Step 2: Configure AWS CLI Profile

```bash
aws configure --profile sparsh
```
> Replace `sparsh` with your desired profile name.

Set the values:
- AWS Access Key ID
- AWS Secret Access Key
- Default region: `ap-south-1`

This sets up credentials in `~/.aws/credentials`.

### Step 3: Update `main.tf` with AWS profile

In `main.tf`:

```hcl
provider "aws" {
  region  = var.region
  profile = "sparsh"
}
```
> Replace `sparsh` with your configured profile name in Step 2.

---

##  Step 4: Initialize Terraform

```bash
terraform init
```

### Step 5: Validate Configuration

```bash
terraform validate
```

###  Step 6: Review Changes

```bash
terraform plan
```

###  Step 7: Deploy Infrastructure

```bash
terraform apply
```

Confirm with `yes` when prompted.

---

##  Step 8: Access the Application

After a successful deploy, get the LoadBalancer endpoint:

```bash
terraform output load_balancer_hostname
```

Then access the app:

```bash
curl http://<load-balancer-hostname>
```

---

##  Destroy Resources

```bash
terraform destroy
```

---

##  Purpose of Key Files

| File/Folder                     | Purpose                                                                 |
|-------------------------------|-------------------------------------------------------------------------|
| `main.tf`                      | Creates VPC, EKS cluster, Helm release                                 |
| `variables.tf`                 | Declares input variables                                               |
| `terraform.tfvars`             | Sets actual values for input variables                                 |
| `outputs.tf`                   | Displays output values like LoadBalancer hostname                      |
| `helm/simple-time-service`     | Contains Helm chart for the Python app                                     |
| `app`          | Python app source and Dockerfile                                           |

---

##  Helm Chart Highlights

- **Service Port**: Exposes app on port `80` (default) with `targetPort: 7000`
- **Replicas**: 2 (can be customized via `values.yaml`)
- **Image**: Comes from Docker Hub (set via Terraform variable)

---

## Notes

- Helm values can be customized in `values.yaml`
- Docker image can be configured via Terraform `docker_image` variable
- LoadBalancer allows access on port 80 without needing to specify 7000

---

