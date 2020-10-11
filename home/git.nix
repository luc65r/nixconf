{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Lucas Ransan";
    userEmail = "lucas@ransan.tk";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
