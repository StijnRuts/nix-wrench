{
  config,
  lib,
  wrench,
  ...
}:
{
  options.nixosConfigurations = lib.mkOption {
    type = wrench.types."<name>";
  };

  config = lib.mkIf (config.nixosConfigurations != null) {
    outputs = inputs: {
      nixosConfigurations = wrench.options."<name>" {
        inherit inputs;
        transform = lib.nixosSystem;
        values = config.nixosConfigurations;
      };
    };
  };
}
