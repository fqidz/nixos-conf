{
  config,
  pkgs,
  inputs,
  options,
  username,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;

    # Enable Hyprland
    hyprland = {
      enable = true;
      # use UWSM as recommended, instead of using systemd session directly.
      withUWSM = true;
      xwayland.enable = true;
    };

    wireshark.enable = true;
  };

  documentation = {
    man = {
      enable = true;
      generateCaches = true;
    };
    nixos.includeAllModules = true;
    dev.enable = true;
  };


  environment = {
    variables.EDITOR = "nvim";
    sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
    systemPackages = [
      pkgs.git
      pkgs.vim
      pkgs.wirelesstools
      pkgs.wpa_supplicant_gui
      config.boot.kernelPackages.perf
      config.boot.kernelPackages.systemtap
      (pkgs.where-is-my-sddm-theme.override {
        themeConfig.General = {
          backgroundFill = "#191724";
          basicTextColor = "#e0def4";
          passwordInputWidth = "0.75";
          passwordCursorColor = "#e0def4";
          passwordInputCursorVisible = true;
          cursorBlinkAnimation = true;
          hideCursor = true;
        };
      })
    ];
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "me";
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireshark"
      "input"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.extraConfig = ''
    # Save sudo across terminals
    Defaults timestamp_type = global

    # Set sudo timeout to 10 minutes
    Defaults timestamp_timeout = 10
  '';

  boot = {
    supportedFilesystems = [
      "ntfs"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_6_12;

    consoleLogLevel = 0; # silent boot
    kernelParams = [
      # silent boot
      "quiet"
      "udev.log_priority=3"
      # power saving options
      "kernel.nmi_watchdog=0"
      "vm.dirty_writeback_centisecs=6000"
    ];
    initrd.verbose = false;
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "ondemand";
  };

  # Set your time zone.
  time.timeZone = "Asia/Bahrain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    # Needed for MSCHAPV2 ??
    pppd.enable = true;

    pulseaudio.enable = false;
    fstrim.enable = true;
    tlp.enable = true;
    openssh.enable = true;
    chrony.enable = true;
    udev.extraRules = ''
      KERNEL=="uinput", GROUP="input"
    '';
    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
    };
    displayManager = {
      enable = true;
      # sessionPackages = [ pkgs.hyprland ];
      sddm = {
        enable = true;
        theme = "where_is_my_sddm_theme";
        package = pkgs.kdePackages.sddm;
        extraPackages = [
          pkgs.qt6.qt5compat
        ];

        settings = {
         # General.DefaultSession = "hyprland-uwsm";
         Users = {
           RememberLastSession = true;
           RememberLastUser = true;
         };
        };

      };
    };

    flatpak.enable = true;

    xserver = {
      enable = true;
    };

    printing = {
      enable = false;
      browsing = false;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    xserver.xkb = {
      layout = "us";
      variant = "";
    };

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  hardware = {
    graphics.enable = true;
  };

  security.rtkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  };

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
    timeServers = options.networking.timeServers.default ++ [
      "asia.pool.ntp.org"
    ];
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

    # Open ports in the firewall for syncthing
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22000
      ];
      allowedUDPPorts = [
        22000
        21027
      ];
    };
  };

  system.stateVersion = "24.05";
}
