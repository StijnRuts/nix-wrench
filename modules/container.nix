{
  devShells.default = { inputs, system, ... }: {
    packages = [
      inputs.self.packages.${system}.container
    ];
  };
  nixosConfigurations.container = { inputs, ... }: {
    system = "x86_64-linux";
    modules = [
      inputs.self.nixosModules.hello
      {
        boot.isContainer = true;
        networking.useDHCP = true;
        fileSystems."/" = {
          device = "/dev/null";
          fsType = "ext4";
        };
        system.stateVersion = "26.05";
      }
    ];
  };
}
