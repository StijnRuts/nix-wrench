{
  devShells.default = { pkgs, ... }: {
    packages = [ pkgs.hello ];
  };
}
