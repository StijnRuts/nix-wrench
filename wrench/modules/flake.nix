{ lib, wrench, ... }:
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
        merge = wrench.merge.options;
      };
      apply = x: if builtins.isFunction x then x else (_: x);
      default = _: { };
    };
  };
}
