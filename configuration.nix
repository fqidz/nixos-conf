{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
    
  # Enable Hyprland
  programs = {
    zsh.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland

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

    # silent boot
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_priority=3"
    ];
    initrd.verbose = false;
  };


  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Riyadh";

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
    displayManager.sddm = {
      enable = true;
      theme = "where_is_my_sddm_theme";
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [
        qt6.qt5compat
      ];
    };

    xserver = {
      enable = true;
    };

    printing.enable = true;
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

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    (where-is-my-sddm-theme.override {
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall for syncthing
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22000
    ];
    allowedUDPPorts = [
      22000
      21027
    ];
  };

  system.stateVersion = "24.05";
}
