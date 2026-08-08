{ lib, ... }: {
  packages.less-tools = { pkgs, ... }: pkgs.lessc;

  packages.less-lsp = { pkgs, ... }: pkgs.stylelint-lsp;

  treefmt = { pkgs, ... }: {
    settings.formatter = {
      stylelint-less = {
        command = "${lib.getExe pkgs.stylelint}";
        options = [ "--fix" ];
        includes = [ "*.less" ];
      };
    };
  };
}
