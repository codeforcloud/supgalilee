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
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWeSBZZiWaLQkKYwxsNhvEur5HLlymF5A6cGcjEvrQzDzLHqe7/yMaenZ9jMGxJ/et8snq3KyDw7VaQvuiAHsZdES0IhDiAb82XkEn8sd7dvRqMXlnIdGpZUJ33UwOevDfn3N6JGK/6uvuJLTFcz5L/K+6pk06ur9Go1gIseCTtjmBqzpgc3bB+mD/uAfLbBXz2kJdc1RnvBk8sBxQ9UXYdwGRdEWA6RvkU1mGaOAMLhKDOxjR6rg8JQe0CTeKVFq9JdCs+KIhOiYkyZBMv8qM0s+PJpblexOoivmgPbQRjaI+qdC/b1QtQzdAPwobFbJeRFT1IrIvKA97YNBtTv8p"
    }
  }

  tags {
    environment = "petclinic"
  }
}
