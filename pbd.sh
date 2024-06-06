#!/bin/bash
if ./push.sh; then
    echo "Pushed to GitHub, now deleting"
    cd ..
    rm -rf alfie-ns.github.io
    echo "Process complete"
else
    echo "Failed to push to GitHub"
fi