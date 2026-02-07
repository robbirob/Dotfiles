{
  imports = [
    ./hardware.nix
    ../../system/common.nix
    ../../system/steam.nix
  ];

  hardware.enableRedistributableFirmware = true;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelModules = [
    "kvm-intel"
    "thinkpad_acpi"
  ];
  boot.kernelParams = [
    "thinkpad_acpi.hotkey=1"
  ];

  systemd.tmpfiles.rules = [
    "w /sys/devices/platform/thinkpad_acpi/hotkey_mask - - - - 0xffffffff"
  ];

  networking.hostName = "thinkpad";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
