self: super:
{
  ryzenadj = self.callPackage ./ryzenadj.nix {};
  moonlight-qt = self.libsForQt5.callPackage ./moonlight-qt.nix {};
}
