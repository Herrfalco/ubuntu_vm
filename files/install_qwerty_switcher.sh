#!/usr/bin/env bash

set -eou pipefail

curl -L "https://raw.githubusercontent.com/Herrfalco/arch_utils/refs/heads/main/scripts/qwerty_switcher.py" > ~/.local/share/qwerty_switcher.py
chmod 700 ~/.local/share/qwerty_switcher.py
ln -s ~/.local/share/qwerty_switcher.py ~/.local/bin/qwerty_switcher
