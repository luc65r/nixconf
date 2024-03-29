{ config, pkgs, lib, options, secrets, ... }:

{
  imports = [
    ./disks.nix
    ./fonts.nix
    ../../desktops
    ../../services/battery.nix
    ../../services/postgres.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
        copyKernels = true;
        extraEntries = ''
          menuentry "Arch Linux" --class linux --class os {
            search --set=drive1 --fs-uuid 9518-C3D1
            linux ($drive1)//arch/vmlinuz-linux zfs=zroot/arch rw zfs_force=1
            initrd ($drive1)//arch/initramfs-linux.img
          }

          menuentry "FreeBSD" --class freebsd --class bsd --class os {
            insmod part_gpt
            insmod fat
            search --set=drive1 --fs-uuid 9518-C3D1
            chainloader ($drive1)//EFI/FreeBSD/loader.efi
          }
        '';
      };
    };
    kernelParams = [
      "nohibernate"
      "zswap.enabled=0"
    ];

    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

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
    hostId = "c9f3ffb3";

    useDHCP = false;
    interfaces = {
      eno1.useDHCP = true;
      wlp1s0.useDHCP = true;
    };

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services.resolved.enable = true;

  programs.nm-applet.enable = true;

  services.postgresql.authentication = lib.mkForce ''
    local all all trust
    host all all 127.0.0.1/32 trust
    host all all ::1/128 trust
  '';

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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

  hardware.wooting.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
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

  documentation = {
    enable = true;
    man.enable = true;
    man.generateCaches = true;
    doc.enable = true;
    dev.enable = true;
    info.enable = true;
    nixos.enable = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    trustedUsers = [ "root" "lucas" ];
    settings = {
      auto-optimise-store = true;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../../pkgs)
    ];
  };

  system.stateVersion = "22.05";
}
