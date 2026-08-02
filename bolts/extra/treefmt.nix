{
  config,
  lib,
  wrench,
  ...
}:
{
  options.treefmt = lib.mkOption {
    type = wrench.types.fnAttrs;
    default = null;
  };

  config = lib.mkIf (config.treefmt != null) {
    inputs = {
      treefmt-nix = {
        url = "github:numtide/treefmt-nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    formatter =
      { inputs, pkgs, ... }:
      let
        treefmt = inputs.treefmt-nix.lib.evalModule pkgs (config.treefmt { inherit inputs pkgs; });
      in
      treefmt.config.build.wrapper;

    checks.formatting =
      { inputs, pkgs, ... }:
      let
        treefmt = inputs.treefmt-nix.lib.evalModule pkgs (config.treefmt { inherit inputs pkgs; });
      in
      treefmt.config.build.check inputs.self;
  };
}
