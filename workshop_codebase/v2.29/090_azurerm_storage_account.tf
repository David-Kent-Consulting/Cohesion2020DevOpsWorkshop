

resource "azurerm_storage_account" "my_storage_account" {
# the example below is an effective way to concatinate a string to a randomly
# generated var. Note the method "hex" is used to return the var's value in hex.
# This is how we ensure all values concatinated to stgact are interpreted as a
# single var of type string.
  name                      = "stgact${random_id.id.hex}"
  location                  = var.azure_region
  resource_group_name       = azurerm_resource_group.myResourceGroup.name
  account_tier              = var.storage_account.account_tier
  account_kind              = var.storage_account.account_kind
  account_replication_type  = var.storage_account.account_replication_type
  enable_https_traffic_only = var.storage_account.enable_https_traffic_only

    tags = {
        accounting  = var.accounting_tag
    }
}