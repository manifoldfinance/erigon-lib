{
  description = "Ethereum implementation on the efficiency frontier";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # packages
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;

    # libraries
    flake-utils.url = github:numtide/flake-utils;
    treefmt-nix.url = github:numtide/treefmt-nix;
    devshell = {
      url = github:numtide/devshell;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    gomod2nix = {
      url = github:nix-community/gomod2nix;
      inputs.utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    treefmt-nix,
    gomod2nix,
    ...
  } @ inputs: let
    inherit (flake-utils.lib) eachSystem mkApp system;
    packageName = "erigon";
    supportedSystems = with system; [x86_64-linux];
  in (eachSystem supportedSystems (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [gomod2nix.overlays.default];
    };

    treefmt = treefmt-nix.lib.mkWrapper pkgs {
      projectRootFile = ".git/config";
      programs = {
        gofmt.enable = true;
        alejandra.enable = true;
      };
    };
  in {
    # nix flake check
    checks = import ./checks.nix {
      inherit self pkgs;
    };

    # generic shell:  nix develop
    # specific shell: nix develop .#<devShells.${system}.default>
    devShells = import ./devshell.nix {
      inherit inputs pkgs;
    };

    formatter = treefmt;
  }));
}
