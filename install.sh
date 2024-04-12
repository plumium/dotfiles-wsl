#!/bin/bash

function run() {
  echo "Start: $PWD/$1"
  . $1
  echo "End: $PWD/$1"
}

(
cd $(dirname $0)
run 'scripts/deps.sh'
run 'scripts/symlink.sh'
)
