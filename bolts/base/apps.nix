{
  config,
  lib,
  wrench,
  ...
}:
{
  options.apps = lib.mkOption {
    type = wrench.types."<system>.<name>";
    default = null;
  };

  config = lib.mkIf (config.apps != null) {
    outputs = inputs: {
      apps = wrench.options."<system>.<name>" {
        inherit (config) systems buildArgs;
        inherit inputs;
        values = config.apps;
      };
    };
  };
}
