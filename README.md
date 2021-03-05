# What is it?
LiteArch.Lab is collection of shell scripts, the scripts will provision nomad and consul cluster.
The scripts are easily customizable to change the number of servers and clients.

# What is it not?
It's not PROD setup.

# Requirements
1. Ubuntu: It's been tested with Ubuntu Focal 
2. Ubuntu Awesome Hypervisor: [https://multipass.run/](https://multipass.run/)

# How to use?
To install Lab cluster run the following command in the project directory:

`./install.sh`

Give it some time (with 6 VMs it takes up to 20 minutes)

# Access the cluster?
After the installation is complete, the links to Nomad, Fabio and Consul can be extracted by running the following command:

`./info.sh`

