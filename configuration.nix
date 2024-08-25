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

  # xdg.portal = {
  #   enable = true;
  #   xdgOpenUsePortal = true;
  # };

  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # This variable fixes electron apps in wayland

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.faidz = {
    isNormalUser = true;
    description = "faidz";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [
    # ];
    shell = pkgs.zsh;
  };

  # home-manager = {
  #   users = {
  #     "faidz" = import ./config/home.nix;
  #   };
  # };

  security.sudo.extraConfig =
  ''
  # Save sudo across terminals
  Defaults timestamp_type = global

  # Set sudo timeout to 10 minutes
  Defaults timestamp_timeout = 10
  '';

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
      # package = pkgs.libsForQt5.sddm;
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

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    (where-is-my-sddm-theme.override {
      # variants = [ "qt6" ];
      themeConfig.General = {
        backgroundFill = "#191724";
        basicTextColor = "#e0def4";
        passwordInputWidth = "0.75";
        passwordCursorColor = "#e0def4";
        # passwordInputCursorVisible = false;
        cursorBlinkAnimation = true;
        # hideCursor = true;
      };
    })
  ];

  # fonts.packages = with pkgs; [
  #   (nerdfonts.override { fonts = [ "RobotoMono" ]; })   
  # ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
