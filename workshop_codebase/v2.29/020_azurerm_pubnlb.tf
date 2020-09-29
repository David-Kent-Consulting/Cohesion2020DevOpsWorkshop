resource "azurerm_public_ip" "pubnlb_ip" {
    name                    = var.load_balancer.lbpubip_name
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    location                = var.azure_region
    allocation_method       = var.load_balancer.allocation_method

    tags = {
        accounting  = var.accounting_tag
    }
}

resource "azurerm_lb" "my_nlb" {
    name                    = var.load_balancer.name
    resource_group_name     = azurerm_resource_group.myResourceGroup.name
    location                = var.azure_region
    frontend_ip_configuration {
        name                    = "PublicIpAddress"
        public_ip_address_id    = azurerm_public_ip.pubnlb_ip.id
    }

    tags = {
        accounting  = var.accounting_tag
    }
}