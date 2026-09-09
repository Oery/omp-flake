{
  description = "Nix package for the OMP coding agent";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          omp = pkgs.callPackage ./package.nix { };
          default = self.packages.${system}.omp;
        });

      apps = forAllSystems (system: {
        omp = {
          type = "app";
          program = "${self.packages.${system}.omp}/bin/omp";
        };
        default = self.apps.${system}.omp;
      });

      overlays.default = final: prev: {
        omp = final.callPackage ./package.nix { };
      };
    };
}
