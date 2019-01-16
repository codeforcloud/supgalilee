# Create virtual machine
resource "azurerm_virtual_machine" "petclinic-vm" {
  name                  = "petclinic-vm-${format("%02d", count.index + 1)}"
  location              = "northeurope"
  resource_group_name   = "${azurerm_resource_group.petclinic-resourcegroup.name}"
  network_interface_ids = ["${element(azurerm_network_interface.petclinic-nic.*.id, count.index)}"]
  vm_size               = "Standard_DS1_v2"
  count                 = "${var.count}"

  storage_os_disk {
    name              = "petclinic-osdisk-${format("%02d", count.index + 1)}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "petclinic-vm-${format("%02d", count.index + 1)}"
    admin_username = "azureuser"
    admin_password = "SuPG@l1l33!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "petclinic"
  }
}
