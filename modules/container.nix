{
  nixosConfigurations.container = { inputs, ... }: {
    system = "x86_64-linux";
    modules = [
      inputs.self.nixosModules.hello
      {
        boot.isContainer = true;
        fileSystems."/" = {
          device = "/dev/null";
          fsType = "ext4";
        };
      }
    ];
  };
}
