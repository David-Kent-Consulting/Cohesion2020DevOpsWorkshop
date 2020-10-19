// required versions. Written and tested on Fedora V3.3.6 and:
// AZ CLI 2.11.1
// Python 3.8.2
// Adal 1.2.2
// terraform version v0.13.3
// azurerm terraform module v1.44.0
// We have not yet fully tested the 2.x code, we do not consider it stable as of 23-sept-2020
// see versions at https://github.com/terraform-providers/terraform-provider-azurerm

terraform {
  required_version = ">= 0.13.3"
}
provider "azurerm" {
  version = "= 1.44.0"
}


// point to the storage account with the terraform state - VERY IMPORTANT
//set this up using PowerShell AZ as follows. Substitute your stuff as needed
# New-AzResourceGroup cohesion2020_rg -location centralus
# New-AzStorageAccount -ResourceGroupName cohesion2020_rg -Location centralus -Name cohesionkvault -SkuName "Standard_LRS"
# Set-AzCurrentStorageAccount -ResourceGroupName cohesion2020_rg -Name cohesionkvault
# New-AzStorageContainer -Name "tformstate" -Permission container
# Copy Key1's value to access_key below
# enter the storage account name and the container.
# Then, copy the "terraform.state" file to TEST_rg.terraform.tstate on your development desktop
# working directory, then to the container.
# Be certain to delete your local copy once you know this works. VERY IMPORTANT
# then test with "terraform init", followed by "terraform plan"
# If you have done this correctly, then you will see 
# "Acquiring state lock. This may take a few moments..."
# Of course, this carries some risk, so do be careful to fully test for your particular
# situation.

# These action must be completed prior to implementing an Azure DevOps piepline.

terraform {
  backend "azurerm" {
    storage_account_name = "cohesionkvault"
    container_name       = "tformstate"
    access_key           = "<your storage account key goes here>"

    // entry below should either be dev.terraform.tstate or prod.terraform.tstate for client tenant
    // for individual tstate, it should be AzUsrName.terraform.tstate
    // example    key                  = "prod.TEST_rg.terraform.tfstate"
    key = "TEST_rg.terraform.tstate"
  }
}


// declare variables

variable "azure_region" {
    type    = string
    default = "centralus"
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

resource "random_string" "storage_affix" {
  length  = 6
  upper   = false
  number  = true
  lower   = false
  special = false
}

variable "storage_account" {
    type=object({
        account_tier                = string
        account_kind                = string
        account_replication_type    = string
        enable_blob_encryption      = bool
        enable_file_encryption      = bool
        enable_https_traffic_only   = bool
        account_encryption_source   = string
    })
    default = {
        account_tier                = "Standard"
        account_kind                = "StorageV2"
        account_replication_type    = "GRS"
        enable_blob_encryption      = true
        enable_file_encryption      = true
        enable_https_traffic_only   = true
        account_encryption_source   = "Microsoft.Storage"
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
        geo_redundant_backup                = string
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
        version                             = "5.9"
        auto_grow_enabled                   = false
        backup_retention_days               = 31
        geo_redundant_backup                = "Disabled"
        infrastructure_encryption_enabled   = true
        public_network_access_enabled       = false
        ssl_enforcement_enabled             = true
        ssl_minimal_tls_version_enforced    = "TLS1_2"

    }
}