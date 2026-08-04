{
  packages.typescript-tools = { pkgs, ... }: pkgs.typescript;

  packages.typescript-lsp = { pkgs, ... }: pkgs.typescript-language-server;

  treefmt = {
    programs.biome = {
      enable = true;
      includes = [
        "*.ts"
        "*.mts"
        "*.cts"
        "*.tsx"
        "*.d.ts"
        "*.d.cts"
        "*.d.mts"
      ];
    };
  };
}
