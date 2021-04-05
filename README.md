# nixos-devkit-installer

VMware friendly NixOS Linux installer ISO and scripts

# The overall installation process

Grow your own NixOS based devkit through a bootstrapping process:
1. Birth of a VM:   from small ISO to new disk-bootable non-GUI VMware VM
2. Configure NixOS: select & build your desired NixOS Linux configuration
3. Devkit ready:    start using your devkit!

# Instructions

## First phase: birth of a VM

1. Download the `nixos-devkit-installer.iso`, pre-built from this same git repo
2. Prepare a devkit-mountable host directory for injection of secrets and parameters ([https://github.com/Avarko/nixos-devkit-installer/wiki/nixos-devkit-installer-params])
3. Create and boot a new VMware virtual machine ([https://github.com/Avarko/nixos-devkit-installer/wiki/vmware-machine-creation])
4. When the VM has booted, read README (`cat README`) and execute `./git-clone-installer.sh`
5. `cd nixos-devkit-installer`
6. `cat README.md` -- and you are reading this file inside the installer-VM
7. Ensure that your secrets are mounted: `ls /mnt/hgfs/nixos-devkit-installer-secrets`
8. `install.sh`
9. Read the log (`less install-log.sh`)
10. If all seems fine, restart the machine: `sudo shutdown -r now`

## Second phase: configure NixOS

TBD

## Third phase: devkit ready

TBD
