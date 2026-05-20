# Network Module
# Creates VNet, subnet(s), NSG with rules, and NSG-to-subnet association

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "main" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_security_group" "main" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# NSG Rule - Allow RDP from allowed IPs (Windows)
# Only created if allow_rdp=true AND source IPs are provided
resource "azurerm_network_security_rule" "allow_rdp" {
  count = var.allow_rdp && length(var.allowed_source_ips) > 0 ? 1 : 0

  name                        = "Allow-RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefixes     = var.allowed_source_ips
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
}

# NSG Rule - Allow SSH from allowed IPs (Linux)
# Only created if allow_ssh=true AND source IPs are provided
resource "azurerm_network_security_rule" "allow_ssh" {
  count = var.allow_ssh && length(var.allowed_source_ips) > 0 ? 1 : 0

  name                        = "Allow-SSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = var.allowed_source_ips
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
}

# NSG Association to Subnet(s)
resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = var.subnets

  subnet_id                 = azurerm_subnet.main[each.key].id
  network_security_group_id = azurerm_network_security_group.main.id
}
