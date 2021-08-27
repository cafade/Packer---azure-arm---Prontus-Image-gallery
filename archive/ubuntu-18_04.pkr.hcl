## authentication variables ##
# variable "client-id" { description = "<CLIENT_iD aka appId>" }
# variable "client-secret" { description = "CLIENT_SECRET aka password" }
variable "subscription-id" { default = "dc7a0e24-be24-4628-a06e-efd67a37b68f" }

## source image variables ##
variable "image-offer" { default = "UbuntuServer" }
variable "image-publisher" { default = "Canonical" }
variable "image-sku" { default = "18.04-LTS" }

## managed image variables ##
variable "managed-image-name" { default = "UbuntuProntusMaster" }
variable "managed-image-rg" { default = "MasterVMImages" }
variable "os-type" { default = "Linux" }

## VM variables ##
variable "location" { default = "UK South" }
variable "vm-size" { default = "Standard_A4_v2" }

source "azure-arm" "Ubuntu-18-04" {
  azure_tags = {
    dept = "engineering"
    task = "image deployment"
  }
#  client_id                         = "${var.client-id}"
#  client_secret                     = "${var.client-secret}"
  image_offer                       = "${var.image-offer}"
  image_publisher                   = "${var.image-publisher}"
  image_sku                         = "${var.image-sku}"
  location                          = "${var.location}"
  managed_image_name                = "${var.managed-image-name}"
  managed_image_resource_group_name = "${var.managed-image-rg}"
  os_type                           = "${var.os-type}"
  subscription_id                   = "${var.subscription-id}"
  vm_size                           = "${var.vm-size}"
}

build {
  sources = ["source.azure-arm.Ubuntu-18-04"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = ["echo provisioning Prontus master VM image -- image: ${var.image-offer} version: ${var.image-sku} VM size: ${var.vm-size}",
              "apt-get update",
              "DEBIAN_FRONTEND=noninteractive apt-get upgrade -o Dpkg::Options::=--force-confold -o Dpkg::Options::=--force-confdef -y --allow-downgrades --allow-remove-essential --allow-change-held-packages",
              "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang = "/bin/sh -x"
  }

}
