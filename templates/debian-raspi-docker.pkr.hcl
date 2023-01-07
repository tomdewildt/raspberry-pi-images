variable "name" {
    type              = string
    default           = "debian-raspi-docker"
    description       = "The name of the image."
}

variable "username" {
    type              = string
    description       = "The username to add to the docker group in the image."
    sensitive         = true
}

locals {
    image_url         = "https://github.com/tomdewildt/raspberry-pi-images/releases/download/v0.1.0/debian-raspi-base.img.xz"
    image_checksum    = "file:https://github.com/tomdewildt/raspberry-pi-images/releases/download/v0.1.0/debian-raspi-base.img.xz.sha256"
    image_mounts      = ["/boot", "/"]
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

    provisioner "shell" {
        environment_vars = [
            "name=${var.name}",
            "username=${var.username}",
        ]
        scripts = [
            "./scripts/docker/common.sh",
            "./scripts/docker/docker.sh",
        ]
    }
}
