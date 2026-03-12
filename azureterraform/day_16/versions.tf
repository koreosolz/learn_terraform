terraform {
  required_providers {
    azuread = {
        source = "hashicorp/azuread"
        version = "2.41.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  # Nothing else needed if you use env variables
}