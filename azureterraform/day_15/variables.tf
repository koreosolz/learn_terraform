variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "p1" {
  description = "Peer 1 name"
  type = string
}

variable "p2" {
  description = "Peer 2 name"
  type = string
}

variable "admin_username" {
  description = "vm admin username"
  type = string
}

variable "admin_password" {
  description = "vm admin password"
  type = string
}

