# Hey codeheads!
# We are not using the azurerm 2.0 moduals, anything ending in a zero is suicidal
# We are using the good-to-go version 1.44.0
# address_prefix is not depreciated as of 23.sep-2020. Do not use address_prefixes.

resource "azurerm_subnet" "my_subnet0" {
    name                    = var.network.subnet0_name
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    virtual_network_name    = azurerm_virtual_network.virtual_network.name
    address_prefix          = var.network.subnet0_cidr
}

resource "azurerm_subnet" "my_subnet1" {
    name                    = var.network.subnet1_name
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    virtual_network_name    = azurerm_virtual_network.virtual_network.name
    address_prefix          = var.network.subnet1_cidr
}

resource "azurerm_subnet" "my_subnet2" {
    name                    = var.network.subnet2_name
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    virtual_network_name    = azurerm_virtual_network.virtual_network.name
    address_prefix          = var.network.subnet2_cidr
}

