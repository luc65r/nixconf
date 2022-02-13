self: super: {
  python = super.python.override {
    packagesOverride = self: super: {
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
}
