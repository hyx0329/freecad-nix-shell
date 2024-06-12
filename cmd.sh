# Only when shellHook doesn't source the OpenFOAM's bashrc
if [ -z "$WM_PROJECT" ]; then
    FOAM_INST_DIR=$(openfoam-home.sh)
    [ -f "$FOAM_INST_DIR/etc/bashrc" ] && source $FOAM_INST_DIR/etc/bashrc
fi

# Create FreeCAD data directories if not present, or FreeCAD will use its defaults.
for i in FREECAD_USER_HOME FREECAD_USER_DATA FREECAD_USER_TEMP; do
    if [ -n "${!i}" ] && [ ! -d "${!i}" ]; then
        mkdir -p "${!i}"
    fi
done

exec nixGLIntel freecad $@
