{config, pkgs, ...}:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  isoImage.contents = [ 
    { source = ./copy-to-home; target = "/copy-to-home"; }
  ];

  boot.postBootCommands = ''
    cp /iso/copy-to-home/* /home/nixos
  '';

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "lat9w-16";
    keyMap = "fi";
  };

  environment.systemPackages = with pkgs; [
    git
    vim nano
    envsubst
  ];

  programs.fuse.userAllowOther = true;

  fileSystems."/vmware-mount" = {
    device = ".host:/";
    fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
    options = [ "umask=22" "uid=1000" "gid=1000" "allow_other" "nonempty" "nofail" "defaults" "auto_unmount" ];
  };

  virtualisation.vmware.guest.enable = true;  

  system.stateVersion = "20.09";
}

