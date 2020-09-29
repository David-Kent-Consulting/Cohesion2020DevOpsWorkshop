# Hey codeheads!
# We are using the azurerm 2.x moduals, all code syntax has been brought up to what is current
# as of 29-sept-2020

# CAUTION: Do not use tags for subnets since a subnet is part of the vnet object

resource "azurerm_subnet" "my_subnet0" {
    name                    = var.network.subnet0_name
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    virtual_network_name    = azurerm_virtual_network.virtual_network.name
    address_prefixes        = [var.network.subnet0_cidr]
}

resource "azurerm_subnet" "my_subnet1" {
    name                    = var.network.subnet1_name
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    virtual_network_name    = azurerm_virtual_network.virtual_network.name
    address_prefixes        = [var.network.subnet1_cidr]
}

resource "azurerm_subnet" "my_subnet2" {
    name                    = var.network.subnet2_name
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    virtual_network_name    = azurerm_virtual_network.virtual_network.name
    address_prefixes        = [var.network.subnet2_cidr]
}

