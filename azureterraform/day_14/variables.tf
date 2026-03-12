variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  validation {
    condition     = contains(["eastus", "westeurope", "southeastasia"], var.location)
    error_message = "You can either select eastus, westeurope, or southeastasia"
  }
}

variable "environment" {
  description = "Environment of the configuration"
  type        = string
}

variable "vm_sizes" {
  type        = map(string)
  description = "type of VM size"
  default = {
    dev     = "Standard_B1s",
    staging = "Standard_B2s",
    prod    = "Standard_B2ms"
  }
}