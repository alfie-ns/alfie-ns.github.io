#!/bin/bash
if bash pu.sh; then
    cd ..
    rm -rf alfie-ns.github.io
    echo ""
    echo "Local repo removed"
fi





