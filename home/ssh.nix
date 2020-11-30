{ ... }:

{
  programs.ssh = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
