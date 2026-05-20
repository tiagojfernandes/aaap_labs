# Backend Configuration for Terraform State

# Uncomment and configure for remote state storage in Azure Storage
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "rg-terraform-state"
#     storage_account_name = "stterraformstate"
#     container_name       = "tfstate"
#     key                  = "mc-lab-dev.tfstate"
#   }
# }

# Using local backend for development
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
