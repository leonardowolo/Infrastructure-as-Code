terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.83.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "IAC_Production"
    storage_account_name = "storageiac"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Configure Microsoft Azure resource group
resource "azurerm_resource_group" "IAC_Production" {
  name     = "IAC_Production"
  location = "West Europe"
}

# Configure Microsoft Azure virtual network
resource "azurerm_virtual_network" "iac-vNetwork" {
  name                = "iac-vNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.IAC_Production.location
  resource_group_name = azurerm_resource_group.IAC_Production.name
}

# Configure Microsoft Azure subnet
resource "azurerm_subnet" "iac-iSubnet" {
  name                 = "iac-internal"
  resource_group_name  = azurerm_resource_group.IAC_Production.name
  virtual_network_name = azurerm_virtual_network.iac-vNetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Configure Microsoft Azure Public Ip
resource "azurerm_public_ip" "iac-pIP" {
  name                = "iac-public"
  resource_group_name = azurerm_resource_group.IAC_Production.name
  location            = azurerm_resource_group.IAC_Production.location
  allocation_method   = "Dynamic"
  domain_name_label   = "iac-team3"
}

# Configure Microsoft Azure network interface
resource "azurerm_network_interface" "iac-nInterface" {
  name                = "iac-nInterface"
  location            = azurerm_resource_group.IAC_Production.location
  resource_group_name = azurerm_resource_group.IAC_Production.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.iac-iSubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.iac-pIP.id
  }
}

# Configure Microsoft Azure security group
resource "azurerm_network_security_group" "iac-securityGroup" {
  name                = "iac-securityGroup"
  location            = azurerm_resource_group.IAC_Production.location
  resource_group_name = azurerm_resource_group.IAC_Production.name
  security_rule {
    access                 = "Allow"
    direction              = "Inbound"
    name                   = "ssh-rule"
    priority               = 103
    protocol               = "Tcp"
    source_port_range      = "*"
    source_address_prefix  = "*"
    destination_port_range = "22"
    destination_address_prefix = "*"
  }
  security_rule {
    access                 = "Allow"
    direction              = "Inbound"
    name                   = "http-rule"
    priority               = 104
    protocol               = "Tcp"
    source_port_range      = "*"
    source_address_prefix  = "*"
    destination_port_range = "80"
    destination_address_prefix = "*"
  }
  security_rule {
    access                 = "Allow"
    direction              = "Inbound"
    name                   = "https-rule"
    priority               = 105
    protocol               = "Tcp"
    source_port_range      = "*"
    source_address_prefix  = "*"
    destination_port_range = "443"
    destination_address_prefix = "*"
  }
}

# Configure Microsoft Azure SSH Key
resource "tls_private_key" "iac-sshKey" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Configure Microsoft Azure virtual machine
resource "azurerm_linux_virtual_machine" "iac-webserver" {
  name                = "iac-webserver"
  computer_name       = "iac-webserver"
  resource_group_name = azurerm_resource_group.IAC_Production.name
  location            = azurerm_resource_group.IAC_Production.location
  size                = "Standard_B2s"
  admin_username      = "team3-iac"
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.iac-nInterface.id,
  ]

  admin_ssh_key {
    username   = "team3-iac"
    public_key = tls_private_key.iac-sshKey.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "local_file" "keyFile" {
  content           = tls_private_key.iac-sshKey.private_key_pem
  filename          = "/.ssh-key/iac-webserver_key.pem"
  file_permission   = "0600"
}


