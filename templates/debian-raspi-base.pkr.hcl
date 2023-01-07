variable "name" {
    type              = string
    default           = "debian-raspi-base"
    description       = "The name of the image."
}

variable "username" {
    type              = string
    description       = "The username for the non-root user in the image."
    sensitive         = true
}

variable "password" {
    type              = string
    description       = "The password for the non-root user in the image."
    sensitive         = true
}

variable "pubkey" {
    type              = string
    description       = "The public key to copy to the image."
    sensitive         = true
}

locals {
    image_url         = "https://raspi.debian.net/tested/20230102_raspi_3_bullseye.img.xz"
    image_checksum    = "file:https://raspi.debian.net/tested/20230102_raspi_3_bullseye.img.xz.sha256"
    image_mounts      = ["/boot", "/"]

    locale            = "en_US.UTF-8"
    timezone          = "Europe/Amsterdam"
}

source "arm-image" "debian-bullseye" {
    iso_url           = local.image_url
    iso_checksum      = local.image_checksum
    image_mounts      = local.image_mounts

    resolv-conf       = "copy-host"

    output_filename   = "build/${var.name}.img"
}

build {
    name              = var.name
    sources           = ["source.arm-image.debian-bullseye"]

    provisioner "file" {
        source        = "./files/base/"
        destination   = "/tmp/packer"
    }

    provisioner "shell" {
        environment_vars = [
            "name=${var.name}",
            "locale=${local.locale}",
            "timezone=${local.timezone}",
            "username=${var.username}",
            "password=${var.password}",
            "pubkey=${var.pubkey}",
        ]
        scripts = [
            "./scripts/base/update.sh",
            "./scripts/base/localization.sh",
            "./scripts/base/accounts.sh",
            "./scripts/base/networking.sh",
            "./scripts/base/security.sh",
            "./scripts/base/logging.sh",
            "./scripts/base/access.sh",
        ]
    }
}
