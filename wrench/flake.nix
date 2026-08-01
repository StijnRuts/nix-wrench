{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      collect = import ./lib/collect.nix { inherit lib; };
    in
    lib.fix (wrench: {
      bolts = collect ./bolts;
      lib = lib.mapAttrsRecursive (_path: value: (import value) { inherit lib wrench; }) (collect ./lib);
      inherit (wrench.lib) types options;
    });
}
