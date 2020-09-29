# Hey codeheads!
# We are using the azurerm 2.x moduals, all code syntax has been brought up to what is current
# as of 29-sept-2020

resource "azurerm_network_security_group" "my_nsg" {
    name                  = var.security_group
    location              = var.azure_region
    resource_group_name   = azurerm_resource_group.myResourceGroup.name
    security_rule {
        name                       = "inboundSshFromInternet"
        description                = "Allow inbound SSH from the internet"
        access                     = "Allow"
        priority                   = "100"
        protocol                   = "Tcp"
        direction                  = "Inbound"
        source_port_range          = "*"
        source_address_prefix      = "0.0.0.0/0"
        destination_port_range     = "22"
        destination_address_prefix = "*"
    }

    tags = {
        accounting  = var.accounting_tag
    }
}