{
  inputs = {
    home-manager = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "github:nix-community/home-manager";
    };
    nixlib = {
      url = "github:nix-community/nixpkgs.lib";
    };
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    wrench = {
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
      url = "./wrench";
    };
  };
  outputs = inputs: inputs.wrench.lib.loadModules ./modules inputs;
}
