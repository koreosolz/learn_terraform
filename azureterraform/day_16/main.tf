data "azurerm_client_config" "current" {}

output "running_as" {
  value = data.azurerm_client_config.current.client_id
}

data "azuread_domains" "aad" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.aad.domains.*.domain_name
  users = csvdecode(file("users.csv"))
  users_map = { for user in local.users : user.first_name => user }
}

output "domain" {
  value = local.domain_name
}
output "user_name" {
  value = [for user in local.users : "${user.first_name} ${user.last_name}" ]
}

resource "azuread_user" "users" {
  for_each = local.users_map

  user_principal_name =  format("%s%s@%s",
  substr((each.value.first_name), 0, 1),
  lower(each.value.last_name),
  local.domain_name[0])

  password = random_password.password[each.key].result

  display_name = "${each.value.first_name} ${each.value.last_name}"
  force_password_change = true
  department = each.value.department
  job_title = each.value.job_title

}

resource "random_password" "password" {
  for_each = local.users_map
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}