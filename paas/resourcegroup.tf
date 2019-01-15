# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "supgalilee" {
  name     = "supgalilee-paas"
  location = "northeurope"

  tags {
    environment = "petclinic"
  }
}
