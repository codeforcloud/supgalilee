resource "azurerm_app_service_plan" "app-service-plan" {
  name                = "app-service-plan-${format("%02d", count.index + 1)}"
  location            = "${azurerm_resource_group.supgalilee.location}"
  resource_group_name = "${azurerm_resource_group.supgalilee.name}"
  kind                = "linux"
  count               = "${var.count}"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "app-service" {
  name                = "supgalilee-app-service-${format("%02d", count.index + 1)}"
  location            = "${azurerm_resource_group.supgalilee.location}"
  resource_group_name = "${azurerm_resource_group.supgalilee.name}"
  app_service_plan_id = "${element(azurerm_app_service_plan.app-service-plan.*.id, count.index)}"
  count               = "${var.count}"

  site_config {
    java_version           = "1.8"
    java_container         = "JETTY"
    java_container_version = "9.3"
    scm_type               = "LocalGit"
  }
}

resource "azurerm_mysql_server" "mysql-server" {
  name                = "supgalilee-mysql-server-${format("%02d", count.index + 1)}"
  location            = "${azurerm_resource_group.supgalilee.location}"
  resource_group_name = "${azurerm_resource_group.supgalilee.name}"
  count               = "${var.count}"

  sku {
    name     = "B_Gen4_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen4"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "mysqladmin"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mysql_database" "mysql-database" {
  name                = "petclinic"
  resource_group_name = "${azurerm_resource_group.supgalilee.name}"
  server_name         = "${element(azurerm_mysql_server.mysql-server.*.name, count.index)}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  count               = "${var.count}"
}
