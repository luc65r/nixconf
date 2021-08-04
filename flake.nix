{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    emacs.url = "github:nix-community/emacs-overlay";
    impermanence = {
      url = "github:nix-community/impermanence";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    secrets = {
      url = "git+file:///home/lucas/nixsecrets";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    cyrel = {
      url = "git+ssh://git@github.com/Cyrel-org/cyrel-functions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
    botCYeste = {
      url = "github:luc65r/botCYeste";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs-unstable
    , nixpkgs-stable
    , home-manager
    , emacs
    , impermanence
    , flake-utils
    , secrets
    , cyrel
    , botCYeste
    }: {
      nixosConfigurations = let
        defaultConfig =
          { name
          , nixpkgs
          }: {
            system = "x86_64-linux";

            specialArgs = {
              host = {
                inherit name;
                type = "desktop";
                keymap = "bepo";
                wm = "sway";
              };

              inherit (secrets) secrets;
            };

            modules = [
              (./hosts + "/${name}")
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

                  (_: _: {
                    cyrel = cyrel.defaultPackage."x86_64-linux";
                    botCYeste = botCYeste.defaultPackage."x86_64-linux";
                  })
                ];
              }
            ];
          };
      in {
        sally = nixpkgs-unstable.lib.nixosSystem
          (nixpkgs-unstable.lib.recursiveUpdate (defaultConfig {
            name = "sally";
            nixpkgs = nixpkgs-unstable;
          }) {
            specialArgs.host.type = "laptop";
          });

        flash = nixpkgs-stable.lib.nixosSystem
          (nixpkgs-stable.lib.recursiveUpdate (defaultConfig {
            name = "flash";
            nixpkgs = nixpkgs-stable;
          }) {
          });
      };
    } // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs-unstable.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          rnix-lsp
        ];
      };
    });
}
