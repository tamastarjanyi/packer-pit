packer-pit
==========

Linux [Packer](http://www.packer.io) templates and installation and configuration scripts.

# Supported images
- CentOS 7 
  - [x] Virtualbox with Vagrant and Ansible
  - [ ] QEMU with Vagrant and Ansible


# General Features
* Configurable Packer build via environtment variables (Check run.sh for used env vars.)
  * PACKER_PATH : Path of unextracted packer files
  * PACKER_WORKDIR : Path to the working dir. Cached files, Builder and Post-Processor outputs go under this by default.
  * PACKER_CONFIG : The path of the packer template file.
  * PACKER_ISO_URL : The url of the Linux ISO
  * PACKER_CACHE_DIR : Downloaded ISO file cache directory location. *Default: ${PACKER_WORKDIR}/packer_cache/*
  * PACKER_OUTPUT_DIRECTORY : Builder and Post-Processor file location. *Default: ${PACKER_WORKDIR}/packer_output/*
* http_proxy support
* [Vagrant](http://www.vagrantup.com) support
* [Ansible](http://www.ansible.com) included

# Known Issues

**EL7 Interface naming issue**

EL7(RedHat 7,CentOS 7, Fedora ) have changed its interface naming scheme. Older Vagrant versions need a fix.
Install the fix with:
> vagrant plugin install vagrant-centos7_fix
