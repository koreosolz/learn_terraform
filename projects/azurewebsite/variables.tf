variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  description = "Admin username for the virtual machine"
}

variable "admin_password" {
  type      = string
  sensitive = true
}