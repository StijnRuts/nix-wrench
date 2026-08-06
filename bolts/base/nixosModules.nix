{
  config,
  lib,
  wrench,
  ...
}:
{
  options.nixosModules = lib.mkOption {
    type = wrench.types.fnAttrs;
    default = null;
  };

  config = lib.mkIf (config.nixosModules != null) {
    outputs = inputs: { nixosModules = config.nixosModules { inherit inputs; }; };
  };
}
