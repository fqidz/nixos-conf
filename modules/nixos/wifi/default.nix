{ config, ... }:
{
  sops.secrets = {
    "wifi.env" = { };
    "wifi_identity.env" = { };
    "student_1x_identity" = { };
    "student_1x" = { };
  };

  sops.templates."Student-1X".path = "/var/lib/iwd/Student-1X.8021x";
  sops.templates."Student-1X".content = ''
    [Security]
    EAP-Method=PEAP
    EAP-PEAP-Phase2-Method=MSCHAPV2
    EAP-PEAP-Phase2-Identity=${config.sops.placeholder.student_1x_identity}
    EAP-PEAP-Phase2-Password=${config.sops.placeholder.student_1x}

    [Settings]
    AutoConnect=true
  '';

  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = false;
      };
      connectionConfig = {
        "connection.auth-retries" = 10;
        "802-1x.auth-timeout" = 120;
      };
      settings = {
        device = {
          "wifi.iwd.autoconnect" = false;
        };
      };
      logLevel = "DEBUG";

      ensureProfiles = {
        environmentFiles = [
          config.sops.secrets."wifi.env".path
          config.sops.secrets."wifi_identity.env".path
        ];
        profiles = {

          Senzid2 = {
            connection = {
              id = "Senzid2";
              type = "802-11-wireless";
              autoconnect = "true";
              autoconnect-priority = 10;
            };
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "default";
            };
            "802-11-wireless" = {
              mode = "infrastructure";
              ssid = "Senzid2";
              cloned-mac-address = "preserve";
            };
            "802-11-wireless-security" = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$senzid2";
            };
          };

          Senzid = {
            connection = {
              id = "Senzid";
              type = "802-11-wireless";
              autoconnect = "true";
              autoconnect-priority = 9;
            };
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "default";
            };
            "802-11-wireless"  = {
              mode = "infrastructure";
              ssid = "Senzid";
              cloned-mac-address = "preserve";
            };
            "802-11-wireless-security" = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$senzid";
            };
          };

          Pocket-Wifi = {
            connection = {
              id = "Pocket-Wifi";
              type = "802-11-wireless";
              autoconnect = "true";
              autoconnect-priority = 11;
            };
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "default";
            };
            "802-11-wireless" = {
              mode = "infrastructure";
              ssid = "senzid 15gb only";
              cloned-mac-address = "random";
            };
            "802-11-wireless-security" = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$pocketwifi";
            };
          };

          UOB-Events = {
            connection = {
              id = "UOB-Events";
              type = "802-11-wireless";
              autoconnect = "true";
            };
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "default";
            };
            "802-11-wireless" = {
              mode = "infrastructure";
              ssid = "UOB Events";
            };
            "802-11-wireless-security" = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$uob_events";
            };
          };

          Student-1X = {
            connection = {
              id = "Student-1X";
              type = "802-11-wireless";
              autoconnect = "true";
            };
            ipv4.method = "auto";
            ipv6.method = "disabled";
            "802-1x" = {
              eap = "peap;";
              identity = "$student_1x_identity";
              password = "$student_1x";
              # password-flags = "0";
              phase2-auth = "mschapv2";
              # phase1-peaplabel = "0";
            };
            "802-11-wireless" = {
              cloned-mac-address = "random";
              mode = "infrastructure";
              ssid = "Student-1X";
              security = "802-11-wireless-security";
            };
            "802-11-wireless-security" = {
              auth-alg = "open";
              key-mgmt = "wpa-eap";
            };
          };

        };
      };
    };
  };
}
