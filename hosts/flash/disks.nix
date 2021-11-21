{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
      kernelModules = [ "dm-snapshot" ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];
    zfs.enableUnstable = true;
  };

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
  };

  fileSystems."/persist" = {
    label = "persist";
    fsType = "ext4";
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    label = "nix";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "boot";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "perso/home";
    fsType = "zfs";
  };

  fileSystems."/home/lucas/Jeux" = {
    device = "perso/Jeux";
    fsType = "zfs";
  };

  fileSystems."/srv/torrent" = {
    device = "qto/Torrent";
    fsType = "zfs";
  };

  fileSystems."/srv/navidrome" = {
    device = "qto/Navidrome";
    fsType = "zfs";
  };

  fileSystems."/srv/music" = {
    device = "qto/Musique";
    fsType = "zfs";
  };

  fileSystems."/srv/ogg" = {
    device = "qto/ogg";
    fsType = "zfs";
  };

  fileSystems."/srv/znc" = {
    device = "qto/znc";
    fsType = "zfs";
  };

  fileSystems."/var/lib/acme/.lego/accounts" = {
    device = "qto/acme";
    fsType = "zfs";
  };

  fileSystems."/srv/botCYeste" = {
    device = "qto/botCYeste";
    fsType = "zfs";
  };

  fileSystems."/var/lib/prometheus" = {
    device = "qto/prometheus";
    fsType = "zfs";
  };

  fileSystems."/var/lib/grafana" = {
    device = "qto/grafana";
    fsType = "zfs";
  };

  fileSystems."/srv/cyrel" = {
    device = "qto/cyrel";
    fsType = "zfs";
  };

  fileSystems."/var/lib/postgresql" = {
    device = "qto/postgres";
    fsType = "zfs";
  };

  fileSystems."/var/backup" = {
    device = "qto/backup";
    fsType = "zfs";
  };

  swapDevices = [
    {
      label = "/swap";
    }
  ];

  services.fstrim.enable = true;

  environment.persistence."/persist" = {
    directories = [
      "/var/log"
    ];
  };
}
