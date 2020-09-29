resource "azurerm_virtual_network" "virtual_network" {
    name                    = var.network.name
    location                = var.azure_region
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    address_space           = [var.network.address_space,]

    tags = {
        accounting  = var.accounting_tag
    }
}