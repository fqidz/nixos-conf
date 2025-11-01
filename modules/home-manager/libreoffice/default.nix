{ pkgs, ... }:
{
  home.packages = [
    pkgs.libreoffice-qt
    # pkgs.hunspell
    # pkgs.hyphenDicts.en_GB
  ];
}
