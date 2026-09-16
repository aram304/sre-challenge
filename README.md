# Warpnet SRE Challenge

A technical challenge for Warpnet to demonstrate my current skills in platform engineering

The goal is to deploy a Python application in both a traditional VM environment and a Kubernetes environment.

## Architecture

The infrastructure consists of two Ubuntu virtual machines hosted on Proxmox:


- **Traditional environment:** Ubuntu, Python Flask and SQLite.
- **Kubernetes environment:** Ubuntu, Minikube, Docker, Flask and SQLite.

Both environments run the same application.

**Deployment workflow:**

GitHub Actions -> Terraform -> Proxmox -> Ansible -> Application

Terraform provisions the VMs using a predefined template and Cloud-init. It also generates an Ansible inventory containing the provisioned IP addresses.

Ansible then configures both machines, installs the required dependencies and deploys the application.

## Technology Stack

- **Terraform:** Infrastructure provisioning.
- **Proxmox:** Virtualization platform.
- **Cloud-init:** Initial VM configuration.
- **Ansible:** Configuration management.
- **GitHub Actions:** CI/CD automation.
- **Docker:** Application containerization.
- **Minikube:** Local Kubernetes cluster.
- **Flask & SQLite:** Application and database.
- **HCP Terraform:** Remote Terraform state.

## CI/CD Pipeline

Three GitHub Actions workflows are configured to run on a self-hosted runner.

**1. Build**

Manually triggered using `workflow_dispatch`.

- Provision two virtual machines using Terraform.
- Generate the Ansible inventory.
- Configure both environments with Ansible.
- Deploy the traditional and Kubernetes applications.

**2. Application Update**

Triggered automatically by a push to `feature/app`.

Runs an Ansible playbook to update the applications without reprovisioning the infrastructure.

**3. Destroy**

Manually triggered to remove the Terraform-managed infrastructure.

## Security

The project includes several security measures:

- Ansible Vault for encrypted configuration variables.
- GitHub Actions secrets for deployment credentials.
- Kubernetes Secrets for the application secret.
- Bcrypt for password hashing.
- Remote Terraform state stored in HCP Terraform.
- Firewall rules in pfsense restrict access to the web servers to VPN-connected clients only.

For a future production environment, a reverse proxy should be implemented as a controlled entry point for incoming traffic.

## Observability & Reliability

Both application versions provide a `/health` endpoint.

Health-check scripts are scheduled through cron every five minutes and are configured to send an email when an application returns an unexpected HTTP status.

Additional components include:

- Systemd services for application and Minikube startup.
- Kubernetes Dashboard service.
- Application logging and authentication-event logging.
- Persistent SQLite storage using a host directory or Kubernetes PVC.

## Deployment

The initial deployment can be started through:

`GitHub → Actions → Deploy infrastructure and configure hosts → Run workflow`

Alternatively, Terraform and Ansible can be executed manually after configuring the required credentials and environment:

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply

cd ansible
ansible-playbook -i inventories/inventory.ini playbooks/playbook.yaml --ask-vault-pass
```

Prerequisites include access to Proxmox, a prepared Ubuntu Cloud-init template, a configured HCP Terraform workspace, deployment credentials and SSH connectivity.

## Repository Structure

The repository is organized into separate directories for CI/CD, infrastructure provisioning and configuration management. Ansible contains the deployment configurations for both the traditional VM and Kubernetes environments.

### Directory Tree

```text
sre-challenge/
│
├── .github/
│   └── workflows/
│
├── ansible/
│   ├── inventories/
│   └── playbooks/
│       ├── group_vars/
│       │   └── all/
│       └── roles/
│           ├── minikube-webapp/
│           │   ├── files/
│           │   │   ├── app/
│           │   │   │   └── templates/
│           │   │   ├── docker/
│           │   │   ├── kubernetes/
│           │   │   └── scripts/
│           │   ├── handlers/
│           │   └── tasks/
│           ├── sqlite/
│           │   ├── files/
│           │   └── tasks/
│           └── traditional-webapp/
│               ├── files/
│               │   ├── app/
│               │   │   └── templates/
│               │   └── scripts/
│               ├── handlers/
│               └── tasks/
│
└── terraform/
```

### Directory Overview

* **.github:** Contains GitHub Actions workflows for deployment automation.
* **ansible:** Contains inventories, configuration variables and playbooks used to configure and deploy both environments.
* **minikube-webapp:** Configures Minikube and deploys the containerized application using Kubernetes manifests.
* **sqlite:** Configures the SQLite database
* **traditional-webapp:** Configures and deploys the Flask application and its required services on the traditional VM.
* **terraform:** Contains the infrastructure configuration used to provision virtual machines on Proxmox.


## Conclusion

This project demonstrates how Infrastructure as Code, configuration management and CI/CD can work together to automate the deployment and management of applications across traditional and Kubernetes environments.

The focus is on automation, reproducibility, security and operational reliability.
