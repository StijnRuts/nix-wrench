{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixlib.url = "github:nix-community/nixpkgs.lib";
  };
  outputs =
    inputs:
    let
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      devShells.x86_64-linux.shellA = pkgs.mkShell {
        packages = [ pkgs.cmatrix ];
      };
    };
}
