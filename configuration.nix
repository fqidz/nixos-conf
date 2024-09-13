{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
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

  users.users.faidz = {
    isNormalUser = true;
    description = "faidz";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  security.sudo.extraConfig =
  ''
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


  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

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
      enable = false;
      browsing = false;
      # browsedConf = ''
      #   BrowseDNSSDSubTypes _cups,_print
      #   BrowseLocalProtocols all
      #   BrowseRemoteProtocols all
      #   CreateIPPPrinterQueues All
      #
      #   BrowseProtocols all
      # '';

      # drivers = [
      #   pkgs.testing.dcpt510w
      # ];
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
      # systemWide = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };

  hardware = {
    pulseaudio.enable = false;
    graphics.enable = true;
    # printers = {
    #   ensurePrinters = [
    #     {
    #       name = "Brother_DCP_T510W";
    #       location = "Home";
    #       deviceUri = "implicitclass://Brother_DCP_T510W/";
    #       model = "brother_dcpt510w_printer_en.ppd";
    #       ppdOptions = {
    #         PageSize = "A4";
    #       };
    #     }
    #   ];
    #   ensureDefaultPrinter = "Brother_DCP_T510W";
    # };
  };

  security.rtkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    optimise.automatic = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall for syncthing
  networking = {
    # wireless = {
    #   enable = true;
    #   interfaces = [ "wlp1s0" ];
    #     networks = {
    #       "Student-1X" = {
    #         authProtocols = "WPA-EAP";
    #         auth = ''
    #           eap=PEAP
    #           identity="202400240"
    #           password="test"
    #         '';
    #       };
    #     };
    # };
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
