host:
{ ... }:

{
  home = {
    keyboard = {
      layout = "fr";
      variant = if host == "flash" then "be" else "bepo";
      options = [
        "ctrl:swapcaps"
      ];
    };
  };
}
