locals {
  formatted_name = lower(replace(var.project_name, " ", "-"))
  #replace will evaluate the var.project_name, find all the spaces (" "), and replaces them with -
  #lower will take the value of the replace function and lower the case
  merged_tags       = merge(var.default_tags, var.environment_tags)
  storage_formatted = trim(replace(lower(substr(var.storage_account_name, 0, 23)), " ", ""), "!") #0 is the minimum, 23 is the maximum
  formatted_ports   = [for p in split(",", var.allowed_ports) : tonumber(trim(p, " "))]
  nsg_rules = [for idx, port in local.formatted_ports : {
    name        = "port-${port}"
    priority    = 100 + idx
    port        = port
    description = "Allowed traffic on port : ${port}"
  }]

  vm_size = lookup(var.vm_sizes, var.environment, lower("dev"))

  user_locations    = ["eastus", "westus", "eastus"]
  default_locations = ["centralus"]
  unique_location   = toset(concat(local.user_locations, local.default_locations))

  monthly_costs  = [-50, 100, 75, 200]
  positive_costs = [for cost in local.monthly_costs : abs(cost)]
  maximum_cost   = max(local.positive_costs...)

  path_exists = fileexists("${var.file_path}/main.tf")

  current_time = timestamp()
  resource_date = formatdate("YYYYMMDD", local.current_time)
  tag_date = formatdate("DD-MM-YYYY", local.current_time)

  config_content = sensitive(file("config.json"))
}



resource "azurerm_resource_group" "rg" {
  name     = "${local.formatted_name}-rg"
  location = "australiaeast"

  tags = local.merged_tags
}

resource "azurerm_storage_account" "sa" {

  name                     = local.storage_formatted
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = local.merged_tags

}

resource "azurerm_network_security_group" "example" {
  name                = "${local.formatted_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  tags = local.merged_tags
}

output "rgname" {
  value = azurerm_resource_group.rg.name
}

output "tags" {
  value = local.merged_tags
}

output "storage_name" {
  value     = azurerm_storage_account.sa
  sensitive = true
}

output "ports" {
  value = local.formatted_ports
}

output "nsgRules" {
  value = local.nsg_rules
}

output "security_name" {
  value = azurerm_network_security_group.example.name
}

output "vm_size" {
  value = local.vm_size
}

output "backup" {
  value = var.backup_name
}

output "credential" {
  value     = var.credential
  sensitive = true
}

output "unique_location" {
  value = local.unique_location
}

output "positive_costs" {
  value = local.positive_costs
}

output "max_costs" {
  value = local.maximum_cost
}

output "file_exists" {
  value = local.path_exists
}

output "resource_tag" {
  value = local.resource_date
}

output "config_loaded" {
  value = nonsensitive(jsondecode(local.config_content))
}