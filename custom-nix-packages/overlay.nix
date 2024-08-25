final:
prev:
let
  versions = final.lib.importJSON ./warp-terminal/versions.json;
in
{
  # override warp-terminal with the new version to not have to wait for stable to be updated
  warp-terminal = prev.warp-terminal.overrideAttrs (finalAttrs: previousAttrs: {
    src = builtins.fetchurl {
      url = "https://releases.warp.dev/stable/v${versions.linux.version}/warp-terminal-v${versions.linux.version}-1-x86_64.pkg.tar.zst";
      sha256 = versions.linux.hash;
    };
  });
}
