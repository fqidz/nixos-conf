{ pkgs, ... }:
{

  home.packages = [
    pkgs.zip
    pkgs.unzip
    (pkgs.prismlauncher.override {
      # # Add binary required by some mod
      # additionalPrograms = [ ffmpeg ];

      jdks = [
        pkgs.jdk
      ];
    })
  ];
}
