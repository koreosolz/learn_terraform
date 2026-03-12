#!/bin/bash

#Usage: ./newday.sh Day

# Get the directory name of the argument
PROJECT_DIR=$1

# Validate input
if [ -z "$PROJECT_DIR" ]; then 
    echo "❌ Please provide a project directory name."
    echo "Usage: ./newday.sh <Day_#>"
    exit 1
fi

# $1 is the first argument passed to the script.
# -z "$1" checks if it's empty.
# If not provided, it prints usage and exits.
# $0 refers to the script's name, so the message looks like:
# Usage: ./newday.sh <Day_#>


# Create directory and move into it
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

# mkdir -p creates the directory, and does nothing if it already exists.
# cd moves into the directory.
# || exit means “if cd fails, exit the script.”

#Create main.tf
cat <<EOF > main.tf
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
EOF

# Create resources.tf
cat <<EOF > resources.tf
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.33.0"
    }
  }

  required_version = ">=1.9.0"
}

provider "azurerm" {
  features {
  }
}
EOF

# Create variables.tf 

cat <<EOF > variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}
EOF

# Create outputs.tf
cat <<EOF > outputs.tf
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
EOF

# Create terraform.tfvars
cat <<EOF > terraform.tfvars
resource_group_name = "my-tf-rg"
location            = "australiaeast"
EOF

echo "✅ Terraform project scaffolded in: $PROJECT_DIR"