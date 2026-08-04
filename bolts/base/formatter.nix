{
  config,
  lib,
  wrench,
  ...
}:
{
  options.formatter = lib.mkOption {
    type = wrench.types."<system>";
    default = null;
  };

  config = lib.mkIf (config.formatter != null) {
    outputs = inputs: {
      formatter = wrench.options."<system>" {
        inherit (config) systems buildArgs;
        inherit inputs;
        value = config.formatter;
      };
    };
  };
}
