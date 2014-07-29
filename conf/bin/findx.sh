#!/bin/bash
echo "Finding files with execute bit enabled..."
find /home/darf -type f -perm -100 -exec chmod -x {} ';'
echo "Operation Completed...Testing..."
find /home/darf -type f -perm -100 -print
