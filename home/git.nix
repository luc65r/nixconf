{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Lucas Ransan";
    userEmail = "lucas@ransan.tk";

    ignores = [ "*~" ];
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
}
