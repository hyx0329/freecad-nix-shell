# Only when shellHook doesn't source the OpenFOAM's bashrc
if [ -z "$WM_PROJECT" ]; then
    FOAM_INST_DIR=$(openfoam-home.sh)
    [ -f "$FOAM_INST_DIR/etc/bashrc" ] && source $FOAM_INST_DIR/etc/bashrc
fi

exec nixGLIntel freecad $@
