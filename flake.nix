{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nur.url = "github:nix-community/NUR";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      spicetify-nix,
      stylix,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nur.overlays.default ];
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
    in
    {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/thinkpad/system.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          (
            { config, ... }:
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                stylixColors = config.lib.stylix.colors;
                inputs = {
                  inherit spicetify-nix;
                };
              };
              home-manager.users.rob = import ./home/common.nix;
              home-manager.backupFileExtension = "backup";
            }
          )
        ];
      };
    };
}
