#!/bin/bash
#~/.local/bin/lefty-mouse.sh

MOUSE_NAME="YICHIP Wireless Device Mouse"

if xinput list --name-only | grep -q "$MOUSE_NAME"; then
    ID=$(xinput list --id-only "$MOUSE_NAME")
    xinput set-button-map "$ID" 3 2 1
fi
