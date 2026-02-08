{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      packagename = "drgsaveedit";

      pythonEnv = pkgs.python3.withPackages (ps: [
        ps.pyside6
      ]);

      runcommand = "cd ${self} && python ./src/main/python/main.py";

      packagelist = with pkgs; [
        pythonEnv
        zstd
        libGL
        fontconfig
        freetype
        libxkbcommon
        wayland
        libdecor
      ];
    in
    {
      packages.${system}.${packagename} = pkgs.buildFHSEnv {
        name = "${packagename}";
        targetPkgs = pkgs: packagelist;
        runScript = "sh -c '${runcommand}'";
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.${packagename}}/bin/${packagename}";
      };
    };
}
