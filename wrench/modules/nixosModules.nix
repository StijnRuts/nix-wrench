{
  config,
  lib,
  wrench,
  ...
}:
{
  options.nixosModules = lib.mkOption {
    type = wrench.types.attrs;
    default = null;
  };

  config = lib.mkIf (config.nixosModules != null) {
    outputs = _inputs: {
      inherit (config) nixosModules;
    };
  };
}
