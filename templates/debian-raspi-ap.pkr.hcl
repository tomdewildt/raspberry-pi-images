variable "name" {
    type            = string
    default         = "debian-raspi-ap"
    description     = "The name of the image."
}

variable "network_gateway_ip" {
    type            = string
    default         = "192.168.1.1"
    description     = "The static IP address for the bridge interface (acts as gateway)."
}

variable "network_subnet_mask" {
    type            = string
    default         = "255.255.255.0"
    description     = "The subnet mask for the network."
}

variable "dhcp_range_start" {
    type            = string
    default         = "192.168.1.100"
    description     = "The start IP address for the DHCP range."
}

variable "dhcp_range_end" {
    type            = string
    default         = "192.168.1.254"
    description     = "The end IP address for the DHCP range."
}

variable "network_name" {
    type            = string
    description     = "The name for the wireless access point."
    sensitive       = true
}

variable "network_password" {
    type            = string
    description     = "The password for the wireless access point."
    sensitive       = true
}

locals {
    image_url       = "https://github.com/tomdewildt/raspberry-pi-images/releases/latest/download/debian-raspi-base.img.xz"
    image_checksum  = "file:https://github.com/tomdewildt/raspberry-pi-images/releases/latest/download/debian-raspi-base.img.xz.sha256"
    image_mounts    = ["/boot", "/"]
}

source "arm-image" "debian-bullseye" {
    iso_url         = local.image_url
    iso_checksum    = local.image_checksum
    image_mounts    = local.image_mounts

    resolv-conf     = "copy-host"

    output_filename = "build/${var.name}.img"
}

build {
    name            = var.name
    sources         = ["source.arm-image.debian-bullseye"]

    provisioner "shell" {
        environment_vars = [
            "name=${var.name}",
            "network_gateway_ip=${var.network_gateway_ip}",
            "network_subnet_mask=${var.network_subnet_mask}",
            "dhcp_range_start=${var.dhcp_range_start}",
            "dhcp_range_end=${var.dhcp_range_end}",
            "network_name=${var.network_name}",
            "network_password=${var.network_password}",
        ]
        scripts = [
            "./scripts/ap/ap.sh",
            "./scripts/ap/common.sh",
        ]
    }
}