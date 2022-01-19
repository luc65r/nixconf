self: super:
{
  ryzenadj = self.callPackage ./ryzenadj.nix {};
  discord-chromium = self.callPackage ./discord.nix {
    chromium = self.ungoogled-chromium;
  };
}
