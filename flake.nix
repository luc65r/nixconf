{
  description = "My NixOS configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    impermanence = {
      url = "github:nix-community/impermanence";
      flake = false;
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    emacs.url = "github:nix-community/emacs-overlay";

    secrets = {
      url = "git+file:///home/lucas/nixsecrets";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    botCYeste = {
      url = "github:luc65r/botCYeste";
      inputs.flake-utils.follows = "flake-utils";
    };

    cyrel.url = "github:alyrow/cyrel";

    grid = {
      url = "github:luc65r/grid";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , flake-utils
    , nixpkgs-stable
    , nixpkgs-unstable
    , impermanence
    , home-manager-unstable
    , emacs
    , secrets
    , botCYeste
    , cyrel
    , grid
    }: {
      nixosConfigurations = let
        defaultConfig =
          { name
          , type
          , nixpkgs
          , home-manager
          }: rec {
            system = "x86_64-linux";

            specialArgs = {
              host = {
                inherit name type;
                keymap = "bepo";
                wm = if type != null then "river" else null;
              };

              inherit (secrets) secrets;
            };

            modules = [
              ./hosts/generic
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
                  (import ./overlays/fixes.nix)
                ] ++ (if type == "server" then [
                  (_: _: {
                    botCYeste = botCYeste.defaultPackage.${system};
                    cyrel = cyrel.defaultPackage.${system};
                  })
                ] else [
                  emacs.overlay
                  (import ./overlays/gtk.nix)
                  (_: _: {
                    grid = grid.defaultPackage.${system};
                  })
                ]);
              }
            ];
          };
      in {
        sally = nixpkgs-unstable.lib.nixosSystem
          (nixpkgs-unstable.lib.recursiveUpdate (defaultConfig {
            name = "sally";
            type = "laptop";
            nixpkgs = nixpkgs-unstable;
            home-manager = home-manager-unstable;
          }) {
          });

        flash = nixpkgs-stable.lib.nixosSystem
          (nixpkgs-stable.lib.recursiveUpdate (defaultConfig {
            name = "flash";
            type = "server";
            nixpkgs = nixpkgs-stable;
            home-manager = home-manager-unstable;
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
