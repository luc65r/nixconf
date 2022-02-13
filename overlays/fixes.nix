self: super: rec {
  python3 = super.python3.override {
    packageOverrides = self: super: {
      remarshal = super.remarshal.overrideAttrs (old: {
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace "poetry.masonry.api" "poetry.core.masonry.api" \
            --replace 'PyYAML = "^5.3"' 'PyYAML = "*"' \
            --replace 'tomlkit = "^0.7"' 'tomlkit = "*"'
        '';
      });
    };
  };

  python3Packages = python3.pkgs;
}
