{ config, lib, ... }: {
  options.purescript = {
    version = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = {
    inputs = {
      easy-purescript-nix.url = "github:justinwoo/easy-purescript-nix";
    };

    buildArgs = args: { purs-pkgs = args.inputs.easy-purescript-nix.packages.${args.system}; };

    packages.purescript-tools =
      { pkgs, purs-pkgs, ... }:
      pkgs.symlinkJoin {
        name = "purescript-tools";
        paths = [
          (
            if config.purescript.version != null then
              purs-pkgs."purs-${lib.replaceString "." "_" config.purescript.version}"
            else
              pkgs.purescript
          )
          purs-pkgs.spago
          purs-pkgs.psa
          purs-pkgs.pscid
        ];
      };

    packages.purescript-lsp = { purs-pkgs, ... }: purs-pkgs.purescript-language-server;

    treefmt = { purs-pkgs, ... }: {
      settings.formatter = {
        "purs-tidy" = {
          command = "${lib.getExe purs-pkgs.purs-tidy}";
          options = [ "format-in-place" ];
          includes = [ "*.purs" ];
        };
      };
    };
  };
}
