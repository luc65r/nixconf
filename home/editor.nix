{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-repeat
      vim-surround
      vim-polyglot
    ];
  };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs.melpaPackages; [
      magit
      nix-mode
      dracula-theme
    ];
  };
}
