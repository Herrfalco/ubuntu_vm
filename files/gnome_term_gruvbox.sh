#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Applique Gruvbox à GNOME Terminal (profil par défaut) sans dconf (CLI).

Usage:
  ./gnome-terminal-gruvbox.sh --dark|--light [--profile-name "Nom"] [--font "Nom"] [--font-size N]
EOF
}

[[ $# -ge 1 ]] || { usage; exit 1; }

MODE=""; PROFILE_NAME=""; FONT=""; FONTSIZE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dark) MODE="dark"; shift ;;
    --light) MODE="light"; shift ;;
    --profile-name) PROFILE_NAME="${2-}"; shift 2 ;;
    --font) FONT="${2-}"; shift 2 ;;
    --font-size) FONTSIZE="${2-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Option inconnue: $1"; usage; exit 1 ;;
  esac
done

command -v gsettings >/dev/null || { echo "gsettings manquant (installe libglib2.0-bin)."; exit 1; }

UUID="$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")"
[[ -n "$UUID" ]] || { echo "Profil GNOME Terminal par défaut introuvable."; exit 1; }
BASE="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$UUID/"

if [[ "$MODE" == "dark" ]]; then
  BG="#282828"; FG="#ebdbb2"
  PALETTE="['#282828','#cc241d','#98971a','#d79921','#458588','#b16286','#689d6a','#a89984','#928374','#fb4934','#b8bb26','#fabd2f','#83a598','#d3869b','#8ec07c','#ebdbb2']"
elif [[ "$MODE" == "light" ]]; then
  BG="#fbf1c7"; FG="#3c3836"
  PALETTE="['#fbf1c7','#cc241d','#98971a','#d79921','#458588','#b16286','#689d6a','#7c6f64','#928374','#9d0006','#79740e','#b57614','#076678','#8f3f71','#427b58','#3c3836']"
else
  echo "Précise --dark ou --light"; exit 1
fi

gsettings set "$BASE" use-theme-colors false
gsettings set "$BASE" background-color "$BG"
gsettings set "$BASE" foreground-color "$FG"
gsettings set "$BASE" palette "$PALETTE"

gsettings set "$BASE" bold-color-same-as-fg true
gsettings set "$BASE" cursor-colors-set false
gsettings set "$BASE" highlight-colors-set false
gsettings set "$BASE" audible-bell false

[[ -n "$PROFILE_NAME" ]] && gsettings set "$BASE" visible-name "$PROFILE_NAME"

if [[ -n "$FONT" ]]; then
  gsettings set "$BASE" use-system-font false
  gsettings set "$BASE" font "$FONT ${FONTSIZE:-12}"
fi

echo "✅ Gruvbox ($MODE) appliqué. Profil: $UUID"
[[ -n "$FONT" ]] && echo "→ Police: $FONT ${FONTSIZE:-12}"

