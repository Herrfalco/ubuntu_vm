Vagrant.configure("2") do |config|
  config.vm.box = "./packer/ubuntu-24.04-libvirt.box"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider "libvirt" do |libvirt|
    libvirt.cpu_mode = "host-passthrough"
    libvirt.memory = 16384
    libvirt.cpus = 8

    libvirt.video_type = "virtio"
    libvirt.graphics_type = "spice"
#    libvirt.graphics_gl = true
#    libvirt.video_accel3d = true
    libvirt.graphics_gl = false # for nvidia compatibility
    libvirt.video_accel3d = false # idem
    libvirt.graphics_autoport = true

    libvirt.sound_type = "ich9"
  end

  config.vm.provision "shell",
    env: { "DEBIAN_FRONTEND" => "noninteractive" },
    inline: <<-SHELL
      if ! dpkg -s puppet >/dev/null 2>&1; then
        sudo apt update -y
        sudo apt full-upgrade -y
        sudo apt install -y puppet
      fi
  SHELL

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = ["modules"]
  end
end
