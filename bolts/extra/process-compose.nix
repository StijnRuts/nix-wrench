{
  config,
  lib,
  wrench,
  ...
}:
{
  options.processes = lib.mkOption {
    type = wrench.types.fnAttrs;
    default = null;
  };

  config = lib.mkIf (config.processes != null) {
    packages.processes =
      args:
      let
        processes = config.processes args;
      in
      args.pkgs.writeShellApplication {
        name = "processes";
        meta.mainProgram = "processes";
        runtimeInputs = with args.pkgs; [ process-compose ];
        text = ''
          process-compose up --keep-project --config ${
            args.pkgs.writeText "config" (lib.generators.toYAML { } { inherit processes; })
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
