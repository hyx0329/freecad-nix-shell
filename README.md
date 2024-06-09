# Reproducible FreeCAD Workspace with CFD Capability

![Nix and FreeCAD and FEM and CFD](nix-freecad-fem-cfd.svg)

This project aims to ease the environment setup for FreeCAD CfdOF workbench.

Basically it's a nix-shell configuration of a FreeCAD environment with [CfdOF](https://github.com/jaheyns/CfdOF) installed.

> By the time I finished this project, I found [preCICE adapters and solvers packaged with the Nix package manager](https://github.com/precice/nix-packages) which has a simliar goal(reproducibility). That's a flakes repository for NixOS.

## How to use

1. Install `nix`. Follow the instruction of your distro. Or you can follow [the instructions by nix official](https://nixos.org/download/).
    - For Arch users, simply `pacman -Sy nix`, and enable `nix-daemon` service.
1. Change working directory to here, the repository.
1. Open a new shell with `nix-shell freecad-cfd.nix`. Packages are built in this step. This is the way to launch an interactive shell, and normally the packages are built only once.
1. In the new shell, install `CfdOF` plugin by executing the script `install-mod-cfdof.sh`
    - this script pins the module's git revision, making it reproducible
1. (Optional) In console, run `freecad -t TestCfdOF`, and it will test the workbench.
1. In console, run `freecad`, and enjoy your journey.
1. (Optional) To further test the environment, you need to load a demo from CfdOF, and run the calculation.
    - In some cases, testing a single demo cannot ensure everything works.
1. Later you don't need to run the steps above again if you want to launch FreeCAD directly, just change directory here and execute `start-cfd.sh`. The script will pass the arguments to FreeCAD.
1. User data will be saved in `freecad-state`.

## How it works

- FreeCAD version is pinned with `nixpkgs` release.
    - Config path is changed with environment variables.
        - Warning: NEVER hard code ANY path in FreeCAD settings.
- OpenFOAM and related components which are not maintained in `nixpkgs` are built through local package definitions.
    - Versions are pinned by pinning source code version.
    - `cfmesh-cfdof` and `hisa` don't have versioned source code, and their code packages are relatively small, so the code packages are bundled.
- `CfdOF`'s version is pinned by git commit hash.
- `nixgl` is used to make UI working.

## Build time

My building platform: EPYC 7D12(1.1GHz, 32 core 64 threads) with 128G RAM.

- FreeCAD: about 10 minutes
- OpenFOAM: around 50 minutes, it looks not fully parallel
- cfmesh-cfdof: the scripts build it sequentially, about 15 minutes
- hisa: the scripts build it sequentially, about 14 minutes
- parmetis and scotch are rebuilt for their dynamic linking libraries, and these shouldn't take long time to build

The rest packages are provided by nixpkgs prebuilts.

## Q&A

### Why does FreeCAD need a rebuild?

As of FreeCAD 0.21.2, the FEM workbench has a bug that prevents correct detection of solvers in system path.
If you don't need this patch or don't want to rebuild, just comment out `freecad-patched` and uncomment `pkgs.freecad` in `freecad-cfd.nix`.

## Credits

- [CfdOF](https://github.com/jaheyns/CfdOF)
- [AUR openfoam-org](https://aur.archlinux.org/packages/openfoam-org)
- [AUR openfoam-com](https://aur.archlinux.org/packages/openfoam-com)
- [AUR scotch](https://aur.archlinux.org/packages/scotch)
- [AUR parmetis-git](https://aur.archlinux.org/packages/parmetis-git)

## License

This project is licensed under the MIT license.
The license doesn't apply to the bundled source code zips(cfmesh, hisa), which are licensed under GPL3.
