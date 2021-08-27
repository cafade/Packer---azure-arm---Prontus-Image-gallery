## authentication variables ##
variable "client-id" { default = "8933d934-abcf-43fa-b2a2-eef077caf9cc" }
variable "client-secret" { default = "BAc9d52to2r8~0PlVQHigmv66Rz8q_UPFF" }
variable "subscription-id" { default = "dc7a0e24-be24-4628-a06e-efd67a37b68f" }

## source image variables ##
variable "image-offer" { default = "UbuntuServer" }
variable "image-publisher" { default = "Canonical" }
variable "image-sku" { default = "20.04-LTS" }

## managed image variables ##
variable "managed-image-name" { default = "UbuntuProntusMaster" }
variable "managed-image-rg" { default = "MasterVMImages" }
variable "os-type" { default = "Linux" }

## VM variables ##
variable "location" { default = "UK South" }
variable "vm-size" { default = "Standard_A4_v2" }
variable "skip-clean" { default = false }

source "azure-arm" "Ubuntu-20-04" {
  azure_tags = {
    dept = "engineering"
    task = "image deployment"
  }
  client_id                         = "${var.client-id}"
  client_secret                     = "${var.client-secret}"
  image_offer                       = "${var.image-offer}"
  image_publisher                   = "${var.image-publisher}"
  image_sku                         = "${var.image-sku}"
  location                          = "${var.location}"
  managed_image_name                = "${var.managed-image-name}"
  managed_image_resource_group_name = "${var.managed-image-rg}"
  os_type                           = "${var.os-type}"
  subscription_id                   = "${var.subscription-id}"
  vm_size                           = "${var.vm-size}"
  skip_clean                        = "${var.skip-clean}"
}

build {
  sources = ["source.azure-arm.Ubuntu-20-04"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = ["echo provisioning Prontus master VM image -- image: ${var.image-offer} version: ${var.image-sku} VM size: ${var.vm-size}",
              "apt-get update",
              "apt-get upgrade -y",
              "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang = "/bin/sh -x"
  }

}
