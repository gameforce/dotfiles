#!/bin/sh
# update all repos

cd /srv/repo
for i in ls | grep sync; do sh $i; done
