{ lib, wrench, ... }: {
  options = {
    inputs = lib.mkOption { type = wrench.types.attrs; };
    outputs = lib.mkOption { type = wrench.types.fnAttrs; };
  };
}
