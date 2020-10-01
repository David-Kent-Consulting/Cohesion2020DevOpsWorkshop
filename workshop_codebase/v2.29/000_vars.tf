// declar all variables


variable "azure_region" {
    type    = string
    default = "centralus"
}

variable "accounting_tag" {
    type    = string
    default = "0230_compsci"
}

variable "resource_group"{
    type    = string
    default = "TEST_rg"
}

variable "network" {
    type = object({
        name            = string
        address_space   = string
        subnet0_name    = string
        subnet0_cidr    = string
        subnet1_name    = string
        subnet1_cidr    = string
        subnet2_name    = string
        subnet2_cidr    = string
    })
    default = {
        name            = "TEST_vnet"
        address_space   = "172.16.0.0/16"
        subnet0_name    = "172_16_0_0_24"
        subnet0_cidr    = "172.16.0.0/24"
        subnet1_name    = "172_16_1_0_24"
        subnet1_cidr    = "172.16.1.0/24"
        subnet2_name    = "172_16_2_0_24"
        subnet2_cidr    = "172.16.2.0/24"
    }
}

variable "security_group" {
    type = string
    default = "TEST_nsg"
}

variable "load_balancer" {
    type = object({
        name                = string
        lbpubip_name        = string
        allocation_method   = string
    })
    default = {
        name                = "TEST_nlb"
        lbpubip_name        = "Test_nlbPubIp"
        allocation_method   = "Static"
    }
}

# we create a random ID that will be perpetually stored in the Terraform state file
# for this variable
resource "random_id" "id" {
    byte_length = 8
}

variable "storage_account" {
    type=object({
        account_tier                = string
        account_kind                = string
        account_replication_type    = string
        enable_https_traffic_only   = bool
    })
    default = {
        account_tier                = "Standard"
        account_kind                = "StorageV2"
        account_replication_type    = "GRS"
        enable_https_traffic_only   = true
    }
}

variable "azurevm_DKCESMT01" {
    type = object({
        vm_pubip_name               = string
        vm_pubip_alloc_method       = string
        vm_nicname                  = string
        vm_nicip_alloc_method       = string
        vm_name                     = string
        publisher                   = string
        offer                       = string
        sku                         = string
        version                     = string
        size                        = string
        username                    = string
        admin_password              = string
        os_disk_name                = string
        os_disk_caching             = string
        os_storage_act_type         = string
        os_disk_size_gb             = number
    })
    default = {
        vm_pubip_name               = "DKCESMT01_pubip"
        vm_pubip_alloc_method       = "Dynamic"
        vm_nicname                  = "DKCESMT01_nic00"
        vm_nicip_alloc_method       = "Dynamic"
        vm_name                     = "DKCESMT01"
        publisher                   = "Canonical"
        offer                       = "UbuntuServer"
        sku                         = "18.04-LTS"
        version                     = "latest"
        size                        = "Standard_B2ms"
        username                    = "azureuser"
        admin_password              = "d54mcQ!$4LPi"
        os_disk_name                = "DKCESMT01_osdisk_00"
        os_disk_caching             = "ReadWrite"
        os_storage_act_type         = "Standard_LRS"
        os_disk_size_gb             = 64
    }
}

variable kbcluster_DKCKBCT01 {
    type = object({
        kb_name                     = string
        dns_prefix                  = string
        np_name                     = string
        node_count                  = number
        vm_size                     = string
        client_id                   = string
        client_secret               = string
    })
    default = {
        kb_name                     = "DKCAKSCT01"
        dns_prefix                  = "dkcaksct01"
        np_name                     = "dkcakc01p0"
        node_count                  = 1
        vm_size                     = "Standard_D2_v2"
        client_id                   = "ff5ea6d4-a56b-489c-a3ff-a8df12e4837b"
        client_secret               = "sM-WVDeq4q-zoa1zVa6eOb75QeiCTL9usc"
        
    }
}

variable container_registry_DKCKBCRT01 {
    type = object({
        name                        = string
        sku                         = string
        admin_enabled               = bool
        georeplication_locations    = any
    })
    default = {
        name                        = "dkckbcrt01"
        sku                         = "Premium"
        admin_enabled               = false
        georeplication_locations    = ["centralus", "eastus2"]
    }
}

variable mysql_DKCMYSQLT01 {
    type = object({
        name                                = string
        administrator_login                 = string
        administrator_login_password        = string
        sku_name                            = string
        capacity                            = number
        tier                                = string
        family                              = string
        storage_mb                          = number
        version                             = string
        auto_grow_enabled                   = bool
        backup_retention_days               = number
        geo_redundant_backup_enabled        = bool
        infrastructure_encryption_enabled   = bool
        public_network_access_enabled       = bool
        ssl_enforcement_enabled             = bool
        ssl_minimal_tls_version_enforced    = string
    })
    default = {
        name                                = "dkcmysqlt01"
        administrator_login                 = "mysqladminun"
        administrator_login_password        = "E7@1!CwQaVt6"
        sku_name                            = "B_Gen5_2"
        capacity                            = 2
        tier                                = "Basic"
        family                              = "Gen5"
        storage_mb                          = 5120
        version                             = "8.0"
        auto_grow_enabled                   = false
        backup_retention_days               = 31
        geo_redundant_backup_enabled        = false
        infrastructure_encryption_enabled   = false
        public_network_access_enabled       = false
        ssl_enforcement_enabled             = true
        ssl_minimal_tls_version_enforced    = "TLS1_2"

    }
}

variable A10_security_appliance {
    type = object({
        vm_nicname                  = string
        vm_nicip_alloc_method       = string
        vm_name                     = string
        publisher                   = string
        offer                       = string
        sku                         = string
        version                     = string
        size                        = string
        username                    = string
        admin_password              = string
        os_disk_name                = string
        os_disk_caching             = string
        os_storage_act_type         = string
        os_disk_size_gb             = number
    })
    default = {
        vm_nicname                  = "DKCA10T01_nic01"
        vm_nicip_alloc_method       = "Dynamic"
        publisher                   = "a10networks"
        offer                       = "a10-vthunder-adc"
        sku                         = "vthunder_byol"
        version                     = "Latest"
        size                        = "Standard_DS3_v2"
        vm_name                     = "DKCA10T01"
        username                    = "a10user"
        admin_password              = "TjrV8&^sQxz97"
        os_disk_name                = "DKCA10T01_osdisk_00"
        os_disk_caching             = "ReadWrite"
        os_storage_act_type         = "Standard_LRS"
        os_disk_size_gb             = 100
    }
}

// Here is an example of how to create a group of simimar instances.
// See code in 100_azurerm_myvm.tf
variable "linuxBasicInstances" {
    type = list
    default = ["DKCJSUBT01", "DKCBAST01", "DKCREPT01"]
}

// test print the map list, uncomment when debugging
output "debug" {
    value = var.linuxBasicInstances
}