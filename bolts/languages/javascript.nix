{ config, lib, ... }: {
  options.javascript = {
    version = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    slim = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = {
    packages.javascript-tools =
      { pkgs, ... }:
      pkgs.symlinkJoin {
        name = "javascript-tools";
        paths = [
          pkgs."nodejs${if config.javascript.slim then "-slim" else ""}${
            if config.javascript.version != null then "_" + config.javascript.version else ""
          }"
          pkgs.esbuild
        ];
      };

    packages.javascript-lsp = { pkgs, ... }: pkgs.typescript-language-server;

    treefmt = {
      programs.biome = {
        enable = true;
        includes = [
          "*.js"
          "*.mjs"
          "*.cjs"
          "*.jsx"
        ];
      };
    };
  };
}
