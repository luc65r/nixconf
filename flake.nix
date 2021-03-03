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
    flake-utils.url = "github:numtide/flake-utils";
    secrets = {
      url = "git+file:///home/lucas/nixsecrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, emacs, impermanence, flake-utils, secrets }: {
    nixosConfigurations = {
      sally = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          host = {
            name = "sally";
            type = "laptop";
            keymap = "bepo";
            wm = "sway";
          };

          inherit (secrets) secrets;
        };

        modules = [
          ./hosts/sally
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.registry.nixpkgs.flake = nixpkgs;
          }

          (import "${impermanence}/nixos.nix")

          home-manager.nixosModules.home-manager
          ({ host, secrets, ... }: {
            options.home-manager.users = with nixpkgs.lib; mkOption {
              type = with types; attrsOf (submoduleWith {
                modules = [ ];
                specialArgs = {
                  inherit host secrets;
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
            nixpkgs.overlays = [
              emacs.overlay

              (self: super: {
                firmwareLinuxNonfree = super.firmwareLinuxNonfree.overrideAttrs (old: {
                  patches = old.patches or [] ++ [
                    ./patches/0001-Revert-linux-firmware-Update-firmware-file-for-Intel.patch
                  ];
                });
              })
            ];
          }
        ];
      };

      flash = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          host = {
            name = "flash";
            type = "desktop";
            keymap = "bepo";
            wm = "i3";
          };

          inherit (secrets) secrets;
        };

        modules = [
          ./hosts/flash
          {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.registry.nixpkgs.flake = nixpkgs;
          }

          (import "${impermanence}/nixos.nix")

          home-manager.nixosModules.home-manager
          ({ host, secrets, ... }: {
            options.home-manager.users = with nixpkgs.lib; mkOption {
              type = with types; attrsOf (submoduleWith {
                modules = [ ];
                specialArgs = {
                  inherit host secrets;
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
  } // flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShell = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        rnix-lsp
      ];
    };
  });
}
