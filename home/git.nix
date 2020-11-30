{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Lucas Ransan";
    userEmail = "lucas@ransan.tk";

    signing = {
      key = "0x37E8293E1B8B2307";
      signByDefault = true;
    };

    ignores = [ "*~" ];

    extraConfig = {
      core.editor = "vim";
    };
  };
}
