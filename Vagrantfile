# -*- mode: ruby -*-
# vi: set ft=ruby :

# Define variables used in managing VM
# Name your VM - used in VirtualBox
VM_NAME = "lubuntu-datadev-vm"

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
		
		# Show VM GUI, defaults to headless
		v.gui = true
		# Set VM name in VirtualBox
		v.name = "#{VM_NAME}"
		
		# Define your 'hardware' specifications
		# Set RAM in MB, e.g. 8192 for 8GB
		v.customize ["modifyvm", :id, "--memory", 8192]
		# Set number of logical CPU cores
		v.customize ["modifyvm", :id, "--cpus", 4]
		# Set graphics controller settings
		v.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
		v.customize ["modifyvm", :id, "--vram", "256"]
		v.customize ["modifyvm", :id, "--accelerate3d", "on"]
		# Tweak VirtualBox preferences to allow automatic VM screen resizing
		v.customize ["setextradata", "global", "GUI/MaxGuestResolution", "auto"]
		
		# Explicitly disable audio and USB controllers
		v.customize ["modifyvm", :id, "--audio", "none"]
		v.customize ["modifyvm", :id, "--usb", "off"]
		
		# Misc. virtual hardware settings for performance optimisation
		v.customize ["modifyvm", :id, "--pae", "on"]
		v.customize ["modifyvm", :id, "--ioapic", "on"]
		v.customize ["modifyvm", :id, "--rtcuseutc", "on"]
		v.customize ["modifyvm", :id, "--hwvirtex", "on"]
		v.customize ["modifyvm", :id, "--nestedpaging", "on"]
		v.customize ["modifyvm", :id, "--largepages", "on"]
		
		# Configure VirtualBox Functionality
		v.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
		v.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
		v.customize ["modifyvm", :id, "--vrde", "off"]
		
		# Video Capture Settings - uncomment settings below to enable scree recording
		#v.customize ["modifyvm", :id, "--recording", "on"]
		#v.customize ["modifyvm", :id, "--recordingfile", "capture/ScreenCapture-#{Time.now.to_i}.webm"]
		#v.customize ["modifyvm", :id, "--recordingvideores", "1920x1080"]
		#v.customize ["modifyvm", :id, "--recordingvideofps", "25"]
		#v.customize ["modifyvm", :id, "--recordingvideorate", "1350"]
	
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
	config.vm.provision "shell", path: "scripts/common/upgrade.sh"

	# Install SDK mangers and other development tools
	config.vm.provision "shell", path: "scripts/common/devenv.sh", privileged: false

	# Specify Databricks Runtime Environment you are targeting for this VM
	# Supported values include 5.5, 6.0, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 7.0, 7.1
	# See link below for the latest Azure Databricks runtime release status
	# https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/releases
	DBR_VERSION = "6.4"
	config.vm.provision "shell", path: "scripts/databricks/databricks-dbr-sysenv.sh", privileged: false, args: [DBR_VERSION]

	# Install Databricks Tooling
	config.vm.provision "shell", path: "scripts/databricks/databricks-cli.sh", privileged: false
	config.vm.provision "shell", path: "scripts/databricks/databricks-connect.sh", privileged: false, args: [DBR_VERSION]
	config.vm.provision "shell", path: "scripts/databricks/databricks-simba-jdbc.sh", privileged: false, args: ["2.6.11.1014"]

	# Install IDEs
	config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["DBeaver SQL IDE","dbeaver-ce"]
	config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["IntelliJ IDEA CE", "intellij-idea-community", "--classic"]
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["PyCharm CE", "pycharm-community", "--classic"]
	config.vm.provision "shell", path: "scripts/gnu-r/rstudio.sh"
	config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["VSCode", "code", "--classic"]

	# Install Azure Tools
	config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["Azure Storage Explorer", "storage-explorer"]
	#config.vm.provision "shell", path: "scripts/azure/azure-cli.sh"
	#config.vm.provision "shell", path: "scripts/azure/azure-function-tools.sh"

	# Pre-install R packages
	# Install common libraries required for compiling R packages
	config.vm.provision "shell", path: "scripts/common/apt-installer.sh", args: ["R Package Dependencies", "libxml2-dev", "libcurl4-openssl-dev", "unixodbc-dev", "libv8-dev", "libmagick++-dev"] 
	# Install the packages - edit scripts/gnu-r/required-r-packages.csv to match your requirements
	# As packages get compiled from source you will need to ensure you have all relevant dependencies
	config.vm.provision "shell", path: "scripts/gnu-r/R-package-builder.sh", privileged: false, args: ["/vagrant/scripts/gnu-r/required-r-packages.csv", "~/gnu-r-package-install-log.csv"]
	# Install tools for Bayesian analysis
	#config.vm.provision "shell", path: "scripts/gnu-r/R-package-builder.sh", privileged: false, args: ["/vagrant/scripts/gnu-r/required-r-packages-stan.csv", "~/gnu-r-package-install-log-stan.csv"]
	#config.vm.provision "shell", path: "scripts/gnu-r/cmdstan.sh", args: ["2.23.0"]
	# You can install a version of R in addition to the one included in your Databricks environment set up
	# This will NOT be set as default and any packages will need to be installed separately
	#config.vm.provision "shell", path: "scripts/gnu-r/gnu-r.sh", privileged: false, args: ["4.0.2"]

	# Misc Development Tools
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["Colorpicker", "colorpicker-app"]
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["draw.io Diagram Tool", "drawio"]
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["Gisto Code Snippet Manager", "gisto"]
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["Insomnia API Client", "insomnia"]
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["Ksnip Screen Snipping Tool", "ksnip"]
	#config.vm.provision "shell", path: "scripts/common/apt-installer.sh", args: ["Meld Diff Tool", "meld"]
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["Postman API Client", "postman"]
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["Productivity Timer", "productivity-timer"]
	#config.vm.provision "shell", path: "scripts/common/apt-installer.sh", args: ["Various CLI Tools", "jq"]

	# Install RDBMS
	#config.vm.provision "shell", path: "scripts/common/apt-installer.sh", args: ["PostgreSQL DB", "postgresql",  "postgresql-contrib"]

	# Install documentation / static website generators
	#config.vm.provision "shell", path: "scripts/staticdocs/gitbook.sh", privileged: false
	#config.vm.provision "shell", path: "scripts/common/snap-installer.sh", args: ["Hugo Static Site Generator", "hugo", "--channel=extended"]
	#config.vm.provision "shell", path: "scripts/staticdocs/jekyll.sh", privileged: false
	#config.vm.provision "shell", path: "scripts/staticdocs/mkdocs.sh", privileged: false

	# User customisations
	# Review, uncomment and modify the customise.sh script as appropriate.
	#config.vm.provision "shell", path: "scripts/user/customize.sh", privileged: false

	# Rebooting system once all provisioning done
	config.vm.provision "shell", reboot: true, inline: <<-EOF
	echo "Your VM has now been provisioned. Rebooting!"
	EOF
end
