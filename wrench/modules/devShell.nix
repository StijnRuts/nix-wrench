{
  config,
  lib,
  wrench,
  ...
}:
{
  options = {
    devShells = lib.mkOption {
      type = (lib.types.attrsOf (lib.types.functionTo lib.types.attrs)) // {
        merge = wrench.merge.options;
      };
      default = { };
    };
  };
  config.outputs = inputs: {
    devShells = lib.genAttrs config.systems (
      system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      builtins.mapAttrs (_: shell: pkgs.mkShell (shell pkgs)) config.devShells
    );
  };
}
