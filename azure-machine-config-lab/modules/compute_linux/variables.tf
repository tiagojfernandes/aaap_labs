variable "vm_name" {
  description = "Name of the Linux virtual machine"
  type        = string
}

variable "location" {
  description = "Azure region for the VM"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for the VM"
  type        = string
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VM (used if SSH key not provided)"
  type        = string
  sensitive   = true
  default     = null
}

variable "admin_ssh_key" {
  description = "SSH public key for authentication"
  type        = string
  default     = null
}

variable "disable_password_authentication" {
  description = "Disable password authentication (set to false if using password)"
  type        = bool
  default     = true
}

variable "create_public_ip" {
  description = "Whether to create a public IP for the VM"
  type        = bool
  default     = false
}

variable "os_disk_type" {
  description = "Type of OS disk"
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "0001-com-ubuntu-server-jammy"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "22_04-lts"
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

variable "tags" {
  description = "Tags to apply to the VM"
  type        = map(string)
  default     = {}
}
