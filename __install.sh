#!/usr/bin/env nix-shell
#!nix-shell -p envsubst
#!nix-shell -i bash

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

# Create a user directory and copy artefacts for second phase of installation
DEVKIT_HOME="/mnt/home/$DEVKIT_USERNAME"
SECRETS_DIR="$DEVKIT_HOME/.config/personal-devkit-nonsecrets"
sudo mkdir -p "$SECRETS_DIR"
echo $LASTPASS_USERID | sudo tee "$SECRETS_DIR/lastpass-userid" > /dev/null
sudo cp -R nixos-devkit "$DEVKIT_HOME"
sudo chown -R 1000:1000 "$DEVKIT_HOME"

# Install NixOS on the disk
while true
do
  sudo nixos-install --show-trace --no-root-passwd
  EXITCODE=$?
  if [ $EXITCODE == 0 ]
  then
    break
  else
    sudo find /mnt/nix/store -iname *.lock | sudo nix-store --repair-path "/nix/store/$(xargs -I{} basename {} .lock)"
  fi
done

sudo ln -s /run/current-system/sw/bin/bash /mnt/bin/bash

echo "Installation done. Restart the machine."


