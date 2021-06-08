{ ... }:

{
  services.opentracker = {
    enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      6969
    ];
    allowedUDPPorts = [
      6969
    ];
  };
}
