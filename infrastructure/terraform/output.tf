output "vm_id" {
  value = azurerm_linux_virtual_machine.webserver.id
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.webserver.public_ip_address
}

output "tls_private_key" {
  value = tls_private_key.sshKey.private_key_pem
}