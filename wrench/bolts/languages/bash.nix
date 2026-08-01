{
  devShells.default = { pkgs, ... }: {
    packages = [ pkgs.bash-language-server ];
  };
  treefmt = {
    programs = {
      shfmt.enable = true;
      shellcheck.enable = true;
    };
  };
}
