{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs.url = "github:nix-community/emacs-overlay";
    impermanence = {
      url = "github:nix-community/impermanence";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs, impermanence }: {
    nixosConfigurations = {
      sally = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs.host = {
          name = "sally";
          type = "laptop";
          keymap = "bepo";
          wm = "sway";
        };

        modules = [
          ./hosts/sally
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.registry.nixpkgs.flake = nixpkgs;
          }

          (import "${impermanence}/nixos.nix")

          home-manager.nixosModules.home-manager
          ({ host, ... }: {
            options.home-manager.users = with nixpkgs.lib; mkOption {
              type = with types; attrsOf (submoduleWith {
                modules = [ ];
                specialArgs = {
                  inherit host;
                };
              });
            };
          })
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.lucas = import ./home;
            };
          }

          {
            nixpkgs.overlays = [ emacs.overlay ];
          }
        ];
      };

      flash = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs.host = {
          name = "flash";
          type = "desktop";
          keymap = "be";
          wm = "i3";
        };

        modules = [
          ./hosts/flash
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.registry.nixpkgs.flake = nixpkgs;
          }

          (import "${impermanence}/nixos.nix")

          home-manager.nixosModules.home-manager
          ({ host, ... }: {
            options.home-manager.users = with nixpkgs.lib; mkOption {
              type = with types; attrsOf (submoduleWith {
                modules = [ ];
                specialArgs = {
                  inherit host;
                };
              });
            };
          })
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.lucas = import ./home;
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
