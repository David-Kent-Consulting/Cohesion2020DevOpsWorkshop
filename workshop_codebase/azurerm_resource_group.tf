resource "azurerm_resource_group" "myResourceGroup" {
  name     = var.resource_group
  location = var.azure_region
}
