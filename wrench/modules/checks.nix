{
  config,
  lib,
  wrench,
  ...
}:
{
  options.checks = lib.mkOption {
    type = wrench.types."<system>.<name>";
  };

  config = lib.mkIf (config.checks != null) {
    outputs = inputs: {
      checks = wrench.options."<system>.<name>" {
        inherit (config) systems;
        inherit inputs;
        values = config.checks;
      };
    };
  };
}
