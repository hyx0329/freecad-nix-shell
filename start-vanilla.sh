cd $(readlink -e $(dirname "$0")) || { printf "%s\n" "Failed to change PWD to workspace!"; exit 1; }
exec nix-shell --command "./cmd.sh $(printf "%q " $@)" freecad.nix
