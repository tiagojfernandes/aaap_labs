terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Resource group module
module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# Network Module
module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.name
  location            = var.location
  subnet_name         = "vmss_subnet"
}

# Windows VM Module for ARC Server
module "vm_windows" {
  source              = "./modules/arc_vm_windows"
  vm_name             = var.windows_arc_vm_name
  resource_group_name = module.resource_group.name
  location            = var.location
  vm_size             = var.windows_arc_vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  nic_id              = azurerm_network_interface.windows_vm_nic.id

  tags = {
    Environment = "Lab"
    Purpose     = "Windows VM"
    Project     = "Azure VM as ARC Server"
  }
}

# Network Interface for Windows VM
resource "azurerm_public_ip" "windows_vm_public_ip" {
  name                = "${var.windows_arc_vm_name}-public-ip"
  location            = var.location
  resource_group_name = module.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Lab"
    Purpose     = "Azure VM as ARC Server"
  }
}

resource "azurerm_network_interface" "windows_vm_nic" {
  name                = "${var.windows_arc_vm_name}-nic"
  location            = var.location
  resource_group_name = module.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_vm_public_ip.id
  }

  tags = {
    Environment = "Lab"
    Purpose     = "Azure VM as ARC Server"
  }
}

# Network Security Group for Windows VM (RDP access)
resource "azurerm_network_security_group" "windows_vm_nsg" {
  name                = "${var.windows_arc_vm_name}-nsg"
  location            = var.location
  resource_group_name = module.resource_group.name

  security_rule {
    name                       = "allow_http"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "allow_https"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_RDP"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    Environment = "Lab"
    Purpose     = "Azure VM as ARC Server"
  }
}

resource "azurerm_network_interface_security_group_association" "windows_vm_nsg_association" {
  network_interface_id      = azurerm_network_interface.windows_vm_nic.id
  network_security_group_id = azurerm_network_security_group.windows_vm_nsg.id
}


