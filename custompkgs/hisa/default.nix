{ lib, stdenv
, fetchzip
, unzip # required for bundled zip
# need to provide a matching version of openfoam
, openfoam ? null
, version ? "bundled"
}:
assert lib.asserts.assertMsg (openfoam != null) "a valid OpenFOAM package is required to be built against";
assert lib.asserts.assertOneOf "version" version [ "bundled" "unstable" ];
stdenv.mkDerivation rec {
  pname = "hisa";
  inherit version;

  # In both cases, the zip is automatically extracted
  src = 
    if (version == "bundled") then
      ./hisa-master.zip
    else
      fetchzip {
        url = "https://sourceforge.net/projects/hisa/files/hisa-master.zip/download";
      }
    ;

  buildInputs = [ openfoam ] ++ openfoam.buildInputs;
  nativeBuildInputs = [ unzip ];

  configurePhase = ''
    for f in $(find . -name Allwmake); do
      patchShebangs "$f"
    done
    '';
  buildPhase = ''
    echo "build is combined with install"
    '';
  installPhase = ''
    mkdir pseudo-home
    export HOME=$(readlink -f pseudo-home)
    source ${openfoam}/opt/OpenFOAM/OpenFOAM-v${openfoam.version}/etc/bashrc || echo 'Ignore spurious sourcing error'
    ./Allwmake
    echo "Binaries: $(ls $WM_PROJECT_USER_DIR/platforms/$WM_OPTIONS/bin)"
    echo "Libaries: $(ls $WM_PROJECT_USER_DIR/platforms/$WM_OPTIONS/lib)"
    install -Dt $out/bin -m755 $WM_PROJECT_USER_DIR/platforms/$WM_OPTIONS/bin/*
    install -Dt $out/lib -m755 $WM_PROJECT_USER_DIR/platforms/$WM_OPTIONS/lib/*
    '';

  meta = with lib; {
    description = "cfdof version of cfmesh, easy-to-use CFD meshing tool";
    homepage = "https://cfmesh.com/cfmesh-open-source/";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}