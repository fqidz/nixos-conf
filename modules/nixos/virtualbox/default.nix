{ username, ... }:
{
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
      enableKvm = true;
      addNetworkInterface = false;
    };
    guest = {
      enable = true;
      dragAndDrop = true;
      clipboard = true;
    };
  };
  users.extraGroups.vboxusers.members = [ username ];
}
