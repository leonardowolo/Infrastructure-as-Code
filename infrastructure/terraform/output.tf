output "vm_id" {
  value = azurerm_linux_virtual_machine.iac-webserver.id
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.iac-webserver.public_ip_address
}

output "tls_private_key" {
  value = tls_private_key.iac-sshKey.private_key_pem
  sensitive = true
}


output "fqdn" {
  value = azurerm_public_ip.iac-pIP.domain_name_label
}
