{
  systems = [
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  nixpkgs = {
    main = "26.05";
    others = [ "unstable" ];
  };
}
