{
  packages.container =
    { pkgs, ... }:
    pkgs.writeShellApplication {
      name = "container";
      meta.mainProgram = "container";
      runtimeInputs = with pkgs; [
        git
        incus
      ];
      text = builtins.readFile ./container.sh;
    };

  apps.container = { inputs, system, ... }: {
    type = "app";
    meta.description = "Launch a nixosConfiguration as an Incus container";
    program = "${inputs.self.packages.${system}.container}/bin/container";
  };
}
