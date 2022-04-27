{ pkgs, host, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "Nord";
    };
  };

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
    enable = host.type != "server";
    package = pkgs.emacsPgtkGcc.override {
      gtk3-x11 = pkgs.gtk3-xdg-decoration;
    };
    extraPackages = epkgs: with epkgs; [
      magit
      nix-mode
      nord-theme
      haskell-mode
      pdf-tools
      rg
      lsp-mode
      company
      direnv
      ccls
      json-mode
      lsp-ui
      lsp-haskell
      flycheck
      pinentry
      meson-mode
      rust-mode
      cargo
      counsel
      flx
      auctex
      cdlatex
      go-mode
      emms
      go-translate
      raku-mode
      pkgs.mu
      dhall-mode
      vterm
      yaml-mode
      transmission
      zig-mode
      agda2-mode
      erlang
      yasnippet
      elpher
      nasm-mode
      znc
      vala-mode
      (parinfer-rust-mode.overrideAttrs (old: {
        postPatch = ''
          ${pkgs.perl}/bin/perl -0777pi \
              -e 's,\(concat[^()]+user-emacs-directory[^()]+"parinfer-rust/"\),"${pkgs.parinfer-rust}/lib/",gs' \
              parinfer-rust-mode.el
          sed -i 's,"parinfer-rust-linux.so","libparinfer_rust.so",g' parinfer-rust-mode.el
        '';
      }))
      geiser
      geiser-guile
      geiser-chibi
      myrddin-mode
      v-mode
      lua-mode
      cmake-mode
      cmake-font-lock
      scala-mode
      sbt-mode
      llvm-mode
      polymode
      slime
      (flycheck-grammalecte.overrideAttrs (old: {
        postPatch = ''
          sed -i grammalecte.el flycheck-grammalecte.el \
              -e 's,python3,${pkgs.python3.withPackages (p: [ p.grammalecte ])}/bin/python3,'
        '';
      }))
      glsl-mode
      idris-mode
      elixir-mode
      web-mode
      bison-mode
    ];
  };

  services.emacs = {
    enable = host.type != "server";
    client.enable = true;
    socketActivation.enable = true;
  };

  home.sessionVariables = {
    EDITOR = if host.type == "server" then "vim" else "emacsclient";
  };
}
