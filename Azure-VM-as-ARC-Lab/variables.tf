variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "user_timezone" {
  description = "User's timezone for auto-shutdown configuration"
  type        = string
  default     = "UTC"
}

variable "admin_username" {
  description = "Common admin username for all VMs and VMSS"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Common admin password for all VMs and VMSS"
  type        = string
  sensitive   = true
  # No default - will be provided via terraform.tfvars
}

# Windows VM ARC Configuration
variable "windows_arc_vm_name" {
  description = "Name of the Windows Virtual Machine"
  type        = string
  default     = "vm-arc-win-lab"
}

variable "windows_arc_vm_size" {
  description = "Size of the Windows VM"
  type        = string
  default     = "Standard_B2s"
}

variable "automation_account_name" {
  description = "Name of the Azure Automation Account for VMSS auto-shutdown"
  type        = string
  default     = "aa-vmss-autoshutdown"
}



