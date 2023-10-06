#!/bin/bash

readonly CURRENT_DIR=$PWD

function run(){
    echo "Start: $1"
    source $1
    echo "End: $1"
}

cd $(dirname $0)
run 'init/apt.sh'
run 'init/clone.sh'
run 'init/asdf.sh'
run 'init/symlink.sh'

cd $CURRENT_DIR
