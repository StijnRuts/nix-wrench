{ config, lib, ... }: {
  options.containers = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          version = lib.mkOption {
            type = lib.types.str;
            default = config.nixpkgs.main;
          };
          autostart = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
          projectMount = lib.mkOption {
            type = lib.types.submodule {
              options.target = lib.mkOption {
                type = lib.types.str;
                default = "/mnt/project";
              };
              options.shift = lib.mkOption {
                type = lib.types.bool;
                default = true;
              };
            };
            default = { };
          };
          mounts = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options.source = lib.mkOption { type = lib.types.str; };
                options.target = lib.mkOption { type = lib.types.str; };
                options.shift = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
              }
            );
            default = { };
          };
        };
      }
    );
    default = { };
  };

  config = {
    packages.container-setup =
      { pkgs, ... }:
      pkgs.writeShellApplication {
        name = "container-setup";
        meta.mainProgram = "container-setup";
        runtimeInputs = with pkgs; [
          git
          incus
          jq
        ];
        text = builtins.readFile ./container-setup.sh;
      };

    packages.container-watch =
      { pkgs, ... }:
      pkgs.writeShellApplication {
        name = "container-watch";
        meta.mainProgram = "container-watch";
        runtimeInputs = with pkgs; [
          git
          incus
          watchexec
        ];
        text = builtins.readFile ./container-watch.sh;
      };

    apps.container-setup = { inputs, system, ... }: {
      type = "app";
      meta.description = "Create, start, and update an Incus container";
      program = "${inputs.self.packages.${system}.container-setup}/bin/container-setup";
    };

    apps.container-watch = { inputs, system, ... }: {
      type = "app";
      meta.description = "Watch project files and rebuild an Incus container";
      program = "${inputs.self.packages.${system}.container-watch}/bin/container-watch";
    };

    processes =
      args:
      lib.concatMapAttrs (
        name: cfg:
        let
          fullName = "${config.project.name}-${name}";
          nixosConfig = name;
          setup = args.inputs.self.packages.${args.system}.container-setup;
          watch = args.inputs.self.packages.${args.system}.container-watch;
          mounts = args.pkgs.writeText "mounts.json" (builtins.toJSON cfg.mounts);
        in
        {
          "container-setup-${name}" = {
            command = "${setup}/bin/container-setup ${cfg.version} ${fullName} ${nixosConfig} ${cfg.projectMount.target} ${mounts}";
            disabled = !cfg.autostart;
          };
          "container-watch-${name}" = {
            command = "${watch}/bin/container-watch ${fullName} ${nixosConfig} ${cfg.projectMount.target}";
            disabled = !cfg.autostart;
            depends_on = {
              "container-setup-${name}".condition = "process_completed_successfully";
            };
          };
        }
      ) config.containers;

    nixosModules.container_guest = _: {
      boot.isContainer = true;
      networking.useDHCP = true;
      system.stateVersion = config.nixpkgs.main;
    };

    nixosModules.container_host = _: {
      # TODO
    };
  };
}
