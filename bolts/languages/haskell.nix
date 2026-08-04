{ config, lib, ... }: {
  options.haskell = {
    version = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    packages = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = _: [ ];
    };
  };

  config = {
    packages.haskell-tools =
      { pkgs, ... }:
      let
        ghc =
          if config.haskell.version != null then
            pkgs.haskell.packages."ghc${lib.replaceString "." "" config.haskell.version}"
          else
            pkgs.haskellPackages;
      in
      pkgs.symlinkJoin {
        name = "haskell-tools";
        paths = [
          (ghc.ghcWithPackages config.haskell.packages)
          pkgs.cabal-install
          pkgs.ghcid
        ];
      };

    packages.haskell-lsp = { pkgs, ... }: pkgs.haskell-language-server;

    treefmt = {
      programs = {
        ormolu.enable = true;
        hlint.enable = true;
        cabal-gild.enable = true;
      };
    };
  };
}
