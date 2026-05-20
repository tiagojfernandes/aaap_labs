output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = { for k, v in azurerm_subnet.main : k => v.id }
}

output "nsg_id" {
  description = "The ID of the network security group"
  value       = azurerm_network_security_group.main.id
}

output "nsg_name" {
  description = "The name of the network security group"
  value       = azurerm_network_security_group.main.name
}
