# Partition and mount disk
sudo parted /dev/sda -- mklabel msdos
sudo parted /dev/sda -- mkpart primary 1MiB -8GiB
sudo parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
sudo mkfs.ext4 -L nixos /dev/sda1
sudo mkswap -L swap /dev/sda2
sleep 1
sudo mount /dev/disk/by-label/nixos /mnt

# Generate /mnt/etc/nixos/hardware-configuration.nix
sudo nixos-generate-config --root /mnt

# Copy initial NixOS configuration.nix to the mounted disk
sudo cp configuration.nix /mnt/etc/nixos/configuration.nix

# Install NixOS on the disk
nixos-install --show-trace

#shutdown -r now

