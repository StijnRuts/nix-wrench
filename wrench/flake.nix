{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      merge = import ./lib/merge.nix { inherit lib; };
      types = import ./lib/types.nix { inherit lib merge; };
      options = import ./lib/options.nix { inherit lib; };
      loadModules = import ./lib/loadModules.nix {
        inherit lib wrench;
        modulesDir = ./modules;
      };
      wrench = {
        inherit
          merge
          types
          options
          loadModules
          ;
      };
    in
    {
      lib = wrench;
    };
}
