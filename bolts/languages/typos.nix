{
  packages.typos-lsp = { pkgs, ... }: pkgs.typos-lsp;

  treefmt = {
    programs.typos.enable = true;
  };
}
