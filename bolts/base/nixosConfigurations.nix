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
        values = config.nixosConfigurations;
        transform = inputs.nixpkgs.lib.nixosSystem;
      };
    };
  };
}
