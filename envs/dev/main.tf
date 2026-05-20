# Development Environment - Main Configuration

# Core Resource Group
# Creates the "lab boundary" resource group where all resources live
module "core_rg" {
  source = "../../modules/core_rg"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

# Network Infrastructure
# Creates VNet, subnet, NSG with RDP/SSH rules, and NSG-to-subnet association
module "network" {
  source = "../../modules/network"

  vnet_name          = var.vnet_name
  address_space      = var.address_space
  location           = module.core_rg.resource_group_location
  resource_group_name = module.core_rg.resource_group_name
  subnets            = var.subnets
  nsg_name           = var.nsg_name
  allow_rdp          = var.allow_rdp
  allow_ssh          = var.allow_ssh
  allowed_source_ips = var.allowed_source_ips
  tags               = var.tags
}

# Windows Virtual Machine
# Pure compute - does not touch Machine Configuration directly
module "compute_windows" {
  source = "../../modules/compute_windows"

  vm_name             = var.windows_vm_name
  location            = module.core_rg.resource_group_location
  resource_group_name = module.core_rg.resource_group_name
  subnet_id           = module.network.subnet_ids["default"]
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  create_public_ip    = var.create_windows_public_ip
  tags                = var.tags
}

# Linux Virtual Machine
# Pure compute - does not touch Machine Configuration directly
module "compute_linux" {
  source = "../../modules/compute_linux"

  vm_name                         = var.linux_vm_name
  location                        = module.core_rg.resource_group_location
  resource_group_name             = module.core_rg.resource_group_name
  subnet_id                       = module.network.subnet_ids["default"]
  vm_size                         = var.vm_size
  admin_username                  = var.admin_username
  admin_ssh_key                   = var.admin_ssh_key
  admin_password                  = var.admin_ssh_key != null ? null : var.admin_password  # Use Windows password if no SSH key
  disable_password_authentication = var.admin_ssh_key != null
  create_public_ip                = var.create_linux_public_ip
  tags                            = var.tags
}

# Monitoring
# Log Analytics Workspace and DCR for VM insights
module "monitoring" {
  source = "../../modules/monitoring"

  log_analytics_workspace_name = var.log_analytics_workspace_name
  location                     = module.core_rg.resource_group_location
  resource_group_name          = module.core_rg.resource_group_name
  dcr_name                     = var.dcr_name
  tags                         = var.tags
}

# Machine Configuration Prerequisites
# Assigns the built-in MC prerequisites initiative at RG scope
# This deploys: MC extension/agent, system-assigned managed identity on VMs
module "mc_prereqs" {
  source = "../../modules/mc_prereqs"

  resource_group_id       = module.core_rg.resource_group_id
  location                = module.core_rg.resource_group_location
  assignment_name         = var.mc_prereqs_assignment_name
  prereqs_initiative_id   = var.mc_prereqs_initiative_id
  create_remediation_task = var.create_mc_prereqs_remediation

  depends_on = [module.compute_windows, module.compute_linux]
}

# MDC Security Baseline
# Assigns MDC/MCSB and OS-specific baseline initiatives at RG scope
# Lights up "vulnerabilities in security configuration" in Defender for Cloud
module "mc_mdc_baseline" {
  source = "../../modules/mc_mdc_baseline"

  resource_group_id       = module.core_rg.resource_group_id
  location                = module.core_rg.resource_group_location
  enable_mdc_baseline     = var.enable_mdc_baseline
  enable_windows_baseline = var.enable_windows_baseline
  enable_linux_baseline   = var.enable_linux_baseline

  depends_on = [module.mc_prereqs]
}

# Custom Machine Configurations
# Playground for custom Guest Configuration policies
# Designed for TLS hardening, SSH hardening, MDE-style configs, etc.
module "mc_custom_configs" {
  source = "../../modules/mc_custom_configs"

  resource_group_id         = module.core_rg.resource_group_id
  location                  = module.core_rg.resource_group_location
  custom_policy_assignments = var.custom_policy_assignments

  depends_on = [module.mc_prereqs]
}
