NIXOS_DEVKIT_INSTALLER_PARAMS_MOUNT_DIR="/vmware-mount/nixos-devkit-installer-params"
SSH_KEYS_DIR="$NIXOS_DEVKIT_INSTALLER_PARAMS_MOUNT_DIR/ssh-keys"
ENV_PARAMS="$NIXOS_DEVKIT_INSTALLER_PARAMS_MOUNT_DIR/env-params"

# Ensure that /mnt/hgfs/nixos-devkit-installer-params exists
if [ ! -d "$NIXOS_DEVKIT_INSTALLER_PARAMS_MOUNT_DIR" ] 
then
    echo "VMware Shared directory nixos-devkit-installer-params is not mounted." 
    exit 1
fi
if [ ! -d "$SSH_KEYS_DIR" ]
then
    echo "VMware Shared directory nixos-devkit-installer-params does not contain ssh-keys" ]
    exit 1
fi
if [ ! -f "$ENV_PARAMS" ]
then
    echo "VMware Shared directory nixos-devkit-installer-params does not contain file env-params" ]
    exit 1
fi

source "$ENV_PARAMS"
if [ -z ${DEVKIT_USERNAME+x} ]
then
    echo "env-params in VMware Shared directory nixos-devkit-installer-params does not contain DEVKIT_USERNAME"
    exit 1
fi

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

# Fill the NixOS configuration.nix with env-params and copy to the mounted disk
envsubst -i configuration.nix.template -o configuration.nix
sudo cp configuration.nix /mnt/etc/nixos/configuration.nix

# Create a user directory with .ssh, copy keys
sudo mkdir -p "/mnt/home/$DEVKIT_USERNAME/.ssh"
sudo cp -R "$SSH_KEYS_DIR/." "/mnt/home/$DEVKIT_USERNAME/.ssh/"
sudo chmod 600 "/mnt/home/$DEVKIT_USERNAME/.ssh/*"
sudo chmod 700 "/mnt/home/$DEVKIT_USERNAME/.ssh"

# Install NixOS on the disk
nixos-install --show-trace

#shutdown -r now

