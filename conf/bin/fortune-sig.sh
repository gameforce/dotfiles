#!/bin/bash
echo '--' >> signature.tag
echo 'darf <darf@gameforce.ca>' >> signature.tag
echo 'gameforce.ca admin'  >> signature.tag 
echo '--' >> signature.tag
echo '                                                      '  >> signature.tag 
echo `/usr/bin/fortune -n 150 -s politics`  >> signature.tag
cat signature.tag
