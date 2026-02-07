{ ... }:

{
  # Steam needs the 32-bit graphics stack for many native/Linux + Proton titles.
  hardware.graphics.enable32Bit = true;

  programs.steam.enable = true;
}
