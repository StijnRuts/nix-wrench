{
  packages.container =
    { pkgs, ... }:
    pkgs.writeShellApplication {
      name = "container";
      runtimeInputs = with pkgs; [
        git
        incus
      ];
      text = builtins.readFile ./container.sh;
    };
}
