{ pkgs, pkgs-graalvm-ce-21, ... }:
{
  home.packages = [
    pkgs.zip
    pkgs.unzip
    (pkgs.prismlauncher.override {
      # # Add binary required by some mod
      # additionalPrograms = [ ffmpeg ];

      jdks = [
        pkgs-graalvm-ce-21.graalvm-ce
      ];
    })
  ];
}
