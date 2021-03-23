{ config, pkgs, lib, options, secrets, ... }:

{
  imports = [
    ./disks.nix
    ./fonts.nix
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

  services.tlp = {
    enable = false;
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

  environment.pathsToLink = [
    "/share/zsh"
  ];

  networking = {
    hostName = "sally";

    useDHCP = false;
    interfaces = {
      eno1.useDHCP = true;
      wlp1s0.useDHCP = true;
    };

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      dispatcherScripts = [
        {
          source = pkgs.writeShellScript "50-wg-loop.sh" ''
            case $2 in
              up)
                ${pkgs.iproute}/bin/ip route add ${secrets.ip} via $IP4_GATEWAY dev $DEVICE_IP_IFACE
                ;;
              down)
                ${pkgs.iproute}/bin/ip route del ${secrets.ip}
                ;;
            esac
          '';
        }
      ];
    };
  };

  services.resolved.enable = true;

  programs.nm-applet.enable = true;

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    media-session = {
      config.bluez-monitor = {
        properties.bluez5 = {
          msbc-support = true;
          sbc-xq-support = true;
        };
      };
    };
  };

  security.pam.loginLimits = [
    { # Pipewire: Failed to mlock memory
      domain = "lucas";
      item = "memlock";
      type = "soft";
      value = "64";
    }
    {
      domain = "lucas";
      item = "memlock";
      type = "hard";
      value = "128";
    }
  ];

  hardware.bluetooth.enable = true;

  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option "TearFree" "on"
    '';
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk # Vulkan
    ];
  };

  users = {
    mutableUsers = false;

    users = {
      root.hashedPassword = "$6$ySKmr51WkZ$54rjKWNyZBag.xZj/u9DvzUZsmEvaavotAhjxeNZv5lSUROp466T3oQfm5eiy/HSJ5z5B5yCYmJ1BlZsV1hMT/";
      lucas = {
        hashedPassword = "$6$UUoarSfXWDxumM$aVec3H9FYCiexi.mB2cp1vD9Rw3zvNtTY0aJLdGixRu59IBRW1x8mGUmfa1z3Wn./pCplT0PWyfveh751dcDA.";
        isNormalUser = true;
        createHome = false;
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
      };
    };
  };

  security.sudo.enable = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    trustedUsers = [ "root" "lucas" ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../../pkgs)
    ];
  };

  system.stateVersion = "20.09";
}
