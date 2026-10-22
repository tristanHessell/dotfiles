# put any commands here that you are related to input devices

# Disable the keyboard stick when xinput can find it.
if command -v xinput >/dev/null 2>&1; then
  id=$(xinput list --id-only "DualPoint Stick" 2>/dev/null | head -n 1)
  if [[ -n $id ]]; then
    xinput set-prop "$id" "Device Enabled" 0
  fi
fi
