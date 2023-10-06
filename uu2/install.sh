#!/bin/bash

readonly CURRENT_DIR=$PWD

function run(){
    echo "Start: $1"
    source $1
    echo "End: $1"
}

cd $(dirname $0)
run 'scripts/apt.sh'
run 'scripts/clone.sh'
run 'scripts/asdf.sh'
run 'scripts/symlink.sh'

cd $CURRENT_DIR
