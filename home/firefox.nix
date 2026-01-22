{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles = {
      rob = {
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ublock-origin
          darkreader
          vimium
          reddit-enhancement-suite
        ];
      };
    };
  };
}
