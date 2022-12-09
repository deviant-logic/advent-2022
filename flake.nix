{
  description = "Advent of Code - 2022";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {self, nixpkgs, flake-utils }:
    with flake-utils.lib;
      eachDefaultSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        rec {
          packages = flattenTree {
            swi = pkgs.swiProlog;
          };
        apps.swipl = mkApp { drv = packages.swi; };
        devShell = pkgs.mkShell {
          packages = [packages.swi];
        };

        }
      );
}
