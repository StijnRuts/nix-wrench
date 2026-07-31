{
  devShells.default = { pkgs, ... }: {
    packages = [ pkgs.hello ];
  };
  nixosModules.hello = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.hello
    ];
  };
}
