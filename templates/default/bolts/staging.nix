{
  nixosConfigurations.staging = { inputs, ... }: {
    system = "x86_64-linux";
    modules = [
      inputs.wrench.nixosModules.container_guest
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
