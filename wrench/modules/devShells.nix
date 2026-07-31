{
  config,
  lib,
  wrench,
  ...
}:
{
  options.devShells = lib.mkOption {
    type = wrench.types."<system>.<name>";
    default = null;
  };

  config = lib.mkIf (config.devShells != null) {
    outputs = inputs: {
      devShells = wrench.options."<system>.<name>" {
        inherit (config) systems;
        inherit inputs;
        values = config.devShells;
        transform = pkgs: pkgs.mkShell;
      };
    };
  };
}
