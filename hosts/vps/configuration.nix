{ config, lib, pkgs, username, ... }:

{
  imports =
    [
      ./hardware-configuration.nix

      ../../modules/nixos/shell
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # packages = with pkgs; [
    #   vim
    # ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKuHa7uDvYyYAnEy3Lh8dx5LDDI305OgSUClJ7KI9qji faidz@nixos"
    ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services = {
    fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "6h";
      jails = {
        "sshd".settings = {
          filter = "sshd";
          banaction = "iptables[type=oneport, name=SSH, port=ssh]";
          backend = "systemd";
          findtime = "10m";
          bantime = "2h";
          maxretry = 5;
        };
      };
    };
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        AllowAgentForwarding = "no";
        AllowTcpForwarding = "no";
        AllowUsers = null;
        ClientAliveCountMax = 3;
        KbdInteractiveAuthentication = false;
        LogLevel = "VERBOSE";
        MaxAuthTries = 3;
        MaxSessions = 2;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        TCPKeepAlive = "no";
        X11Forwarding = false;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "3d";
      options = "--delete-older-than 3d";
    };
  };

  system.stateVersion = "25.05";
}

