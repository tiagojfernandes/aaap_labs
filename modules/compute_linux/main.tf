# Linux Compute Module
# Creates Linux VM(s) with NIC, optional public IP, OS disk
# Does NOT touch Machine Configuration directly - pure compute infrastructure

# Optional Public IP
resource "azurerm_public_ip" "main" {
  count = var.create_public_ip ? 1 : 0

  name                = "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Network Interface
resource "azurerm_network_interface" "main" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.main[0].id : null
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  tags                            = var.tags

  network_interface_ids = [
    azurerm_network_interface.main.id
  ]

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key != null ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.admin_ssh_key
    }
  }

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  identity {
    type = "SystemAssigned"
  }
}
