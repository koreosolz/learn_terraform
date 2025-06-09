#!/bin/bash

# Usage: ./create_tf_project.sh ProjectDirectoryName

# Get directory name from argument
PROJECT_DIR=$1

# Validate input
if [ -z "$PROJECT_DIR" ]; then
  echo "❌ Please provide a project directory name."
  echo "Usage: ./create_tf_project.sh <ProjectDirectoryName>"
  exit 1
fi

# Create directory and move into it
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

# Create main.tf
cat <<EOF > main.tf
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
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
