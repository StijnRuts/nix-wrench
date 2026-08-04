{ lib, ... }: {
  packages.css-lsp = { pkgs, ... }: pkgs.stylelint-lsp;

  treefmt = { pkgs, ... }: {
    settings.formatter = {
      stylelint = {
        command = "${lib.getExe pkgs.stylelint}";
        options = [ "--fix" ];
        includes = [ "*.css" ];
      };
    };
  };
}
