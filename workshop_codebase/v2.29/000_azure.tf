// required versions. Written and tested on Fedora V3.3.6 and:
// AZ CLI 2.11.1
// Python 3.8.2
// Adal 1.2.2
// terraform version v0.13.4
// azurerm terraform module v2.29
// see versions at https://github.com/terraform-providers/terraform-provider-azurerm


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
  required_version = "= 0.13.4"

  backend "azurerm" {
    storage_account_name = "cohesionkvault"
    container_name       = "tformstate"
    access_key           = "shJ1ZWdCZdB1W+g+CyliCmE0V7nsng2jr3KOLUpN5Xf1uewSCuHUcnOhcLPCXukRssFPphYrkkpzRaDrk0WSyw=="

    // entry below should either be dev.terraform.tstate or prod.terraform.tstate for client tenant
    // for individual tstate, it should be AzUsrName.terraform.tstate
    // example    key                  = "prod.TEST_rg.terraform.tfstate"
    key = "TEST_rg.terraform.tstate"
  }
}
provider "azurerm" {
  version = "= 2.29"
  features {}
}
