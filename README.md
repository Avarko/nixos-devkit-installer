# nixos-devkit-installer

Simple VMware friendly NixOS Linux installer

# Instructions

1. Download NixOS Minimal 64-bit ISO from https://nixos.org/download.html
2. Create a new VMware virtual machine (recommended 8 GB mem, 100 GB disk, "Virtualize Intel VT-x/EPT or AMD-V/RVI") with the ISO and start the VMware machine
3. `$ curl -L https://github.com/Avarko/nixos-devkit-installer/archive/main.zip -o install.zip`
4. `$ unzip install.zip`
5. `$ cd nixos-devkit-installer-main`
6. Set the passwords for root and 'devkit' users and store them in your own password safe (`$ nano env-params`)
7. `$ ./install.sh 2>&1 | tee install.log`
8. Read the log if you wish (`less install.log`)
9. If all seems fine, restart the machine: `reboot`