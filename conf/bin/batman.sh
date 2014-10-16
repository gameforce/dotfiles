#!/bin/zsh
dc=$(cat /proc/acpi/battery/C11F/info | grep 'last full' | awk ' { print $4 }')
rc=$(cat /proc/acpi/battery/C11F/state | grep 'remaining' | awk ' { print $3 } ')

p=$(echo 3k $rc $dc / 100 \* p | dc ) 
if grep -q discharging /proc/acpi/battery/C11F/state; then
    printf "%0.2g" "$p" 
else
        printf "%0.2g+" "$p" 
fi
