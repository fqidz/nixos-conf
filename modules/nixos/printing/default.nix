{ pkgs-dcpt510w, ... }:
{
  services.printing = {
    enable = true;
    drivers = [
      (pkgs-dcpt510w.dcpt510w.override {
        debugLvl = 2;
      })
    ];
    logLevel = "debug";
    openFirewall = true;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Brother_DCP_T510W";
        location = "Home";
        # lpinfo -v
        deviceUri = "dnssd://Brother%20DCP-T510W._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-40234367573c";
        model = "brother_dcpt510w_printer_en.ppd";
      }
    ];
  };
}
