{
  config,
  username,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.users.users.${username}.home}/.config/sops/age/keys.txt";
  };
}
