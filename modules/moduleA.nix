{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixlib.url = "github:nix-community/nixpkgs.lib";
  };
  devShells.default = { pkgs, ... }: {
    packages = [ pkgs.cmatrix ];
  };
}
