_: {
  config = {
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    buildArgs = args: { pkgs = args.inputs.nixpkgs.legacyPackages.${args.system}; };
  };
}
