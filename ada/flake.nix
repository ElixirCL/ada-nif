{
  description = "Ada hello world";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        adahello = pkgs.callPackage ./build.nix {};
      });

    devShells = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        default = pkgs.mkShell {
          name = "ada-hello-dev-shell";
          packages = with pkgs; [
            gnat
            gprbuild
            gdb
            alire
            erlang
            glibc.dev
            glibc.static
            git
          ];
          shellHook = ''
            echo "Available commands: gnat, gprbuild, gdb"

            export ERLANG_INCLUDE_DIR="-I${pkgs.erlang}/lib/erlang/usr/include"
            export GLIBC_INCLUDE_DIR="-I${pkgs.glibc.dev}/include"
            export GCC_INCLUDE_DIR="-I${pkgs.gcc.cc}/include"
          '';
        };
      });
  };
}
