{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      supportedFilesystems = [ "zfs" ];
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r zroot/nixos/root@blank
      '';
    };
    supportedFilesystems = [ "zfs" ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    zfs = {
      enableUnstable = true;
      requestEncryptionCredentials = true;
    };
    loader.grub.zfsSupport = true;
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="sd[a-z]*[0-9]*|mmcblk[0-9]*p[0-9]*|nvme[0-9]*n[0-9]*p[0-9]*", ENV{ID_FS_TYPE}=="zfs_member", ATTR{../queue/scheduler}="none"
  '';

  services.zfs.autoScrub.enable = true;

  fileSystems."/" = {
    device = "zroot/nixos/root";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "zroot/nixos/persist";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "zroot/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zroot/nixos/nix";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };

  swapDevices = [
    /*{
      label = "/swap";
    }*/
  ];

  services.fstrim.enable = true;

  environment.persistence."/persist" = {
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
    ];
  };
}
