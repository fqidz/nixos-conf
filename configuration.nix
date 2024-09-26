{
  config,
  pkgs,
  inputs,
  ...
}:
let
  username = "faidz";
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.sops-nix.nixosModules.sops
  ];

  programs = {
    zsh.enable = true;
    # Enable Hyprland
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland
    systemPackages = [
      pkgs.git
      pkgs.vim
      pkgs.wirelesstools
      pkgs.wpa_supplicant_gui
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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_6_10;

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
    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
    };
    displayManager = {
      enable = true;
      sessionPackages = [ pkgs.hyprland ];
      sddm = {
        enable = true;
        theme = "where_is_my_sddm_theme";
        package = pkgs.kdePackages.sddm;
        extraPackages = [
          pkgs.qt6.qt5compat
        ];
      };
    };

    xserver = {
      enable = true;
    };

    printing = {
      enable = true;
      browsing = true;
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
    pulseaudio.enable = false;
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
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  };

  sops.secrets = {
    "wifi.env" = { };
    "wifi_identity.env" = { };
  };

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
          "conneciton.autoconnect-retries" = 10;
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
              type = "wifi";
              autoconnect = "true";
            };
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "default";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "Senzid2";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$senzid2";
            };
          };

          UOB-Events = {
            connection = {
              id = "UOB-Events";
              type = "wifi";
              autoconnect = "true";
            };
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "default";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "UOB Events";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$uob_events";
            };
          };

          Student-1X = {
            connection = {
              id = "Student-1X";
              type = "wifi";
              autoconnect = "true";
            };
            ipv4.method = "auto";
            ipv6 = {
              method = "auto";
              addr-gen-mode = "default";
            };
            wifi = {
              cloned-mac-address = "random";
              mode = "infrastructure";
              ssid = "Student-1X";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-eap";
            };
            "802-1x" = {
              anonymous-identity = "f";
              eap = "peap;";
              identity = "$student_1x_identity";
              password = "$student_1x";
              phase2-auth = "mschapv2";
              phase1-auth-flags = "all";
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
