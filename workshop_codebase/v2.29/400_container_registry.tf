resource "azurerm_container_registry" "mycontainer_registry" {
    name                        = var.container_registry_DKCKBCRT01.name
    resource_group_name         = azurerm_resource_group.myResourceGroup.name
    location                    = var.azure_region
    sku                         = var.container_registry_DKCKBCRT01.sku
    admin_enabled               = var.container_registry_DKCKBCRT01.admin_enabled
    georeplication_locations    = var.container_registry_DKCKBCRT01.georeplication_locations
}