# -*- mode: ruby -*-
# vi: set ft=ruby :

# Define variables used in managing VM
# Name your VM - used in VirtualBox
VM_NAME = "datadev-vm"

Vagrant.require_version ">= 2.2.7"

Vagrant.configure("2") do |config|

	# Set VM name and specify box template to use
	config.vm.define VM_NAME
	config.vm.box = "artislismanis/lubuntu-20.04"
	
	# Set VM specification
	config.vm.provider :virtualbox do |v, override|
		
		# See links below for full reference
		# https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
		# https://www.virtualbox.org/manual/ch08.html#vboxmanage-extradata
		
		# Show VM GUI	
		v.gui = true
		
		# Give VM a unique nam in VirtualBox
		v.name = "#{VM_NAME}-#{Time.now.to_i}"
		
		# Set RAM in MB
		v.customize ["modifyvm", :id, "--memory", 8192]
		
		# Set number of logical CPU cores
		v.customize ["modifyvm", :id, "--cpus", 4]
		
		# Set Graphics settings
		v.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
		
		v.customize ["modifyvm", :id, "--vram", "256"]
		v.customize ["modifyvm", :id, "--accelerate3d", "on"]
		# Tweak VirtualBox Preference to allow automatic VM screen resizing
		v.customize ["setextradata", "global", "GUI/MaxGuestResolution", "auto"]
		
		# Audio
		v.customize ["modifyvm", :id, "--audio", "none"]
		
		# USB Controller
		v.customize ["modifyvm", :id, "--usb", "off"]
		
		# Other hardware config items
		v.customize ["modifyvm", :id, "--pae", "on"]
		v.customize ["modifyvm", :id, "--ioapic", "on"]
		v.customize ["modifyvm", :id, "--rtcuseutc", "on"]
		v.customize ["modifyvm", :id, "--hwvirtex", "on"]
		v.customize ["modifyvm", :id, "--nestedpaging", "on"]
		v.customize ["modifyvm", :id, "--largepages", "on"]
		
		# VirtualBox Functionality
		v.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
		v.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
		v.customize ["modifyvm", :id, "--vrde", "off"]
		
		# Video Capture Settings
		v.customize ["modifyvm", :id, "--recording", "off"]
		v.customize ["modifyvm", :id, "--recordingfile", "capture/ScreenCapture.webm"]
		v.customize ["modifyvm", :id, "--recordingvideores", "1920x1080"]
		v.customize ["modifyvm", :id, "--recordingvideofps", "25"]
		v.customize ["modifyvm", :id, "--recordingvideorate", "1350"]
		
	end
	
	# Vagrant VM Management Settings
	
	# Set VM hostname to VM name variable
	config.vm.hostname = VM_NAME

	# Additional shared folders
	config.vm.synced_folder "./hostshare", "/home/vagrant/hostshare"
	
	# Port forwarding - Standard HTTP/HTTPS ports example
	# config.vm.network "forwarded_port", guest: 80, host: 80
	# config.vm.network "forwarded_port", guest: 443, host: 443
	
	# Provision your VM
	
	# Update package list, install any available upgrades
	config.vm.provision "shell", path: "scripts/upgrade.sh"
	
	# Install tools for managing JDKs, SDKs and development tools
	config.vm.provision "shell", path: "scripts/devenv.sh", privileged: false

	# Install Databricks Tooling
	# Specify Databricks Runtime Environment you are targeting
	# Supported values include 6.5
	DBR_VERSION = "6.5"
	config.vm.provision "shell", path: "scripts/databricks/databricks-dbr-sysenv.sh", privileged: false, args: [DBR_VERSION]
	config.vm.provision "shell", path: "scripts/databricks/databricks-cli.sh", privileged: false
	config.vm.provision "shell", path: "scripts/databricks/databricks-connect.sh", privileged: false
	config.vm.provision "shell", path: "scripts/databricks/databricks-simba-jdbc.sh"
end
