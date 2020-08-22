# lubuntu-datadev-vm

## What is this?

A set of Vagrant VirtualBox provisioning scripts for [a lightweight Lubuntu based VM](https://github.com/artislismanis/packer-template) targeted primarily at [Azure Databricks](https://azure.microsoft.com/en-gb/services/databricks/) data development using Python, R, Scala and SQL. Optionally includes a curated set of additional development tools and utilities.

The code has been tested and working using [Vagrant 2.2.7](https://releases.hashicorp.com/vagrant/2.2.7/) and [VirtualBox 6.1.10](https://download.virtualbox.org/virtualbox/6.1.10/) on a Windows 10 machine.

## Why do I need it?

Skip the step where you need to become a Linux System Administrator before you can write your first line of code and get started quickly with all the key tools already pre-installed. This is also a safe, self-contained and throwaway environment for experimenting without affecting your host system.

## OK, how do I get started?

1. Make sure you have a recent version of Vagrant and VirtualBox installed and working on your system.

2. Clone or download this repository.

    ```shell
    git clone git://github.com/artislismanis/lubuntu-datadev-vm.git
    ```

3. While the default configuration will produce a fully working development environment it is a good practice to review the Vagrantfile, adjust VM settings and provisioning options to suit your preferences. Your check-list could look like this:

    1. Set VM name and configure CPU, RAM and graphics settings to suit your host hardware.
    2. Specify the Databricks Runtime environment you are targeting, defaults to the current LTS version.
    3. Review available provisioning steps and uncomment / comment out any features as required. Note that R packages are compiled from source and the process can take considerable time. If you specify additional packages, you need to ensure you also install any system dependencies.
    4. Review provided user customisations script which provides some examples of how this could be used to personalise the VM.

4. Open command line in the root of the project folder and run:

    ```shell
    vagrant up
    ```

    You will be prompted to install `vagrant-vbguest` Vagrant plugin if it hasn't been installed already. This is a useful plugin to keep Virtual Box Guest Additions up to date and in line with your version of Virtual Box. You will need to run `vagrant up` again after the plugin has been installed.

5. Wait for the provisioning to finish. End to end provisioning with provided defaults takes around 20 minutes, provisioning all features takes around 1.5h. Once the system has been provisioned use the default vagrant log-in details (vagrant:vagrant) to access and use the system.

## What else?

The main concept behind this VM is to target system environment as similar to specific Databricks Runtime as possible (see [release notes](https://docs.microsoft.com/en-us/azure/databricks/release-notes/runtime/releases)). This is achieved using various development environment management tools like [Miniconda](https://docs.conda.io/en/latest/miniconda.html), [SDKMan!](https://sdkman.io/), [NVM](https://github.com/nvm-sh/nvm) and [RVM](https://rvm.io/) which can also be used to easily adapt this VM your more general software development needs.

Tools like Databricks Connect and Databricks CLI are pre-installed in a Python environment that targets the Databricks Runtime specified during provisioning. This can be accesses by running the following on the command line:

  ```shell
  conda activate databricks
  ```

Read relevant documentation to understand how to configure these tools to work with your Databricks cluster.

More detail what's included and step-by-step getting started guides will be provided over time in the [project wiki](https://github.com/artislismanis/lubuntu-datadev-vm/wiki). In the meantime check out 'Useful Resources' section below if you get stuck.

## Useful Resources

- [VirtualBox Manual](https://www.virtualbox.org/manual/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)
- [Azure Databricks CLI Documentation](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/)
- [Azure Databricks Connect Documentation](https://docs.microsoft.com/en-us/azure/databricks/dev-tools/databricks-connect)
