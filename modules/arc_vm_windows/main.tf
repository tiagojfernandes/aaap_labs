resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  computer_name       = var.computer_name != null ? var.computer_name : var.vm_name
  custom_data         = var.custom_data
  network_interface_ids = [var.nic_id]

  # Patch management
  patch_mode                  = var.patch_mode
  provision_vm_agent         = true
  allow_extension_operations = true
  enable_automatic_updates   = var.enable_automatic_updates

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb        = var.os_disk_size_gb
  } 

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.windows_sku
    version   = var.windows_version
  }

  tags = var.tags
}


# ---------- Locals: your multiline PowerShell block ----------
locals {
  ps_block = <<-PS
    #region Bootstrap
    Write-Host "Starting inline bootstrap..."
    $log = "C:\\Temp\\bootstrap.log"
    "[$(Get-Date -Format o)] Begin" | Out-File -FilePath $log -Append
    
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    sleep -Seconds 60
    New-NetFirewallRule -DisplayName 'Block IMDS Access' -Direction Outbound -RemotePort 80 -Protocol TCP -Action Block -RemoteAddress 169.254.169.254 | Out-File -FilePath $log -Append
    Stop-Service -Name 'WindowsAzureGuestAgent' -Force | Out-File -FilePath $log -Append
    Set-Service -Name 'WindowsAzureGuestAgent' -StartupType Disabled | Out-File -FilePath $log -Append

    "Inline script completed." | Out-File -FilePath $log -Append
    Write-Host "Bootstrap complete."
    "[$(Get-Date -Format o)] End" | Out-File -FilePath $log -Append    
    #endregion
  PS
}

# ---------- Custom Script Extension (no external file) ----------
resource "azurerm_virtual_machine_extension" "cse_inline" {
  name                 = "CustomScriptExtension"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  # Build a single-line command that:
  # 1) embeds the here-string from locals.ps_block
  # 2) writes it to C:\Windows\Temp\bootstrap.ps1
  # 3) invokes the script
  settings = jsonencode({
    commandToExecute = format(
      "powershell.exe -NoProfile -ExecutionPolicy Bypass -Command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('%s')) | Set-Content -Path 'C:\\Temp\\bootstrap.ps1' -Force; Start-Process -FilePath 'powershell.exe' -ArgumentList @('-NoLogo', '-NoProfile', '-ExecutionPolicy Bypass', '-File', 'C:\\Temp\\bootstrap.ps1') -WindowStyle Hidden\"",
      base64encode(local.ps_block)
    )
  })


  lifecycle {
    ignore_changes = [
      settings,
      protected_settings,
      type_handler_version,
    ]
    # NO prevent_destroy here
  }

}



