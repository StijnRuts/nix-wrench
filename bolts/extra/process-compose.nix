{ config, lib, ... }: {
  options.processes = lib.mkOption {
    type = lib.types.attrs;
    default = null;
  };

  config = lib.mkIf (config.processes != null) {
    packages.processes =
      { pkgs, ... }:
      pkgs.writeShellApplication {
        name = "processes";
        meta.mainProgram = "processes";
        runtimeInputs = with pkgs; [
          process-compose
        ];
        text = ''
          process-compose up --config ${
            pkgs.writeText "config" (lib.generators.toYAML { } { inherit (config) processes; })
          }
        '';
      };

    apps.processes = { inputs, system, ... }: {
      type = "app";
      meta.description = "Launch process-compose";
      program = "${inputs.self.packages.${system}.processes}/bin/processes";
    };
  };
}
