{ pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix

    # ../../modules/nixos/nginx
    ../../modules/nixos/shell
    ../../modules/nixos/sops
    ../../modules/nixos/navidrome
    ../../modules/nixos/samba
    ../../modules/nixos/cloudflared
    # ../../modules/nixos/podman
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Compatible kernel version for zfs
  boot.kernelPackages = pkgs.linuxPackages_7_2;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "d7c17120";
  boot.zfs.extraPools = [ "zpool" ];
  
  fileSystems = {
    "/" = {
       device = "zpool/root";
       fsType = "zfs";
       options = [ "zfsutil" ];
     };

    "/nix" = {
       device = "zpool/nix";
       fsType = "zfs";
       options = [ "zfsutil" ];
     };

    "/var" = {
       device = "zpool/var";
       fsType = "zfs";
       options = [ "zfsutil" ];
     };

    "/home" = {
       device = "zpool/home";
       fsType = "zfs";
       options = [ "zfsutil" ];
     };

    "/storage" = {
       device = "zpool/storage";
       fsType = "zfs";
       options = [ "zfsutil" ];
     };

    "/boot" = {
       device = "/dev/disk/by-id/ata-TOSHIBA_MQ04ABF100_41RSP0PZT-part1";
       fsType = "vfat";
       options = [ "fmask=0022" "dmask=0022" ];
     };
  };

  swapDevices = [{
    device = "/dev/disk/by-id/ata-TOSHIBA_MQ04ABF100_41RSP0PZT-part2";
    randomEncryption = true;
  }];

  # systemd.tmpfiles.settings."01-storage-dir" = {
  #   "/storage".d = {
  #     group = "root";
  #     mode = "0755";
  #     user = "root";
  #   };
  #   "/storage/music/".d = {
  #     group = "navidrome";
  #     mode = "0757";
  #     user = "root";
  #   };
  # };

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Bahrain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "navidrome"
    ];
    packages = with pkgs; [
      zfs
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMDws/ORymgRK53xccja0bv6PqPJjqSvGKrDdI6+oXvq faidz@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMfGHnsdDVeOH+Zbfrn0V9mxAd7b2vAmC9h+yzLEmq7+ eddsa-key-20260903"
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
    # TODO move to separate file
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

  networking.firewall = {
    allowedTCPPorts = [
      22
      80
      443

      18080
      15234
    ];
  };

  networking.hostName = "nixos-homelab";

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

  system.stateVersion = "26.05";
}
