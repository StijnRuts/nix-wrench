{
  nixosConfigurations.dev = { inputs, ... }: {
    system = "x86_64-linux";
    modules = [
      inputs.self.nixosModules.container-guest-dev
      inputs.self.nixosModules.hello
    ];
  };

  containers.dev = {
    # projectMount.target = "/mnt/project";
    # mounts.data = {
    #   source = "/path/to/data";
    #   target = "/mnt/data";
    # };
  };
}
