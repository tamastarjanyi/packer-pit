packer-pit
==========

Linux [Packer](http://www.packer.io) templates and installation and configuration scripts.

# Supported images
- CentOS 7 
  - [x] Virtualbox with Vagrant and Ansible
  - [x] QEMU with Vagrant and Ansible
- Centos 6
  - [x] Virtualbox with Vagrant and Ansible
  - [ ] QEMU with Vagrant and Ansible

# General Features
* Configurable Packer build via environment variables (Check run.sh for used env vars.)
  * PACKER\_PATH : Path of unextracted packer files. **Default: ${HOME}/packer**
  * PACKER\_WORKDIR : Path to the working dir. Cached files, Builder and Post-Processor outputs go under this by default. **Default: ${PACKER_PATH}/workdir**
  * PACKER\_CONFIG : The path of the packer template file. **Default: templates/centos7.json**
  * PACKER\_ISO_URL : The url of the Linux ISO
  * PACKER\_CACHE'_DIR : Downloaded ISO file cache directory location. **Default: ${PACKER_WORKDIR}/packer_cache/**
  * PACKER\_OUTPUT\_DIRECTORY : Builder and Post-Processor file location. **Default: ${PACKER_WORKDIR}/packer_output/**
  * PACKER\_IMAGE\_SIZE\_MB : The size of the final image in MB. **Default: 5000**
  * PACKER_VMW_REMOTE_HOST, PACKER_VMW_REMOTE_USER, PACKER_VMW_REMOTE_PASSWORD for WMVARE build
* http_proxy support via http_proxy and https_proxy environment variables.
* [Vagrant](http://www.vagrantup.com) support
* [Ansible](http://www.ansible.com) included

# Usage

* **export** every variable you want to overwrite than use run.sh

```
export PACKER_TEMPLATE=templates/centos7.json
export PACKER_ISO_URL="http://ftp.freepark.org/pub/linux/distributions/centos/7/isos/x86_64/CentOS-7.0-1406-x86_64-Minimal.iso"
./run.sh
```

* Or use the **user interface** than sit back and wait
```
./run.sh --ui
```
# Important information

* root user is created and password is set to root **BUT root account is locked**
* vagrant user is created and password is ```vagrant```
* vagrant is allowed to ```sudo bash``` to became root without any password
* vagrant user can log in with the official vagrant public/private key

# Known Issues

**EL7 Interface naming issue**

EL7(RedHat 7+,CentOS 7+, Fedora 19+) have [changed its interface naming scheme](http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/). So [older Vagrant versions](https://github.com/mitchellh/vagrant/pull/4195) need a fix.
Install the fix with:
> vagrant plugin install vagrant-centos7_fix
