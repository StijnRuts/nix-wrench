{ lib, ... }: {
  packages.sass-tools = { pkgs, ... }: pkgs.dart-sass;

  packages.sass-lsp = { pkgs, ... }: pkgs.stylelint-lsp;

  treefmt = { pkgs, ... }: {
    settings.formatter = {
      stylelint-sass = {
        command = "${lib.getExe pkgs.stylelint}";
        options = [ "--fix" ];
        includes = [
          "*.scss"
          "*.sass"
        ];
      };
    };
  };
}
