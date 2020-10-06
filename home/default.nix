{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Lucas Ransan";
    userEmail = "lucas@ransan.tk";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-repeat
      vim-surround
      vim-polyglot
    ];
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };
}
