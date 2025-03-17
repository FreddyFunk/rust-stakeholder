{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    fenix,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        fenix_pkgs = fenix.packages.${system};
      in {
        nixpkgs.overlays = [fenix.overlays.default];
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [pkgs.pkg-config pkgs.opencv];
          packages = [
            (
              fenix_pkgs.fromToolchainFile {
                file = ./rust-toolchain.toml;
                sha256 = "sha256-AJ6LX/Q/Er9kS15bn9iflkUwcgYqRQxiOIL2ToVAXaU=";
              }
            )
            pkgs.rust-analyzer
          ];
        };
      }
    );
}
