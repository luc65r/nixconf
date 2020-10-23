{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Lucas Ransan";
    userEmail = "lucas@ransan.tk";

    ignores = [ "*~" ];
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
