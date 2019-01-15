# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "petclinic-resourcegroup" {
  name     = "supgalilee-iaas"
  location = "northeurope"

  tags {
    environment = "petclinic"
  }
}
