#!/bin/bash

readonly CURRENT_DIR=$PWD
readonly BACKUP_DIR="$HOME/dotfiles-wsl-backup"

echo_indent(){
    echo $1 | sed 's/^/  /'
}

if [ ! -d $BACKUP_DIR ]; then
    mkdir "$BACKUP_DIR"
    echo "create backup directory: $BACKUP_DIR"
fi

cd $(dirname $0)
for f in `find files -type f | sort`; do
    FILE_NAME=`basename $f`
    echo "create symlink to $FILE_NAME"
    # if exists old file
    if [ ! -z `find "$HOME/$FILE_NAME" -maxdepth 1 -type f` ]; then
        BACKUP_DEST="$BACKUP_DIR/$FILE_NAME"
        echo_indent "$FILE_NAME exists in $HOME"
        echo_indent "create backup to $BACKUP_DEST"
        mv "$HOME/$FILE_NAME" $BACKUP_DEST 
    fi
    TARGET="$PWD/$f"
    echo_indent "target: $TARGET"
    echo_indent "directory: $HOME" 
    ln -sf $TARGET $HOME
    echo -e "\n"
done

echo 'done'
cd $CURRENT_DIR