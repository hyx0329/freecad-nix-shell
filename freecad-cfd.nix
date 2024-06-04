# freecad.nix
let
  # unstable
  # nixpkgs_ball = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/master";
  # nixgl_ball = fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz";
  # pinned
  # use this to get hash: nix-prefetch-url --unpack url
  nixpkgs_ball = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/tarball/nixos-24.05";
    sha256 = "1q7y5ygr805l5axcjhn0rn3wj8zrwbrr0c6a8xd981zh8iccmx0p";
  };
  nixgl_ball = fetchTarball {
    url = "https://github.com/nix-community/nixGL/tarball/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
    sha256 = "1crnbv3mdx83xjwl2j63rwwl9qfgi2f1lr53zzjlby5lh50xjz4n";
  };

  # import the packages
  nixgl = import nixgl_ball {};
  pkgs = import nixpkgs_ball {
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };

  # some bug hotfix, only for freecad 0.21.2
  freecad-patched = pkgs.freecad.overrideAttrs (finalAttrs: previousAttrs: {
      patches = previousAttrs.patches ++ [ 
          ./patches/0001-Fem-fix-searching-3rd-party-binaries-in-system-path.patch
       ]; 
    });

  custompkgs = pkgs.callPackage (import ./custompkgs) { };
  openfoam = custompkgs.openfoam-2306;
  cfmesh = custompkgs.cfmesh-cfdof.override { openfoam = openfoam; };
  hisa = custompkgs.hisa.override { openfoam = openfoam; };
in

pkgs.mkShell {
  buildInputs = [
    pkgs.python3
    pkgs.git
    pkgs.curl

    nixgl.nixGLIntel # Mesa OpenGL implementation (intel, amd, nouveau, ...).

    # pkgs.freecad
    freecad-patched

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
