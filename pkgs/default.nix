self: super:
{
  ryzenadj = self.callPackage ./ryzenadj.nix {};
  discord-wayland = self.callPackage ./discord.nix {};
  cyrel = self.callPackage ./cyrel.nix {};
  botCYeste = self.callPackage ./botCYeste.nix {};
}
