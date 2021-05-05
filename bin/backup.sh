#!/bin/bash
rsync -vaz --delete --exclude=Desktop --exclude=.* --exclude=Applications --exclude=Downloads --exclude=Dropbox --exclude=Library --exclude=Public --exclude=Gentoo --exclude=Sites --exclude=Documents/Parallels --exclude=Documents/.* --rsh="ssh -l ngotsinas" ~/ ventress:~/
