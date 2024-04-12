#!/bin/bash

echo "deb [trusted=yes] https://apt.fury.io/versionfox/ /" | sudo tee /etc/apt/sources.list.d/versionfox.list

sudo apt update &&
    sudo apt install --no-install-recommends -y \
        graphviz \
        build-essential \
        automake \
        autoconf \
        libssl-dev \
        libffi-dev \
        libncurses5-dev \
        libedit-dev \
        unzip \
        cloc \
        vfox \
        jq

vfox add python
vfox install python@3.12.0
vfox use -g python@3.12.0
pip install pgcli
pip install "python-lsp-server[autopep8]"

vfox add golang
vfox install golang@1.22.2

if [ ! -d "$HOME/.asdf" ]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
  . "$HOME/.asdf/asdf.sh"
  . "$HOME/.asdf/completions/asdf.bash"
fi
asdf plugin-add erlang

asdf plugin-add elixir

asdf plugin-add rust
asdf install rust 1.79.0
cargo install --locked zellij
asdf reshim rust 1.79.0

if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  source ~/.bashrc
fi
