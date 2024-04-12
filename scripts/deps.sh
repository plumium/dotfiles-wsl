#!/bin/bash

echo "deb [trusted=yes] https://apt.fury.io/versionfox/ /" | sudo tee /etc/apt/sources.list.d/versionfox.list

sudo apt update &&
    sudo apt install --no-install-recommends -y \
        graphviz \
        build-essential \
        automake \
        autoconf \
        libssl-dev \
        libncurses5-dev \
        libedit-dev \
        unzip \
        cloc \
        vfox \
        jq

vfox add python
vfox add golang
vfox install python@3.12.0
vfox install golang@1.22.2

pip install pgcli
pip install "python-lsp-server[autopep8]"

if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
  . "$HOME/.asdf/asdf.sh"
  . "$HOME/.asdf/completions/asdf.bash"
fi
if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  source ~/.bashrc
fi

asdf plugin-add \
  erlang \
  elixir
