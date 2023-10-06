#!/bin/bash

function add(){
    for n in $@; do
        asdf plugin-add $n
    done
}

add erlang \
    elixir \
    java
