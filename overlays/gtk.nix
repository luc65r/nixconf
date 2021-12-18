self: super: {
  gtk3-xdg-decoration = super.gtk3.overrideAttrs (old: {
    patches = old.patches ++ [
      (super.fetchpatch {
        url = "https://gitlab.gnome.org/GNOME/gtk/-/commit/b535e4805725eda92e86d48089457221fa8371fc.patch";
        sha256 = "Ug/1f6VBlZPUi8J5m3GobuXLWxIUp0eZ7HecWJl6cUI=";
      })
    ];
  });
}
