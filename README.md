# aaap_labs

AME Labs for technologies Azure Automation, Azure Update Manager, Azure Machine Configuration and Arc Enabled for Servers.

## Structure

```
.
├── main.tf            # Root module / resources
├── providers.tf       # Provider configuration
├── variables.tf       # Input variables
├── outputs.tf         # Output values
├── terraform.tfvars.example
└── .gitignore
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.6
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (authenticated via `az login`)

## Usage

```bash
terraform init
terraform plan
terraform apply
```
