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
        public_ip_address_id            = azurerm_public_ip.DKCESMT01_pubip.id
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

// In the following code blocks, we build instances of identical sizes by using the
// for_each function. The key concept to get is that the foreach iterative loop
// is created within the for_each function. The approach is similar to Ansible,
// but is a lot cleaner. The reader should note that this functionality is
// not that old. It came out in version 0.12, and we are deploying using verion
// 0.13.3. This function can be used for simple strings or maps, but not for a 
// list of objects. Using as a list of objects will result in Terraform destroying
// and re-creating the cloud resources with each run, aka not good for production.
//
// In this code example, we pass a list of strings to  for_each and wrap the list
// within the function toset(), which ensures the list passed contains unique
// values. This is the only way we have gotten foreach to work with creating
// resources.
resource "azurerm_network_interface" "build_interfaces"{
    for_each = toset(var.linuxBasicInstances)

    name                = "${each.value}_nic00"
    location            = var.azure_region
    resource_group_name = azurerm_resource_group.myResourceGroup.name
    ip_configuration {
        name                            = "ipconfig1"
        subnet_id                       = azurerm_subnet.my_subnet0.id
        private_ip_address_allocation   = "Dynamic"
    }

    tags = {
        accounting  = var.accounting_tag
    }
}
// The application of the loop below requires that any referenced objects created
// by another resource be treated as an array with the "each.key" method. See the
// example below for the value supplied for network_interface_ids.
resource "azurerm_linux_virtual_machine" "build_virtual_machines" {
    for_each = toset(var.linuxBasicInstances)
//  the warning for Interpolation-only expressions should be ignired. This is a
//  valid use case since this is a concatenation of a string with an interpopulation.
// The same is true whereever we use this expression in the codeblocks below.
    name                            = "${each.value}"
    location                        = var.azure_region
    resource_group_name             = azurerm_resource_group.myResourceGroup.name
    size                            = "Standard_B1ms"
    admin_username                  = "azureuser"
    admin_password                  = "d54mcQ!$4LPi"
    disable_password_authentication = false
    network_interface_ids = [
        azurerm_network_interface.build_interfaces[each.key].id,
    ]

        os_disk {
        name                        = "${each.value}_osdisk_00"
        disk_size_gb                = 64
        caching                     = "ReadWrite"
        storage_account_type        = "Standard_LRS"
    }
    
    boot_diagnostics {
        storage_account_uri         = azurerm_storage_account.my_storage_account.primary_blob_endpoint
    }


    source_image_reference {
      publisher                     ="Canonical"
      offer                         = "UbuntuServer"
      sku                           = "18.04-LTS"
      version                       = "latest"
    }
}