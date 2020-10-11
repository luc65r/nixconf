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

  services.tlp.enable = true;

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

  services.openssh.enable = true;

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
        test = {
          psk = "testtest";
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

  users = {
    mutableUsers = false;

    users = {
      root.password = "root";
      lucas = {
        password = "lucas";
        isNormalUser = true;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "audio" ];
      };
    };
  };

  security.sudo.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "20.09";
}

