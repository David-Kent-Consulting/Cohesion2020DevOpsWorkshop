resource "azurerm_public_ip" "DKCESMT01_pubip" {
    name                = var.azurevm_DKCESMT01.vm_pubip_name
    location            = var.azure_region
    resource_group_name = "${azurerm_resource_group.myResourceGroup.name}"
    sku                 = "Basic"
    allocation_method   = var.azurevm_DKCESMT01.vm_pubip_alloc_method
}

resource "azurerm_network_interface" "DKCESMT01_nic01" {
    name                = var.azurevm_DKCESMT01.vm_nicname
    location            = var.azure_region
    resource_group_name = "${azurerm_resource_group.myResourceGroup.name}"
    enable_ip_forwarding            = false
    enable_accelerated_networking   = false
    network_security_group_id       = "${azurerm_network_security_group.my_nsg.id}"
    ip_configuration {
        name                          = "ipconfig1"
        subnet_id                     = "${azurerm_subnet.my_subnet0.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "/subscriptions/df48342b-01c5-49db-97ce-27576bdbb6c5/resourceGroups/TEST_rg/providers/Microsoft.Network/publicIPAddresses/DKCESMT01_pubip"
        primary                       = true
    }
}

# Codeheads, we are running the 1.44.0 codebase
# Don't use https://www.terraform.io/docs/providers/azurerm/r/linux_virtual_machine.html
# Do use https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html
resource "azurerm_virtual_machine" "azurevm_DKCESMT01" {
    name                    = var.azurevm_DKCESMT01.vm_name
    location                = var.azure_region
    resource_group_name     = "${azurerm_resource_group.myResourceGroup.name}"
        network_interface_ids   = [
        "${azurerm_network_interface.DKCESMT01_nic01.id}"
    ]
    vm_size                 = var.azurevm_DKCESMT01.size
    storage_image_reference {
        publisher   = "Canonical"
        offer       = "UbuntuServer"
        sku         = "18.04-LTS"
        version     = "latest"
    }
    storage_os_disk {
        name                = var.azurevm_DKCESMT01.os_disk_name
        caching             = var.azurevm_DKCESMT01.os_disk_caching
        create_option       = "FromImage"
        managed_disk_type   = var.azurevm_DKCESMT01.os_storage_act_type
    }
    os_profile {
        computer_name       = var.azurevm_DKCESMT01.vm_name
        admin_username      = "azureuser"
        admin_password      = "dt%4@0)ptaxcM"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
    boot_diagnostics {
        enabled             = true
        storage_uri         = "${azurerm_storage_account.my_storage_account.primary_blob_endpoint}"
    }
}