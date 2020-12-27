{ ... }:

{
  services.transmission = {
    enable = true;
    home = "/home/transmission";
    openFirewall = true;
  };
}
