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
                firmwareLinuxNonfree = super.firmwareLinuxNonfree.overrideAttrs (old: rec {
                  version = "2020-12-18";
                  src = self.fetchgit {
                    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
                    rev = self.lib.replaceStrings ["-"] [""] version;
                    sha256 = "1rb5b3fzxk5bi6kfqp76q1qszivi0v1kdz1cwj2llp5sd9ns03b5";
                  };
                  outputHash = "1p7vn2hfwca6w69jhw5zq70w44ji8mdnibm1z959aalax6ndy146";
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
