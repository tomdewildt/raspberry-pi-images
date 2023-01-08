# Raspberry Pi Images
[![Version](https://img.shields.io/github/v/release/tomdewildt/raspberry-pi-images?label=version)](https://github.com/tomdewildt/raspberry-pi-images/releases)
[![Build](https://img.shields.io/github/actions/workflow/status/tomdewildt/raspberry-pi-images/ci.yml?branch=master)](https://github.com/tomdewildt/raspberry-pi-images/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/actions/workflow/status/tomdewildt/raspberry-pi-images/cd.yml?label=release)](https://github.com/tomdewildt/raspberry-pi-images/actions/workflows/cd.yml)
[![License](https://img.shields.io/github/license/tomdewildt/raspberry-pi-images)](https://github.com/tomdewildt/raspberry-pi-images/blob/master/LICENSE)

Configuration for creating my [Raspberry Pi](https://www.raspberrypi.org/) images using [HashiCorp Packer](https://developer.hashicorp.com/packer).

# How to run

Prerequisites:
* packer version ```1.8.5``` or later

### Production

1. Run ```sudo make init``` to initialize the environment.
2. Run ```sudo make build``` to build the image.

The `packer-plugin-arm-image` used to create the images requires `root` access, so all `init` and `build` commands need to be prefixed with `sudo`.

# References

[Packer Docs](https://developer.hashicorp.com/packer/docs)

[Packer Arm Docs](https://github.com/solo-io/packer-plugin-arm-image)

[Packer Templates Docs](https://developer.hashicorp.com/packer/docs/templates/hcl_templates)

[Debian Docs](https://www.debian.org/doc/)

[Raspberry Pi Docs](https://www.raspberrypi.com/documentation/)
