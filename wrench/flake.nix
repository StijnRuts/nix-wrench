{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      lib = inputs.nixpkgs.lib;
    in
    {
      lib.loadModules =
        path: inp:
        let
          listModules =
            path:
            lib.pipe path [
              builtins.readDir
              builtins.attrNames
              (builtins.map (p: "${path}/${p}"))
            ];

          config =
            (lib.evalModules {
              modules = (listModules path) ++ (listModules ./modules);
            }).config;

          flakeTemplate = lib.generators.toPretty { } {
            inputs = (config.inputs) // {
              wrench = {
                url = "./wrench";
                inputs.nixpkgs.follows = "nixpkgs";
              };
            };
            outputs = "<outputs>";
          };

          flakeContents =
            lib.replaceString "\"<outputs>\"" "inputs: inputs.wrench.lib.loadModules ./modules inputs"
              flakeTemplate;

          extra = {
            apps = builtins.listToAttrs (
              builtins.map (
                system:
                let
                  pkgs' = inputs.nixpkgs.legacyPackages.${system};
                in
                {
                  name = system;
                  value = {
                    wrench = {
                      type = "app";
                      program = "${pkgs'.writeShellScriptBin "wrench" ''
                        cat > flake.nix << 'EOF'
                        ${flakeContents}
                        EOF
                      ''}/bin/wrench";
                    };
                  };
                }
              ) systems
            );
          };
        in
        lib.recursiveUpdate (config.outputs inp) extra;
    };
}
