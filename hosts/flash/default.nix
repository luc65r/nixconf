{ config, pkgs, lib, options, ... }:

{
  imports = [
    ./disks.nix
    ./fonts.nix
    ./containers.nix
    ../../desktops
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
    kernelModules = [ "zenpower" ];
    blacklistedKernelModules = [ "k10temp" ];
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

  environment.pathsToLink = [
    "/share/zsh"
  ];

  networking = {
    hostName = "flash";
    hostId = "ab654bd1";

    useDHCP = false;
    interfaces.enp4s0 = {
      ipv4.addresses = [
        { address = "192.168.0.10"; prefixLength = 24; }
      ];
      ipv6.addresses = [
        { address = "2a01:cb19:86ed:f600::10"; prefixLength = 56; }
      ];
    };
    defaultGateway = { address = "192.168.0.1"; interface = "enp4s0"; };
    defaultGateway6 = { address = "2a01:cb19:86ed:f600:46a6:1eff:fe80:c516"; interface = "enp4s0"; };
    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

    firewall = {
      enable = true;
      allowedTCPPorts = [
        51413
        1935
        4533
      ];
      allowedUDPPorts = [
        51413
      ];
    };
  };

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;

    # For MPD to have a mixer
    extraClientConf = ''
      autospawn=yes
    '';
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  users = {
    mutableUsers = false;

    users.transmission.uid = 70;
    groups.transmission.gid = 70;
    users.navidrome.uid = 90;
    groups.navidrome.gid = 90;

    users = {
      root.hashedPassword = "$6$ySKmr51WkZ$54rjKWNyZBag.xZj/u9DvzUZsmEvaavotAhjxeNZv5lSUROp466T3oQfm5eiy/HSJ5z5B5yCYmJ1BlZsV1hMT/";
      lucas = {
        hashedPassword = "$6$UUoarSfXWDxumM$aVec3H9FYCiexi.mB2cp1vD9Rw3zvNtTY0aJLdGixRu59IBRW1x8mGUmfa1z3Wn./pCplT0PWyfveh751dcDA.";
        isNormalUser = true;
        createHome = false;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "audio" "video" "transmission" ];
      };
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    trustedUsers = [ "root" "lucas" ];
  };

  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    info.enable = true;
    nixos = {
      enable = false; # manual-combined.xml fails to validate
      includeAllModules = false; # Infinite recursion
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../../pkgs)
    ];
  };

  system.stateVersion = "20.09";
}
