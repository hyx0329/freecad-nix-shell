# Reproducible FreeCAD Workspace with CFD Capability

Basically it's a nix-shell configuration of a FreeCAD environment with [CfdOF](https://github.com/jaheyns/CfdOF) installed.

## How to use

1. Install `nix`. Follow the instruction of your distro. Or you can follow [the instructions by nix official](https://nixos.org/download/).
    - For Arch users, simply `pacman -Sy nix`, and enable `nix-daemon` service.
1. Change working directory to here, the repository.
1. Open a new shell with `nix-shell freecad-cfd.nix`. Packages are built in this step.
1. In the new shell, install `CfdOF` plugin by executing the script `install-mod-cfdof.sh`
    - this script pins the module's git revision, making it reproducible
1. In console, run `freecad -t TestCfdOF`, and it will test the environment.
1. In console, run `freecad`, and enjoy your journey.
1. Later you don't need to run the steps above again, just change directory here and execute `start-cfd.sh`.
1. User data will be saved in `freecad-state`.

## How it works

- FreeCAD version is pinned with `nixpkgs` release.
    - Config path is changed with environment variables.
    - NEVER hard code ANY path in FreeCAD settings.
- OpenFOAM and related components which are not maintained in `nixpkgs` are built through local package definitions.
    - Versions are pinned by pinning source code version.
    - `cfmesh-cfdof` and `hisa` don't have versioned source code, and their code packages are relatively small, so the code packages are bundled.
- `CfdOF`'s version is pinned by git commit hash.
- `nixgl` is used to make UI working.

## Build time

My building platform: EPYC 7D12(1.1GHz, 32 core 64 threads) with 128G RAM.

- OpenFOAM: around 50 minutes, it looks not fully parallel
- cfmesh-cfdof: the script build it sequentially, about 15 minutes
- hisa: the script build it sequentially, about 14 minutes

The rest packages are provided by nixpkgs prebuilts.

## License

This project is licensed under the MIT license. The license doesn't apply to the bundled source code zips, which are licensed under GPL3.
