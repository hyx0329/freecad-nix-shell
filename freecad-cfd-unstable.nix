# freecad.nix
let
  # unstable
  nixpkgs_ball = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/master";
  nixgl_ball = fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz";

  # import the packages
  nixgl = import nixgl_ball {};
  pkgs = import nixpkgs_ball {
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };

  custompkgs = pkgs.callPackage (import ./custompkgs) { };
  openfoam = custompkgs.openfoam-2306;
  cfmesh = custompkgs.cfmesh-cfdof-unstable.override { openfoam = openfoam; };
  hisa = custompkgs.hisa-unstable.override { openfoam = openfoam; };
in

pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    pkgs.git
    pkgs.curl

    pkgs.freecad
    nixgl.nixGLIntel # Mesa OpenGL implementation (intel, amd, nouveau, ...).

    pkgs.calculix
    pkgs.elmerfem
    pkgs.gmsh
    pkgs.paraview

    openfoam
    cfmesh
    hisa
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=$(nixGLIntel printenv LD_LIBRARY_PATH):$LD_LIBRARY_PATH
    export FREECAD_USER_HOME=$(pwd)/freecad-state/home
    export FREECAD_USER_DATA=$(pwd)/freecad-state/userdata
    export FREECAD_USER_TEMP=$(pwd)/freecad-state/temp
    alias freecad='nixGLIntel freecad'
    source ${openfoam}/opt/OpenFOAM/OpenFOAM-v${openfoam.version}/etc/bashrc || true
    '';
}
