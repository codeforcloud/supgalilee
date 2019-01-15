# Create virtual network
resource "azurerm_virtual_network" "petclinic-vnet" {
  name                = "petclinic-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "northeurope"
  resource_group_name = "${azurerm_resource_group.petclinic-resourcegroup.name}"

  tags {
    environment = "petclinic"
  }
}

# Create subnet
resource "azurerm_subnet" "petclinic-subnet" {
  name                 = "petclinic-subnet"
  resource_group_name  = "${azurerm_resource_group.petclinic-resourcegroup.name}"
  virtual_network_name = "${azurerm_virtual_network.petclinic-vnet.name}"
  address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "petclinic-publicip" {
  name                = "petclinic-publicip-${format("%02d", count.index + 1)}"
  location            = "northeurope"
  resource_group_name = "${azurerm_resource_group.petclinic-resourcegroup.name}"
  allocation_method   = "Dynamic"
  count               = "${var.count}"

  tags {
    environment = "petclinic"
  }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "petclinic-nsg" {
  name                = "petclinic-nsg"
  location            = "northeurope"
  resource_group_name = "${azurerm_resource_group.petclinic-resourcegroup.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-Alt"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "petclinic"
  }
}

# Create network interface
resource "azurerm_network_interface" "petclinic-nic" {
  name                      = "petclinic-nic-${format("%02d", count.index + 1)}"
  location                  = "northeurope"
  resource_group_name       = "${azurerm_resource_group.petclinic-resourcegroup.name}"
  network_security_group_id = "${azurerm_network_security_group.petclinic-nsg.id}"
  count                     = "${var.count}"

  ip_configuration {
    name                          = "petclinic-nicconfig"
    subnet_id                     = "${azurerm_subnet.petclinic-subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.petclinic-publicip.*.id, count.index)}"
  }

  tags {
    environment = "petclinic"
  }
}
