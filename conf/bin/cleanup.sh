#!/bin/bash
echo "Removing files in /var/tmp/portage/ ..."
sudo rm -rf /var/tmp/portage/*
echo "Done."
echo "Removing files in /var/tmp/ccache/ ..."
sudo rm -rf /var/tmp/ccache/*
echo "Done."
echo "Removing files in /var/tmp/binpkgs/* ..."
sudo rm -rf /var/tmp/binpkgs/*
echo "Done."
echo "Removing files in /usr/portage/distfiles/* ..."
sudo rm -rf /usr/portage/distfiles/*
echo "Done."
echo "Removing files in /tmp/* ..."
sudo rm -rf /tmp/*
echo "Done."
