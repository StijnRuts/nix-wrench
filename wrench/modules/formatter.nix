{
  config,
  lib,
  wrench,
  ...
}:
{
  options.formatter = lib.mkOption {
    type = wrench.types."<system>";
  };

  config = lib.mkIf (config.formatter != null) {
    outputs = inputs: {
      formatter = wrench.options."<system>" {
        inherit (config) systems;
        inherit inputs;
        value = config.formatter;
      };
    };
  };
}
