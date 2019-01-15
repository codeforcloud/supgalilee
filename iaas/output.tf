output "ssh-command" {
    value = "ssh azureuser@${element(azurerm_public_ip.petclinic-publicip.*.ip_address, var.count)}"
}