_: rec {
  values =
    name: a: b:
    if builtins.isAttrs a && builtins.isAttrs b then
      attrs name a b
    else if builtins.isList a && builtins.isList b then
      a ++ b
    else if builtins.isFunction a && builtins.isFunction b then
      x: values name (a x) (b x)
    else if a == null then
      b
    else if b == null then
      a
    else if a == b then
      a
    else
      throw "conflicting value at `${builtins.concatStringsSep "." name}'";

  attrs =
    name: a: b:
    builtins.listToAttrs (
      map (k: {
        name = k;
        value =
          if builtins.hasAttr k a && builtins.hasAttr k b then
            values (name ++ [ k ]) a.${k} b.${k}
          else if builtins.hasAttr k a then
            a.${k}
          else
            b.${k};
      }) (builtins.attrNames (a // b))
    );

  options = name: defs: builtins.foldl' (acc: d: values name acc d.value) null defs;
}
