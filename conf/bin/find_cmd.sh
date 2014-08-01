#!/bin/bash

find /misc/ds?/SandBoxes/*/Scripts/Admin -type d |
while read dir; do
    if [ ! -f $dir/SiteConfiguration.py ]; then
	ls -R $dir > /home/ngotsinas/docs/sandboxes.txt
    fi
done
