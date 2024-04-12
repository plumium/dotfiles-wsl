#!/bin/bash

readonly CURRENT_DIR=$PWD

function run() {
    echo "Start: $1"
    . $1
    echo "End: $1"
}

cd $(dirname $0)

run 'scripts/deps.sh'
run 'scripts/symlink.sh'

cd $CURRENT_DIR
