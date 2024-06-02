#!/bin/bash #shebang
./push.sh # 0. push changes
cd .. # 1. Back out of dir
rm -rf alfie-ns.github.io  # 2. delete repo 
killall code # 3.  quit/kill code

