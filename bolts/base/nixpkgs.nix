{ config, lib, ... }: {
  options.nixpkgs = {
    main = lib.mkOption {
      type = lib.types.str;
      default = "unstable";
    };
    others = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };

  config = {
    inputs = lib.listToAttrs (
      (map (version: {
        name = "nixpkgs-" + version;
        value.url = "github:NixOS/nixpkgs/nixos-${version}";
      }) config.nixpkgs.others)
      ++ [
        {
          name = "nixpkgs";
          value.url = "github:NixOS/nixpkgs/nixos-${config.nixpkgs.main}";
        }
      ]
    );

    buildArgs =
      args:
      lib.listToAttrs (
        (map (version: {
          name = "pkgs-${version}";
          value = args.inputs."nixpkgs-${version}".legacyPackages.${args.system};
        }) config.nixpkgs.others)
        ++ [
          {
            name = "pkgs";
            value = args.inputs.nixpkgs.legacyPackages.${args.system};
          }
        ]
      );
  };
}
