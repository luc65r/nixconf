self: super:
{
  ryzenadj = self.callPackage ./ryzenadj.nix {};
  discord-wayland = self.callPackage ./discord.nix {};
  botCYeste = self.callPackage ./botCYeste.nix {};
}
