resource "azuread_group" "education" {
  display_name     = "Education Department"
  security_enabled = true
}

resource "azuread_group_member" "education" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.department == "Education" }

  group_object_id  = azuread_group.education.id
  member_object_id = each.value.id
}

resource "azuread_group" "manager" {
  display_name     = "Managers Department"
  security_enabled = true
}

resource "azuread_group_member" "manager" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.job_title == "Manager" }

  group_object_id  = azuread_group.manager.id
  member_object_id = each.value.id
}

resource "azuread_group" "engineer" {
  display_name     = "Engineer Department"
  security_enabled = true
}

resource "azuread_group_member" "engineer" {
  for_each = { for u in azuread_user.users: u.mail_nickname => u if u.job_title == "Engineer" }

  group_object_id  = azuread_group.engineer.id
  member_object_id = each.value.id
}