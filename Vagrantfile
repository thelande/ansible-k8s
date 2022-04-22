# -*- mode: ruby -*-
# vi: set ft=ruby :

CONTROLLERS = 1
WORKERS = 2
PRIVATE_SUBNET = "192.168.33"
PROXY_IP = "#{PRIVATE_SUBNET}.2"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/focal64"

  config.vm.define "squid" do |node|
    node.vm.hostname = "squid"
    node.vm.network "private_network", ip: PROXY_IP
    node.vm.provision "shell", path: "scripts/setup_squid.sh", name: "setup_squid"
  end

  (1..WORKERS).each do |i|
    config.vm.define "worker-#{i}" do |node|
      node.vm.hostname = "worker-#{i}"
	  node.vm.network "private_network", ip: "#{PRIVATE_SUBNET}.#{100 + i}"

	  # Provisioning scripts
	  node.vm.provision "shell", path: "scripts/setup_proxy.sh", name: "setup_proxy",
	    args: PROXY_IP, reset: true
      node.vm.provision "shell", path: "scripts/setup_k8s_base.sh", name: "setup_k8s_base"
	end
  end

  (1..CONTROLLERS).reverse_each do |i|
    config.vm.define "control-#{i}" do |node|
      node.vm.hostname = "control-#{i}"
	  node.vm.network "private_network", ip: "#{PRIVATE_SUBNET}.#{10 + i}"

	  node.vm.provision "shell", path: "scripts/setup_proxy.sh", name: "setup_proxy",
	    args: PROXY_IP, reset: true
      node.vm.provision "shell", path: "scripts/setup_k8s_base.sh", name: "setup_k8s_base"

	  if i == 1
	    node.vm.provision "shell", path: "scripts/setup_control-1.sh", name: "setup_control-1"
	  end
	end
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Fix permissions for synced folder
  config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=0755,fmode=644,umask=022"]

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
  end
end
