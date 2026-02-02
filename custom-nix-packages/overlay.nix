final:
prev:
let
  versions = final.lib.importJSON ./warp-terminal/versions.json;
in
{
  # Override warp-terminal to a newer stable release
  warp-terminal = prev.warp-terminal.overrideAttrs (_old: {
    src = builtins.fetchurl {
      url = "https://releases.warp.dev/stable/v${versions.linux.version}/warp-terminal-v${versions.linux.version}-1-x86_64.pkg.tar.zst";
      sha256 = versions.linux.hash;
    };
  });

  tree-sitter_0_26 = prev.stdenv.mkDerivation {
    pname = "tree-sitter";
    version = "0.26.3";

    src = prev.fetchurl {
      url = "https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.3/tree-sitter-linux-x64.gz";
      sha256 = "sha256-T2XI2boyo+NxmDAlabMwbwN/EtgxPj8ozfG4DJ8rOjo=";
    };

    dontUnpack = true;

    nativeBuildInputs = [ prev.gzip ];

    installPhase = ''
      mkdir -p $out/bin
      gunzip -c $src > $out/bin/tree-sitter
      chmod +x $out/bin/tree-sitter
      '';

    meta = with prev.lib; {
      description = "Tree-sitter CLI (prebuilt binary)";
      platforms = [ "x86_64-linux" ];
    };
  };
}
