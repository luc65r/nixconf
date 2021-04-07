{ config, pkgs, lib, options, secrets, ... }:

{
  imports = [
    ./disks.nix
    ./fonts.nix
    ./containers.nix
    ./virt.nix
    ../../desktops
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    extraModulePackages = with config.boot.kernelPackages; [ zenpower v4l2loopback ];
    initrd.availableKernelModules = [ "vfio-pci" ];
    kernelParams = [
      "amd_iommu=on" "vfio-pci.ids=10de:1b80,10de:10f0"
      # Reserve 8GB for the vm
      "default_hugepagesz=1G" "hugepagesz=1G" "hugepages=8"
    ];
    kernelModules = [ "zenpower" "kvm-amd" "vfio-pci" ];
    blacklistedKernelModules = [ "k10temp" "nouveau" ];

    extraModprobeConfig = ''
      options kvm ignore_msrs=1
    '';
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
    interfaces.br0 = {
      ipv4.addresses = [
        { address = "192.168.0.10"; prefixLength = 24; }
      ];
      ipv6.addresses = [
        { address = "2a01:cb19:86ed:f600::10"; prefixLength = 56; }
      ];
    };
    defaultGateway = { address = "192.168.0.1"; interface = "br0"; };
    defaultGateway6 = { address = "2a01:cb19:86ed:f600:46a6:1eff:fe80:c516"; interface = "br0"; };
    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

    bridges = {
      br0.interfaces = [ "enp4s0" ];
    };

    nat = {
      enable = true;
      externalInterface = "br0";
      internalInterfaces = [ "wg0" ];
    };

    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = [ "10.0.0.1/24" ];
        listenPort = 51820;
        inherit (secrets.wireguard.flash) privateKey;
        peers = [
          {
            inherit (secrets.wireguard.sally) publicKey;
            allowedIPs = [ "10.0.0.2/32" ];
          }
          {
            inherit (secrets.wireguard.whyred) publicKey;
            allowedIPs = [ "10.0.0.3/32" ];
          }
        ];
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        51413 # transmission
        9091 # transmission rpc
        1935 # rtmp
        4533 # navidrome
        445 139 # samba
        47984 47989 48010 # moonlight
        5201 # iperf
      ];
      allowedUDPPorts = [
        51413 # transmission
        137 138 # samba
        5353 47998 47999 48000 48002 48010 # moonlight
        51820 # wireguard
        5201 # iperf
      ];
    };
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
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

    extraConfig = ''
      # I hate when Teams mutes my music
      unload-module module-role-cork
    '';
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = [ "radeon" ];

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
        extraGroups = [ "wheel" "audio" "video" "transmission" "libvirtd" ];
      };
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "05:00";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = [ "06:00" ];
    };
    autoOptimiseStore = true;
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
