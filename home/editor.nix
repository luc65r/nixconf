{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-repeat
      vim-surround
      { plugin = haskell-vim;
        config = "let g:haskell_indent_guard = 4";
      }
    ];

    extraConfig = ''
      " Turn of the ugly status line
      set laststatus=0

      command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

      set ts=4 sts=4 sw=4 et
    '';
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacsUnstable;
    extraPackages = epkgs: with epkgs; [
      magit
      nix-mode
      dracula-theme
      haskell-mode
    ];
  };
}
