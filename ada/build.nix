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

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    export ERLANG_INCLUDE_DIR="-I${erlang}/lib/erlang/usr/include"
    export GLIBC_INCLUDE_DIR="-I${glibc.dev}/include"
    export GCC_INCLUDE_DIR="-I${gcc.cc}/include"

    # alr build
    gprbuild

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    gprinstall --prefix=$out erlang_nifs.gpr \
      --no-project \
      --no-manifest \
      --mode=usage

    for dir in obj/Debug obj/development obj; do
      if [ -f "$dir/Erlang_Nifs.so" ]; then
        cp "$dir/Erlang_Nifs.so" $out
      fi
    done

    runHook postInstall
  '';
}
