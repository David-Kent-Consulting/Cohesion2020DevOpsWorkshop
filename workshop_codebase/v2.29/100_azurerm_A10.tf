resource "azurerm_network_interface" "DKCA10T01_nic01" {
    name                                = var.A10_security_appliance.vm_nicname
    location                            = var.azure_region
    resource_group_name                 = azurerm_resource_group.myResourceGroup.name
    ip_configuration {
        name                            = "ipconfig1"
        subnet_id                       = azurerm_subnet.my_subnet0.id
        private_ip_address_allocation   = var.A10_security_appliance.vm_nicip_alloc_method
    }

    tags = {
        accounting                      = var.accounting_tag
    }
}


resource "azurerm_linux_virtual_machine" "azurevm_DKCA10T01" {
    name                                = var.A10_security_appliance.vm_name
    location                            = var.azure_region
    resource_group_name                 = azurerm_resource_group.myResourceGroup.name
    size                                = var.A10_security_appliance.size
    admin_username                      = var.A10_security_appliance.username
    admin_password                      = var.A10_security_appliance.admin_password
    disable_password_authentication = false
    network_interface_ids = [
        azurerm_network_interface.DKCA10T01_nic01.id,
    ]

    os_disk {
        name                            = var.A10_security_appliance.os_disk_name
        disk_size_gb                    = var.A10_security_appliance.os_disk_size_gb
        caching                         = var.A10_security_appliance.os_disk_caching
        storage_account_type            = var.A10_security_appliance.os_storage_act_type
    }

    boot_diagnostics {
        storage_account_uri             = azurerm_storage_account.my_storage_account.primary_blob_endpoint
    }

    source_image_reference {
      publisher                         = var.A10_security_appliance.publisher
      offer                             = var.A10_security_appliance.offer
      sku                               = var.A10_security_appliance.sku
      version                           = var.A10_security_appliance.version
    }

    plan {
      name                              = var.A10_security_appliance.sku
      publisher                         = var.A10_security_appliance.publisher
      product                           = var.A10_security_appliance.offer
    }


    tags = {
        accounting  = var.accounting_tag
    }
}
