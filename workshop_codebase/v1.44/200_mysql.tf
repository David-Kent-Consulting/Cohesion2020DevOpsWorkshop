resource "azurerm_mysql_server" "mysql" {
    name                                = var.mysql_DKCMYSQLT01.name
    location                            = var.azure_region
    resource_group_name                 = "${azurerm_resource_group.myResourceGroup.name}"

    administrator_login          = "mysqladminun"
    administrator_login_password = "H@Sh1CoR3!"
    version                      = "5.7"
    ssl_enforcement              = "Enabled"

    sku {
        name        = var.mysql_DKCMYSQLT01.sku_name
        capacity    = var.mysql_DKCMYSQLT01.capacity
        tier        = var.mysql_DKCMYSQLT01.tier
        family      = var.mysql_DKCMYSQLT01.family
     }

      storage_profile {
        storage_mb            = var.mysql_DKCMYSQLT01.storage_mb
        backup_retention_days = var.mysql_DKCMYSQLT01.backup_retention_days
        geo_redundant_backup  = var.mysql_DKCMYSQLT01.geo_redundant_backup
      }
}