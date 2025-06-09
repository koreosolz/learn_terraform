resource_group_name = "my-tf-rg"
location            = "australiaeast"
vm_size             = "Standard_B1s"
admin_username      = "azureuser"
admin_ssh_key       = "~/.ssh/tf_key.pub"

vm_names = [
  "vm1",
  "vm2",
  "vm3"
]
