{
  config,
  lib,
  wrench,
  ...
}:
{
  options.nixosConfigurations = lib.mkOption {
    type = wrench.types."<name>";
    default = null;
  };

  config = lib.mkIf (config.nixosConfigurations != null) {
    outputs = inputs: {
      nixosConfigurations = wrench.options."<name>" {
        inherit inputs;
        transform = inputs.nixpkgs.lib.nixosSystem;
        values = config.nixosConfigurations;
      };
    };
  };
}
