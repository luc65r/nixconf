{ config, pkgs, lib, options, ... }:

{
  imports = [
      ./disks.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr-bepo";
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = import ./packages.nix {
    inherit pkgs;
  };

  services.openssh.enable = true;

  networking.hostName = "sally";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  networking.wireless.enable = true;
  networking.wireless.networks = {
    test = {
      psk = "testtest";
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.mutableUsers = false;
  users.users.root.password = "root";
  users.users.lucas = {
    password = "lucas";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "20.09";
}

