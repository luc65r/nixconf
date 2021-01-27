{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-repeat
      vim-surround
      vim-nix
      { plugin = haskell-vim;
        config = "let g:haskell_indent_guard = 4";
      }
      (pkgs.vimUtils.buildVimPlugin rec {
        pname = "vim-raku";
        version = "2020-11-2";
        src = pkgs.fetchFromGitHub {
          repo = pname;
          owner = "Raku";
          rev = "8aa22d6f1036f927888d5c6595ae2d1a31f2352f";
          sha256 = "07wgj4k9wlp6n56cckki462vpnbi5cy4d8gvv4xj7319k36cjrgb";
        };
      })
      { plugin = zig-vim;
        config = "let g:zig_fmt_autosave = 0";
      }
    ];

    extraConfig = ''
      " Turn of the ugly status line
      set laststatus=0

      command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

      set ts=4 sts=4 sw=4 et

      " Restore the cursor
      au VimLeave * set guicursor=a:ver100
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
      pdf-tools
      rg
      lsp-mode
      pkgs.rnix-lsp
      company
      direnv
      ccls
      json-mode
      company-lsp
      lsp-ui
      lsp-haskell
      flycheck
      pinentry
      meson-mode
      rust-mode
      cargo
      counsel
      libmpdel
      mpdel
      flx
      auctex
      cdlatex
      go-mode
    ];
  };
}
