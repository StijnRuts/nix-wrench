{
  config,
  lib,
  wrench,
  ...
}:
{
  options.templates = lib.mkOption {
    type = wrench.types."<name>";
    default = null;
  };

  config = lib.mkIf (config.templates != null) {
    outputs = inputs: {
      templates = wrench.options."<name>" {
        inherit inputs;
        values = config.templates;
      };
    };
  };
}
