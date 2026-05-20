# terraform/outputs.tf

output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.name
}


output "user_timezone" {
  description = "The user's timezone for auto-shutdown configuration"
  value       = var.user_timezone
}


output "windows_vm_name" {
  description = "The name of the Windows Virtual Machine for Azure ARC Server"
  value       = module.vm_windows.vm_name
}