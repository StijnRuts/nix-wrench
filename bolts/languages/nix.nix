{
  devShells.default = { pkgs, ... }: { packages = [ pkgs.nixd ]; };
  treefmt = {
    programs = {
      nixfmt.enable = true;
      nixfmt.strict = true;
      statix.enable = true;
      deadnix.enable = true;
    };
  };
}
