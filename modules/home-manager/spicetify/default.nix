{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.ziro;
    colorScheme = "rose-pine";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      beautifulLyrics
    ];
  };
}
