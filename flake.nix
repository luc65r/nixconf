{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-21.05";
    home-manager-unstable = {
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
  };

  outputs =
    { self
    , nixpkgs-unstable
    , nixpkgs-stable
    , home-manager-unstable
    , emacs
    , impermanence
    , flake-utils
    , secrets
    }: {
      nixosConfigurations = let
        defaultConfig =
          { name
          , type
          , nixpkgs
          , home-manager ? null
          }: {
            system = "x86_64-linux";

            specialArgs = {
              host = {
                inherit name type;
                keymap = "bepo";
                wm = if type != null then "gnome" else null;
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
            ] ++ nixpkgs.lib.optionals (type != "server") [
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
                ];
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
