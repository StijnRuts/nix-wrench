{ lib }:
rec {
  forEachSystem =
    {
      systems,
      inputs,
      transform ? _pkgs: x: x,
    }:
    lib.genAttrs systems (system: transform inputs.nixpkgs.legacyPackages.${system});

  "<name>" =
    {
      inputs,
      transform ? x: x,
      values,
    }:
    builtins.mapAttrs (
      _: value:
      transform (value {
        inherit inputs;
      })
    ) values;

  "<system>" =
    {
      systems,
      inputs,
      transform ? _pkgs: x: x,
      value,
    }:
    forEachSystem {
      inherit systems inputs;
      transform =
        pkgs:
        transform pkgs (value {
          inherit inputs pkgs;
          system = pkgs.stdenv.hostPlatform.system;
        });
    };

  "<system>.<name>" =
    {
      systems,
      inputs,
      transform ? _pkgs: x: x,
      values,
    }:
    forEachSystem {
      inherit systems inputs;
      transform =
        pkgs:
        builtins.mapAttrs (
          _: value:
          transform pkgs (value {
            inherit inputs pkgs;
            system = pkgs.stdenv.hostPlatform.system;
          })
        ) values;
    };
}
