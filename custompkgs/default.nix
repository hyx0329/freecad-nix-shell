{ pkgs }:
let
  parmetis-shared = pkgs.callPackage (import ./parmetis-shared) { };
  scotch-shared = pkgs.callPackage (import ./scotch-shared) { };
  openfoam-2306 = pkgs.callPackage (import ./openfoam) { parmetis = parmetis-shared; scotch = scotch-shared; };
  openfoam-2312 = openfoam-2306.override { version = "2312"; hash = "0wgfyz4q7xr0vlv4znfxpxyp8jb53q5pl17k312dyb3x8gkdx2z4"; };
  cfmesh-cfdof = pkgs.callPackage (import ./cfmesh-cfdof) { openfoam = openfoam-2306; };
  hisa = pkgs.callPackage (import ./hisa) { openfoam = openfoam-2306; };
  cfmesh-cfdof-unstable = cfmesh-cfdof.override { version = "unstable"; };
  hisa-unstable = hisa.override { version = "unstable"; };
in {
  inherit openfoam-2306 openfoam-2312;
  inherit cfmesh-cfdof hisa;
  inherit cfmesh-cfdof-unstable hisa-unstable;
}