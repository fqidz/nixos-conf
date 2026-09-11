{ pkgs, config, ... }:
let
  usersConfig = import ./users.nix;
  userList = [
    usersConfig.user1
    usersConfig.user2
    usersConfig.user3
    usersConfig.user4
    usersConfig.user5
  ];
in
{
  sops.secrets = builtins.listToAttrs (map (user: {
    name = "samba_pass${builtins.toString user.num}";
    value = {
      key = "pass${builtins.toString user.num}";
      sopsFile = ../../../secrets/samba.yaml;
    };
  }) userList);

  users.users = builtins.listToAttrs (map (user: {
    name = user.name;
    value = {
      description = "Access to samba";
      group = user.name;
      extraGroups = [ "users" ];
      hashedPasswordFile = config.sops.secrets."samba_pass${builtins.toString user.num}".path;
      isSystemUser = true;
    };
  }) userList);

  users.groups = builtins.listToAttrs (map (user: {
    name = user.name;
    value = {};
  }) userList);

  services.samba = {
    enable = true;
    openFirewall = true;
    # package = pkgs.samba4Full;
    package = pkgs.samba;
    settings = {
      global = {
        "server string" = "Arante Samba Server";
        "security" = "user";
        "use sendfile" = "yes";
        "server max protocol" = "SMB3";
      };
      "storage" = {
        "path" = "/storage";
        "hosts allow" = pkgs.lib.strings.join ", " (map (user: user.name) userList) ;
        "browseable" = "yes";
        "writeable" = "yes";
      };
    };
  };

  system.activationScripts = {
    init_smbpasswd.text = pkgs.lib.strings.join " &&\n" (map (user:
      ''/run/current-system/sw/bin/printf "$(/run/current-system/sw/bin/cat ${config.sops.secrets."samba_pass${builtins.toString user.num}".path})\n$(/run/current-system/sw/bin/cat ${config.sops.secrets."samba_pass${builtins.toString user.num}".path})\n" | /run/current-system/sw/bin/smbpasswd -sa ${user.name}''
      ) [
        usersConfig.user1
        usersConfig.user2
        usersConfig.user3
        usersConfig.user4
        usersConfig.user5
    ]);
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
    nssmdns4 = true;
    # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
    enable = true;
    openFirewall = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
}
