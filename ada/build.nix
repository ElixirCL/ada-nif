{ stdenv, gnat, gprbuild, glibc, alire, erlang, git, gcc }:

stdenv.mkDerivation {
  name = "ada-static-hello";

  src = ./.;

  nativeBuildInputs = [
    gprbuild
    gnat
    alire
    git
    erlang
  ];

  buildInputs = [
    glibc.dev
    glibc.static
  ];

  NIX_LDFLAGS = "-L${glibc}/lib -L${glibc.static}/lib -L${gcc.cc.lib}/lib";

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    export ERLANG_INCLUDE_DIR="-I${erlang}/lib/erlang/usr/include"
    export GLIBC_INCLUDE_DIR="-I${glibc.dev}/include"
    export GCC_INCLUDE_DIR="-I${gcc.cc}/include"

    # alr build
    gprbuild -P erlang_nifs.gpr -XLIBRARY_TYPE=relocatable

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    gprinstall --prefix=$out erlang_nifs.gpr \
      --no-project \
      --no-manifest \
      --mode=usage

    cp -r ./lib $out

    # for dir in lib; do
    #   if [ -f "$dir/Erlang_Nifs.so.0.1.0-dev" ]; then
    #     cp "$dir/Erlang_Nifs.so.0.1.0-dev" "$out/Erlang_Nifs.so"
    #   fi
    # done

    runHook postInstall
  '';
}
