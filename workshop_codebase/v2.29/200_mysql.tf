resource "azurerm_mysql_server" "mysql" {
    name                                = var.mysql_DKCMYSQLT01.name
    location                            = var.azure_region
    resource_group_name                 = azurerm_resource_group.myResourceGroup.name

    administrator_login                 = var.mysql_DKCMYSQLT01.administrator_login
    administrator_login_password        = var.mysql_DKCMYSQLT01.administrator_login_password

    sku_name                            = var.mysql_DKCMYSQLT01.sku_name
    storage_mb                          = var.mysql_DKCMYSQLT01.storage_mb
    version                             = var.mysql_DKCMYSQLT01.version
    auto_grow_enabled                   = var.mysql_DKCMYSQLT01.auto_grow_enabled
    backup_retention_days               = var.mysql_DKCMYSQLT01.backup_retention_days
    geo_redundant_backup_enabled        = var.mysql_DKCMYSQLT01.geo_redundant_backup_enabled
    infrastructure_encryption_enabled   = var.mysql_DKCMYSQLT01.infrastructure_encryption_enabled
# must be left commented out for the "Basic" tier, otherwise the API throws an exception.
# See https://github.com/terraform-providers/terraform-provider-azurerm/issues/7028 
    # public_network_access_enabled       = var.mysql_DKCMYSQLT01.public_network_access_enabled
    ssl_enforcement_enabled             = var.mysql_DKCMYSQLT01.ssl_enforcement_enabled
    ssl_minimal_tls_version_enforced    = var.mysql_DKCMYSQLT01.ssl_minimal_tls_version_enforced

    tags = {
        accounting  = var.accounting_tag
    }
}