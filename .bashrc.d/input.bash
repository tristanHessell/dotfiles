# put any commands here that you are related to input devices

# get the xinput id of the keyboard stick
id=$(xinput list | grep "DualPoint Stick" | awk -F$'\t' '{print $2}' | awk -F= '{print $2}')

echo $id

# disable aforementioned keyboard stick
xinput set-prop $id "Device Enabled" 0
