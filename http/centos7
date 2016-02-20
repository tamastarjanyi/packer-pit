#version=RHEL7
# System authorization information
auth --enableshadow --passalgo=sha512

# Use CDROM installation media
cdrom
# Run the Setup Agent on first boot
firstboot --enable
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s3 --ipv6=auto --activate
network  --hostname=localhost.localdomain
# Root password
rootpw --iscrypted $6$2qLe39y/SC1B81KG$ylw3tgq2OkqE1DopY57DjcoZfRpKrCOFcjPFi6TnmbZack/HnV99JVf4/KriboxOd1bRU/yFr6yNKAc7dElwQ/
# System timezone
timezone Europe/Budapest --isUtc
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --none --initlabel 
# Disk partitioning information
part / --fstype="ext4" --grow
part swap --fstype="swap" --size=1024

text
reboot

%packages --excludedocs
@core

%end


