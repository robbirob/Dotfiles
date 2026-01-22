{
  imports = [
    ./hardware.nix
    ../../system/common.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "thinkpad";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
