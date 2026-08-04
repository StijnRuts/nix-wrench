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

    buildArgs = args: {
      treefmt = args.inputs.treefmt-nix.lib.evalModule args.pkgs (config.treefmt args);
    };

    formatter = args: args.treefmt.config.build.wrapper;
    checks.formatting = args: args.treefmt.config.build.check args.inputs.self;
  };
}
