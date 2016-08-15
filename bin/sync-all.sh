#!/bin/sh
# update all repos

cd /var/www/html
for i in ls | grep sync; do sh $i; done
