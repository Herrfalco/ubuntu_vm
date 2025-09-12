packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.1.4"
    }
    vagrant = {
      source = "github.com/hashicorp/vagrant"
      version = ">= 1.1.6"
    }
  }
}

source "qemu" "ubuntu" {
  iso_url      = "https://releases.ubuntu.com/noble/ubuntu-24.04.3-live-server-amd64.iso"
  iso_checksum = "sha256:c3514bf0056180d09376462a7a1b4f213c1d6e8ea67fae5c25099c6fd3d8274b"
  output_directory   = "output/ubuntu-24.04-libvirt"
  shutdown_command   = "echo 'packer' | sudo -S shutdown -P now"

  # Réseau & CPU
  accelerator        = "kvm"
  cpus              = 8
  memory            = 16384
  disk_size         = "250G"
  format            = "qcow2"

  # Communicator SSH
  communicator         = "ssh"
  ssh_username         = "vagrant"
  ssh_private_key_file = "~/.vagrant.d/insecure_private_keys/vagrant.key.ed25519"
  ssh_timeout          = "60m"
  ssh_agent_auth       = false

  # CIDATA: cloud-init user-data + meta-data
  cd_files = [
    "cloudinit/user-data",
    "cloudinit/meta-data"
  ]
  cd_label = "cidata"

  # Console visible pour debug
  headless          = false
  boot_wait         = "5s"
  boot_key_interval = "20ms"

  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end><wait>",
    " autoinstall locale=en_US keyboard-configuration/layoutcode=us ---",
    "<f10>"
  ]
}

build {
  name    = "ubuntu-24.04-libvirt"
  sources = ["source.qemu.ubuntu"]

  post-processor "vagrant" {
    output = "ubuntu-24.04-libvirt.box"
  }
}
