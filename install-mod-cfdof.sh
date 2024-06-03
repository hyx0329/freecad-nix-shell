# Install CfdOF to freecad-state/userdata/Mod/CfdOF

CFDOF_COMMIT=7bbd7b203cc96a8119717327dbdf94fe603917b5

[ ! -d freecad-state/userdata/Mod/CfdOF ] || { echo "CfdOF already installed"; exit 0; }

install -d freecad-state/userdata/Mod
git clone https://github.com/jaheyns/CfdOF freecad-state/userdata/Mod/CfdOF
pushd freecad-state/userdata/Mod/CfdOF
git checkout $CFDOF_COMMIT
popd
