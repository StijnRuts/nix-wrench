{ lib, ... }:
{
  options = {
    systems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    };
  };
}
