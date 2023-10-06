#!/bin/bash

sudo apt update &&
    sudo apt install --no-install-recommends -y \
        git-lfs \
        pgcli \
        graphviz \
        build-essential \
        autoconf \
        libncurses5-dev
