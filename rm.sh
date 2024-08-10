#!/bin/bash
if bash pu.sh; then
    cd ..
    rm -rf alfie-ns.github.io
    echo -e "\nLocal repo removed\n"
fi





