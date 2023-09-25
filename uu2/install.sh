#!/bin/bash

readonly CURRENT_DIR=$PWD

cd $(dirname $0)
source "scripts/apt.sh"
source "scripts/symlink.sh"

cd $CURRENT_DIR
