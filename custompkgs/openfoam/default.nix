{ lib, stdenv
, cmake
, boost
, bzip2
, cgal
, fftw
, flex
, openmpi
, paraview
, parmetis
, scotch
, zlib
, version ? "2306"
, hash ? "1z0sna5jxlyfz8s7vi28m47iwjjjbzg9ycz5maz2gymchg7lw6v7"
}:

stdenv.mkDerivation rec {
  pname = "openfoam";
  inherit version;
  foam_hash = hash;

  src = fetchTarball {
    url = "https://develop.openfoam.com/Development/openfoam/-/archive/OpenFOAM-v${version}/openfoam-OpenFOAM-v${version}.tar.gz";
    sha256 = foam_hash;
  };

  buildInputs = [ boost cgal paraview parmetis scotch openmpi fftw zlib ];
  nativeBuildInputs = [ cmake bzip2 flex ];
  propagatedBuildInputs = [ openmpi paraview ];

  configurePhase = ''
    patchShebangs wmake/w*
    patchShebangs wmake/scripts
    patchShebangs Allwmake

    echo "# Preferences for the environment
    export WM_COMPILER_TYPE=system
    export WM_MPLIB=SYSTEMOPENMPI
    export FOAM_EXTRA_CXXFLAGS='-std=c++14'
    # End" \
    > etc/prefs.sh

    ./bin/tools/foamConfigurePaths \
      -boost-path ${boost} \
      -cgal-path ${cgal} \
      -fftw-path ${fftw} \
      -metis-path ${parmetis} \
      -paraview-path ${paraview} \
      -scotch-path ${scotch} \
      ;
    '';

  buildPhase = ''
    export FOAM_CONFIG_MODE="o"
    unset FOAM_SETTINGS

    source ./etc/bashrc || echo "Ignore spurious sourcing error"

    ./Allwmake -j
    wclean all
    wmakeLnIncludeAll
    '';

  installPhase = ''
    [ -e ThirdParty ] || echo "system dependencies" >| ThirdParty

    install -d $out/opt/OpenFOAM/ThirdParty-v${version} $out/etc/profile.d
    cp -r $(pwd) $out/opt/OpenFOAM/OpenFOAM-v${version}
    chmod -R 755 $out/opt/OpenFOAM/OpenFOAM-v${version}/bin
    chmod 755 $out/opt/OpenFOAM/OpenFOAM-v${version}/etc/*

    install -d $out/bin
    echo 'echo $(readlink -f "$(dirname $0)/../opt/OpenFOAM/OpenFOAM-v${version}")' | \
      install -Dm755 /dev/stdin  $out/bin/openfoam-home.sh
    '';

  meta = with lib; {
    description = "The free, open source CFD software developed primarily by OpenCFD Ltd since 2004";
    homepage = "https://www.openfoam.com/";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}