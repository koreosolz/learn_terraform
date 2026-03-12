locals {
    nsg_rules = {
    "allow_http_public" = {
      priority                   = 100
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "80"
      source_address_prefix      = "*"         # Internet
      destination_address_prefix = "*"
      description                = "Allow HTTP from Internet"
    },
    "allow_lb_probe" = {
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "80"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
      description                = "Allow Azure LB health probes"
    },
    "allow_https" = {
      priority                   = 102
      access                     = "Allow"
      protocol                   = "Tcp"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Allow HTTPS from Internet"
    },
    "deny_all" = {
      priority                   = 4096
      access                     = "Deny"
      protocol                   = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "Deny everything else"
    },
  }
}