{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    crane.url = "github:ipetkov/crane";
    crane.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, crane, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlays = [
          rust-overlay.overlays.default
          (super: self: let rust = super.rust-bin.stable.latest.minimal; in { rustc = rust; cargo = rust; })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
        craneLib = crane.mkLib pkgs;
      in
      {
        packages.default = craneLib.buildPackage {
          src = craneLib.cleanCargoSource ./.;
        };
        devShells.default = pkgs.mkShell {
          packages = [ pkgs.cargo ];
        };
      }
    );
}

