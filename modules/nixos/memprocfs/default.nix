{ pkgs, ...}:
{
  environment.systemPackages = [
    (pkgs.memprocfs.override {
      withFt601Driver = true;
    })
  ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idProduct}=="601f", ATTR{idVendor}=="0403", ATTR{manufacturer}=="FTDI", MODE="0666"
  '';
}
