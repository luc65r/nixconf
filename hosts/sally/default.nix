{ config, pkgs, lib, options, ... }:

{
  imports = [
      ./disks.nix
      (import ../../desktops "xmonad")
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.tlp = {
    enable = true;
    settings = {
      "USB_BLACKLIST_BTUSB" = 1;
    };
  };

  /*
  services.thermald = {
    enable = true;
    adaptive = true;
  };
  */

  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = import ./packages.nix {
    inherit pkgs;
  };

  networking = {
    hostName = "sally";

    useDHCP = false;
    interfaces = {
      eno1.useDHCP = true;
      wlp1s0.useDHCP = true;
    };

    wireless = {
      enable = true;
      networks = {
        "test" = {
          pskRaw = "e0b3e76d15f938fcd6ce682459a868312a0e0b779aee825a66aca6837701e685";
        };

        "SFR_7B6A" = {
          pskRaw = "962bf144b37eeb24b8ce4ff1c5db1e5b47ae40ff944feddd66ad059d0193a870";
        };

        "SFR_F9A8" = {
          pskRaw = "294e256afc4809d54ed2e53960d9cff89ea5fd73dd1de7a94a84f4996c791edf";
        };
      };
    };
  };

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraModules = with pkgs; [
      pulseaudio-modules-bt
    ];
  };

  hardware.bluetooth.enable = true;

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };

  users = {
    mutableUsers = false;

    users = {
      root.hashedPassword = "$6$ySKmr51WkZ$54rjKWNyZBag.xZj/u9DvzUZsmEvaavotAhjxeNZv5lSUROp466T3oQfm5eiy/HSJ5z5B5yCYmJ1BlZsV1hMT/";
      lucas = {
        hashedPassword = "$6$UUoarSfXWDxumM$aVec3H9FYCiexi.mB2cp1vD9Rw3zvNtTY0aJLdGixRu59IBRW1x8mGUmfa1z3Wn./pCplT0PWyfveh751dcDA.";
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "audio" "video" ];
      };
    };
  };

  security.sudo.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "20.09";
}
