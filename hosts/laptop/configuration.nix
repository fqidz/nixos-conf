{
  config,
  pkgs,
  inputs,
  options,
  username,
  system,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/desktop-environment
    ../../modules/nixos/shell
    ../../modules/nixos/sops
    ../../modules/nixos/wifi
    ../../modules/nixos/podman
    ../../modules/nixos/memprocfs
    ../../modules/nixos/printing
  ];

  programs = {
    nix-ld.enable = true;

    gnupg.agent = {
      enable = true;
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
    systemPackages = [
      pkgs.git
      pkgs.vim
      pkgs.nixd

      inputs.nix-alien.packages.${system}.nix-alien
      pkgs.wirelesstools
      pkgs.wpa_supplicant_gui
      # config.boot.perf
      # config.boot.systemtap
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
  };

  boot = {
    supportedFilesystems = [
      "ntfs"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;

    # kernelModules = [ "ch341" ];
    # extraModulePackages = [ pkgs-ch341.linuxPackages_latest.ch341 ];

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

    # Orca screen reader
    orca.enable = true;
    gnome.at-spi2-core.enable = true;

    pulseaudio.enable = false;
    fstrim.enable = true;
    tlp.enable = true;
    openssh.enable = true;
    chrony.enable = true;
    udev.extraRules = ''
      KERNEL=="uinput", GROUP="input"
    '';

    logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
    };

    flatpak.enable = true;

    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
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
      wireplumber.extraConfig."99-disable-suspend"."monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "~alsa_input.*"; }
            { "node.name" = "~alsa_output.*"; }
          ];
          actions = {
            update-props = {
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }
      ];
    };
  };

  hardware = {
    graphics.enable = true;
  };

  security = {
    rtkit = {
      enable = true;
      # https://wiki.archlinux.org/title/PipeWire#Missing_realtime_priority/crackling_under_load_after_suspend
      args = [ "--no-canary" ];
    };
    sudo.extraConfig = ''
      # Save sudo across terminals
      Defaults timestamp_type = global

      # Set sudo timeout to 10 minutes
      Defaults timestamp_timeout = 10
    '';
    # pam.loginLimits = [
    #   {
    #     domain = "*";
    #     type = "-";
    #     item = "nofile";
    #     value = "32768";
    #   }
    # ];
  };

  systemd.user.extraConfig = "DefaultLimitNOFILE=32768";

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

  networking = {
    timeServers = options.networking.timeServers.default ++ [
      "asia.pool.ntp.org"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22000 # syncthing
        7171 # website development; open to allow phone to open local website
      ];
      allowedUDPPorts = [
        22000 # syncthing
        21027 # syncthing
      ];
    };
  };

  system.stateVersion = "24.05";
}
