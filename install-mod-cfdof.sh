# Install CfdOF to freecad-state/userdata/Mod/CfdOF

CFDOF_COMMIT=5816daf1c5efcf51af8eb7d9c7e3138f7d7d1531

[ ! -d freecad-state/userdata/Mod/CfdOF ] || { echo "CfdOF already installed"; exit 0; }

install -d freecad-state/userdata/Mod
git clone https://github.com/jaheyns/CfdOF freecad-state/userdata/Mod/CfdOF
pushd freecad-state/userdata/Mod/CfdOF
git checkout $CFDOF_COMMIT
popd
