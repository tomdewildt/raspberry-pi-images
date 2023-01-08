variable "name" {
    type            = string
    default         = "debian-raspi-livecam"
    description     = "The name of the image."
}

variable "address" {
    type            = string
    default         = "0.0.0.0/0"
    description     = "The ip address for unauthenticated access to the webserver in the image."
}

locals {
    image_url       = "https://github.com/tomdewildt/raspberry-pi-images/releases/latest/download/debian-raspi-base.img.xz"
    image_checksum  = "file:https://github.com/tomdewildt/raspberry-pi-images/releases/latest/download/debian-raspi-base.img.xz.sha256"
    image_mounts    = ["/boot", "/"]

    camera_name     = "Livecam"
    camera_width    = 1280
    camera_height   = 720
    camera_fps      = 30
    camera_quality  = 75
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

    provisioner "file" {
        source      = "./files/livecam/"
        destination = "/tmp/packer"
    }

    provisioner "shell" {
        environment_vars = [
            "name=${var.name}",
            "address=${var.address}",
            "camera_name=${local.camera_name}",
            "camera_width=${local.camera_width}",
            "camera_height=${local.camera_height}",
            "camera_fps=${local.camera_fps}",
            "camera_quality=${local.camera_quality}",
        ]
        scripts = [
            "./scripts/livecam/livecam.sh",
            "./scripts/livecam/common.sh",
        ]
    }
}
