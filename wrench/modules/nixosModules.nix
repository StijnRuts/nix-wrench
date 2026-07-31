{
  config,
  lib,
  wrench,
  ...
}:
{
  options.nixosModules = lib.mkOption {
    type = wrench.types."<name>";
  };

  config = lib.mkIf (config.nixosModules != null) {
    outputs = inputs: {
      nixosModules = wrench.options."<name>" {
        inherit inputs;
        values = config.nixosModules;
      };
    };
  };
}
