output "vm_id" {
  description = "The ID of the Windows virtual machine"
  value       = azurerm_windows_virtual_machine.main.id
}

output "vm_name" {
  description = "The name of the Windows virtual machine"
  value       = azurerm_windows_virtual_machine.main.name
}

output "vm_private_ip" {
  description = "The private IP address of the VM"
  value       = azurerm_network_interface.main.private_ip_address
}

output "vm_public_ip" {
  description = "The public IP address of the VM (if created)"
  value       = var.create_public_ip ? azurerm_public_ip.main[0].ip_address : null
}

output "vm_identity_principal_id" {
  description = "The principal ID of the system assigned identity"
  value       = azurerm_windows_virtual_machine.main.identity[0].principal_id
}

output "nic_id" {
  description = "The ID of the network interface"
  value       = azurerm_network_interface.main.id
}
