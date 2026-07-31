{ lib, merge }:
rec {
  withMerge = type: type // { merge = merge.options; };

  coercedToFunction = type: lib.types.coercedTo type (cfg: _: cfg) (lib.types.functionTo type);

  attrs = lib.types.nullOr (withMerge lib.types.attrs);

  fnAttrs = lib.types.nullOr (coercedToFunction (withMerge lib.types.attrs));

  "<name>" = lib.types.nullOr (lib.types.attrsOf (coercedToFunction (withMerge lib.types.attrs)));

  "<system>" = lib.types.nullOr (coercedToFunction (withMerge lib.types.attrs));

  "<system>.<name>" = lib.types.nullOr (
    lib.types.attrsOf (coercedToFunction (withMerge lib.types.attrs))
  );
}
