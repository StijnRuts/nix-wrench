{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;

      wrench = {
        merge = {
          values =
            name: a: b:
            if builtins.isAttrs a && builtins.isAttrs b then
              wrench.merge.attrs name a b
            else if builtins.isList a && builtins.isList b then
              a ++ b
            else if builtins.isFunction a && builtins.isFunction b then
              x: wrench.merge.values name (a x) (b x)
            else if a == b then
              a
            else
              builtins.throw "conflicting value at `${builtins.concatStringsSep "." name}'";

          attrs =
            name: a: b:
            builtins.listToAttrs (
              builtins.map (k: {
                name = k;
                value =
                  if builtins.hasAttr k a && builtins.hasAttr k b then
                    wrench.merge.values (name ++ [ k ]) a.${k} b.${k}
                  else if builtins.hasAttr k a then
                    a.${k}
                  else
                    b.${k};
              }) (builtins.attrNames (a // b))
            );

          options =
            name: defs:
            builtins.foldl' (acc: d: wrench.merge.values name acc d.value) (builtins.head defs).value (
              builtins.tail defs
            );
        };

        loadModules =
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
                specialArgs = { inherit wrench; };
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
                ) config.systems
              );
            };
          in
          lib.recursiveUpdate (config.outputs inp) extra;
      };
    in
    {
      lib = wrench;
    };
}
