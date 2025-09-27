{ pkgs, ... }:
{
  home.packages = [
    pkgs.zip
    pkgs.unzip
    pkgs.jdk24
    (pkgs.prismlauncher.override {
      # # Add binary required by some mod
      # additionalPrograms = [ ffmpeg ];

      jdks = [
        pkgs.jdk24
      ];
    })
  ];
}
