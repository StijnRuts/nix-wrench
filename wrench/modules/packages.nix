{
  config,
  lib,
  wrench,
  ...
}:
{
  options.packages = lib.mkOption {
    type = wrench.types."<system>.<name>";
    default = null;
  };

  config = lib.mkIf (config.packages != null) {
    outputs = inputs: {
      packages = wrench.options."<system>.<name>" {
        inherit (config) systems;
        inherit inputs;
        values = config.packages;
      };
    };
  };
}
