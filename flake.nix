{
  description = "c3c fft";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    c3c.url = "github:c3lang/c3c";
  };

  outputs = { self, nixpkgs, flake-utils, c3c, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        c3cPkg = c3c.packages.${system}.c3c;
      in
      {
        packages.c3-fft = pkgs.stdenv.mkDerivation {
          pname = "c3-fft";
          version = "0.1";
          src = self;

          nativeBuildInputs = [ c3cPkg ];

          buildPhase = ''
            mkdir -p build
            cp -r $src/* build/
            cd build
            c3c -o fft src/fft.c3
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp build/fft $out/bin/
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [ c3cPkg ];
        };
      }
    );
}
