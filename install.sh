ENV_PARAMS="./env-params"

if [ ! -f "$ENV_PARAMS" ]
then
    echo "File $ENV_PARAMS not found." ]
    exit 1
fi

source "$ENV_PARAMS"
if [ -z ${DEVKIT_USERNAME+x} ]
then
    echo "File $ENV_PARAMS does not contain DEVKIT_USERNAME"
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

# Create a user directory (not really necessary)
sudo mkdir -p "/mnt/home/$DEVKIT_USERNAME"

# Install NixOS on the disk
nixos-install --show-trace >install.log 2>&1

echo "Installation done."
echo "Please check the log (less install.log) if you wish."
echo "Then restart the machine: shutdown -r now"


