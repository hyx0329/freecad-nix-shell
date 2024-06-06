# Install CfdOF to freecad-state/userdata/Mod/CfdOF

CFDOF_COMMIT=96d6e5acdabe6bf750456e144593ee264d0c45c2

[ ! -d freecad-state/userdata/Mod/CfdOF ] || { echo "CfdOF already installed"; exit 0; }

install -d freecad-state/userdata/Mod
git clone https://github.com/jaheyns/CfdOF freecad-state/userdata/Mod/CfdOF
pushd freecad-state/userdata/Mod/CfdOF
git checkout $CFDOF_COMMIT
popd
