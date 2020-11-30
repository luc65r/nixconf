{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Lucas Ransan";
    userEmail = "lucas@ransan.tk";

    ignores = [ "*~" ];

    extraConfig = {
      core.editor = "vim";
    };
  };
}
