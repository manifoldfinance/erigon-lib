{
  inputs,
  pkgs,
}: let
  inherit (pkgs) system;
  # devshell
  devshell = import inputs.devshell {inherit system;};
in {
  default = devshell.mkShell {
    name = "erigon-lib";
    env = [
      {
        name = "GOROOT";
        value = "${pkgs.go_1_18}/share/go";
      }
    ];
    packages = with pkgs; [
      gcc
      gnumake
      coreutils
      go_1_18
      delve
      gotools
      just

      moq
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc

      unzip
    ];
  };
}
