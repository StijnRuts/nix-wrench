{
  packages.bash-lsp = { pkgs, ... }: pkgs.bash-language-server;

  treefmt = {
    programs = {
      shfmt.enable = true;
      shellcheck.enable = true;
    };
  };
}
