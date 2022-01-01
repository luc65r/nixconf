lib: rec {
  palette = [
    "#2e3440"
    "#3b4252"
    "#434c5e"
    "#4c566a"
    "#d8dee9"
    "#e5e9f0"
    "#eceff4"
    "#8fbcbb"
    "#88c0d0"
    "#81a1c1"
    "#5e81ac"
    "#bf616a"
    "#d08770"
    "#ebcb8b"
    "#a3be8c"
    "#b48ead"
  ];

  css = lib.concatStrings
    (lib.imap0
      (i: c: "@define-color nord${toString i} ${c};\n")
      palette);
}