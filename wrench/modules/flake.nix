{ lib, ... }:
let
  mergeValues =
    name: a: b:
    if builtins.isAttrs a && builtins.isAttrs b then
      mergeAttrs name a b
    else if builtins.isFunction a && builtins.isFunction b then
      x: mergeValues name (a x) (b x)
    else if a == b then
      a
    else
      builtins.throw "conflicting value at `${builtins.concatStringsSep "." name}'";

  mergeAttrs =
    name: a: b:
    builtins.listToAttrs (
      builtins.map (k: {
        name = k;
        value =
          if builtins.hasAttr k a && builtins.hasAttr k b then
            mergeValues (name ++ [ k ]) a.${k} b.${k}
          else if builtins.hasAttr k a then
            a.${k}
          else
            b.${k};
      }) (builtins.attrNames (a // b))
    );
in
{
  options = {
    inputs = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
    outputs = lib.mkOption {
      type = lib.mkOptionType {
        name = "flakeOutputs";
        description = "flake outputs";
        check = _: true;
        merge = name: defs: builtins.foldl' (acc: d: mergeValues name acc d.value) (_: { }) defs;
      };
      apply = x: if builtins.isFunction x then x else (_: x);
      default = _: { };
    };
  };
}
