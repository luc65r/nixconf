{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = { self, nixpkgs, home-manager, emacs }: {
    nixosConfigurations = {
      sally = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/sally
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.registry.nixpkgs.flake = nixpkgs;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.lucas = import ./home "sally";
            };
          }

          {
            nixpkgs.overlays = [ emacs.overlay ];
          }
        ];
      };

      flash = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/flash
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.registry.nixpkgs.flake = nixpkgs;
          }

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.lucas = import ./home "flash";
            };
          }

          {
            nixpkgs.overlays = [ emacs.overlay ];
          }
        ];
      };
    };
  };
}
