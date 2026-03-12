locals {
subnets = [
    azurerm_subnet.sn1.id,
    azurerm_subnet.sn2.id
  ]

  network_interface_names = [
    "nic-1",
    "nic-2"
  ]

 vms = [
  {
    name = "vm1"
    nic = azurerm_network_interface.main[0].id
  }
  ,{
    name = "vm2"
    nic = azurerm_network_interface.main[1].id
  } 
 ]

   os_disk = [
    "myosdisk",
    "myosdisk2"
  ]

}


resource "azurerm_virtual_machine" "main" {
  count = length(local.vms)
  name                  = local.vms[count.index].name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name

  network_interface_ids = [
    local.vms[count.index].nic
    ]
    
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = local.os_disk[count.index]
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_network_interface" "main" {
  count = length(local.network_interface_names)
  name                = local.network_interface_names[count.index]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = local.subnets[count.index]
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_bastion_host" "bastion" {
  name                = "AzureBastionSubnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}