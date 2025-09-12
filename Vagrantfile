Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider "libvirt" do |libvirt|
    libvirt.cpu_mode = "host-passthrough"
    libvirt.memory = 16384
    libvirt.cpus = 8

    libvirt.video_type = "virtio"
    libvirt.video_accel3d = true
    libvirt.graphics_type = "spice"
    libvirt.graphics_gl = true
    libvirt.graphics_autoport = true
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update -y
    sudo apt full-upgrade -y
    sudo do-release-upgrade -y
    sudo apt install -y puppet
  SHELL

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = ["modules"]
  end
end
