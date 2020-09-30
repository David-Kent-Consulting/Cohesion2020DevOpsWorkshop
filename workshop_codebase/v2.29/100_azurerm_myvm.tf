resource "azurerm_public_ip" "DKCESMT01_pubip" {
    name                = var.azurevm_DKCESMT01.vm_pubip_name
    location            = var.azure_region
    resource_group_name = azurerm_resource_group.myResourceGroup.name
    sku                 = "Basic"
    allocation_method   = var.azurevm_DKCESMT01.vm_pubip_alloc_method

    tags = {
        accounting  = var.accounting_tag
    }
}

resource "azurerm_network_interface" "DKCESMT01_nic01" {
    name                = var.azurevm_DKCESMT01.vm_nicname
    location            = var.azure_region
    resource_group_name = azurerm_resource_group.myResourceGroup.name
    ip_configuration {
        name                            = "ipconfig1"
        subnet_id                       = azurerm_subnet.my_subnet0.id
        private_ip_address_allocation   = var.azurevm_DKCESMT01.vm_nicip_alloc_method
    }

    tags = {
        accounting  = var.accounting_tag
    }
}


resource "azurerm_linux_virtual_machine" "azurevm_DKCESMT01" {
    name                            = var.azurevm_DKCESMT01.vm_name
    location                        = var.azure_region
    resource_group_name             = azurerm_resource_group.myResourceGroup.name
    size                            = var.azurevm_DKCESMT01.size
    admin_username                  = var.azurevm_DKCESMT01.username
    admin_password                  = var.azurevm_DKCESMT01.admin_password
    disable_password_authentication = false
    network_interface_ids = [
        azurerm_network_interface.DKCESMT01_nic01.id,
    ]


    # admin_ssh_key {
    #     username            = var.azurevm_DKCESMT01.username
    #     public_key          = file("~/.ssh/id_rsa.pub")
    # }

    os_disk {
        name                        = var.azurevm_DKCESMT01.os_disk_name
        disk_size_gb                = var.azurevm_DKCESMT01.os_disk_size_gb
        caching                     = var.azurevm_DKCESMT01.os_disk_caching
        storage_account_type        = var.azurevm_DKCESMT01.os_storage_act_type
    }
    
    boot_diagnostics {
        storage_account_uri         = azurerm_storage_account.my_storage_account.primary_blob_endpoint
    }


    source_image_reference {
      publisher                     = var.azurevm_DKCESMT01.publisher
      offer                         = var.azurevm_DKCESMT01.offer
      sku                           = var.azurevm_DKCESMT01.sku
      version                       = "latest"
    }


    tags = {
        accounting  = var.accounting_tag
    }
}
