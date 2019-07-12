#!/bin/sh
clear && printf '\e[3J' && printf '\033[0;0H'
cd $(dirname $0)
if [[ ! -f debug.txt ]]; then touch debug.txt; fi
tail -f debug.txt

exit


