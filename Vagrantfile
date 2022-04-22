# -*- mode: ruby -*-
# vi: set ft=ruby :

CONTROLLERS = 1
WORKERS = 2

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
    node.vm.network "private_network", ip: "192.168.33.2"
    node.vm.provision "shell", inline: <<-SCRIPT
        apt update
        apt install -y squid
        echo "maximum_object_size 1024 MB" > /etc/squid/conf.d/disk_cache.conf
        echo "cache_dir aufs /var/spool/squid 5000 24 256" >> /etc/squid/conf.d/disk_cache.conf
        echo "acl localnet src 192.168.33.0/24" >> /etc/squid/conf.d/disk_cache.conf
        sed -i 's/^#http_access allow localnet/http_access allow localnet/' /etc/squid/conf.d/debian.conf
        systemctl restart squid
    SCRIPT
  end

  (1..WORKERS).each do |i|
    config.vm.define "worker-#{i}" do |node|
      node.vm.hostname = "worker-#{i}"
	  node.vm.network "private_network", ip: "192.168.33.#{100 + i}"

      node.vm.provision "shell", inline: <<-SCRIPT
        export http_proxy=http://192.168.33.2:3128
        apt update
        apt install -y python3-pip
      SCRIPT
	end
  end

  (1..CONTROLLERS).each do |i|
    config.vm.define "control-#{i}" do |node|
      node.vm.hostname = "control-#{i}"
	  node.vm.network "private_network", ip: "192.168.33.#{10 + i}"

	  if i == CONTROLLERS
	    node.vm.provision "shell", inline: <<-SCRIPT
          export http_proxy=http://192.168.33.2:3128
	      apt update
	      apt install -y python3-venv python3-pip
	      sudo -u vagrant rsync -av /vagrant/.vagrant /home/vagrant
	      find /home/vagrant/.vagrant -name private_key -print -exec chmod 600 {} \\;
	      sudo -u vagrant python3 -m venv /home/vagrant/venv
	      sudo -u vagrant /home/vagrant/venv/bin/pip install -U pip
	      sudo -u vagrant /home/vagrant/venv/bin/pip install wheel
	      sudo -u vagrant /home/vagrant/venv/bin/pip install 'ansible<5.0.0' netaddr
        SCRIPT
      else
        node.vm.provision "shell", inline: <<-SCRIPT
          export http_proxy=http://192.168.33.2:3128
          apt update
          apt install -y python3-pip
        SCRIPT
	  end
	end
  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
  
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
