{ lib, ... }:
let
  collect =
    p:
    let
      isNix = val: (builtins.isPath val) && (lib.hasSuffix ".nix" (toString val));
    in
    if builtins.isPath p && lib.pathIsDirectory p then
      lib.pipe p [
        builtins.readDir
        (lib.mapAttrs' (
          key: _val: {
            name = lib.removeSuffix ".nix" key;
            value = collect (p + ("/" + key));
          }
        ))
        (lib.filterAttrs (_key: val: (builtins.isAttrs val) || (isNix val)))
      ]
    else
      p;
in
collect
