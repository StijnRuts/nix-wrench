{
  devShells.default = { pkgs, ... }: {
    packages = [ pkgs.nixd ];
  };
  treefmt = {
    programs = {
      nixfmt.enable = true;
      statix.enable = true;
      deadnix.enable = true;
    };
  };
}
