# resource "random_integer" "storage_random_integer" {
#     min     = 1000
#     max     = 9999
#     keepers{
#         random_integer = "${var.storage_account.random_integer}"
#     }
# }

resource "azurerm_storage_account" "my_storage_account" {
  name                      = "teststgact${random_string.storage_affix.result}"
  location                  = var.azure_region
  resource_group_name       = "${azurerm_resource_group.myResourceGroup.name}"
  account_tier              = var.storage_account.account_tier
  account_kind              = var.storage_account.account_kind
  account_replication_type  = var.storage_account.account_replication_type
  enable_blob_encryption    = var.storage_account.enable_blob_encryption
  enable_file_encryption    = var.storage_account.enable_file_encryption
  enable_https_traffic_only = var.storage_account.enable_https_traffic_only
  account_encryption_source = var.storage_account.account_encryption_source
  tags = {
  }
}