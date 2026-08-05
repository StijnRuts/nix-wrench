{
  nixosConfigurations.staging = { inputs, ... }: {
    system = "x86_64-linux";
    modules = [
      inputs.self.nixosModules.container-guest-staging
      inputs.self.nixosModules.hello
    ];
  };

  containers.staging = {
    # projectMount.target = "/mnt/project";
    # mounts.data = {
    #   source = "/path/to/data";
    #   target = "/mnt/data";
    # };
    autostart = false;
  };
}
