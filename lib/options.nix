{ lib, ... }: {
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
      buildArgs ? _args: { },
      transform ? _args: x: x,
      value,
    }:
    lib.genAttrs systems (
      system:
      let
        args = lib.fix (args: { inherit inputs system; } // buildArgs args);
      in
      transform args (value args)
    );

  "<system>.<name>" =
    {
      systems,
      inputs,
      buildArgs ? _args: { },
      transform ? _args: x: x,
      values,
    }:
    lib.genAttrs systems (
      system:
      let
        args = lib.fix (args: { inherit inputs system; } // buildArgs args);
      in
      builtins.mapAttrs (_: value: transform args (value args)) values
    );
}
