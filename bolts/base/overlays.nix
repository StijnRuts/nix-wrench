{
  config,
  lib,
  wrench,
  ...
}:
{
  options.overlays = lib.mkOption {
    type = wrench.types."<name>";
    default = null;
  };

  config = lib.mkIf (config.overlays != null) {
    outputs = inputs: {
      overlays = wrench.options."<name>" {
        inherit inputs;
        values = config.overlays;
      };
    };
  };
}
