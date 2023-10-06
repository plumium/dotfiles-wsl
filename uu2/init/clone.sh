#!/bin/bash

if [ ! -d ~/.asdf ]; then
    echo 'install asdf'
    git clone --branch v0.13.1 https://github.com/asdf-vm/asdf.git ~/.asdf
fi
