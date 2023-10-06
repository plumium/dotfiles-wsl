#!/bin/bash

readonly BACKUP_DIR="$HOME/dotfiles-wsl-backup/"

if [ ! -d $BACKUP_DIR ]; then
    mkdir "$BACKUP_DIR"
    echo "create backup directory: $BACKUP_DIR"
fi

echo_indent() {
    echo $1 | sed 's/^/  /'
}

has_parent_directory() {
    [ $(dirname $1) != '.' ]
}

create_home_path() {
    if has_parent_directory $1; then
        echo "$HOME/$(dirname $1)/$(basename $1)"
    else
        echo "$HOME/$(basename $1)"
    fi
}

is_linked(){
    [ -L $1 ] && [ $(readlink $1) == $(realpath $2) ]
}

for f in $(find virtualhome -type f | sort); do
    relativePath=$(echo $f | cut -d / -f 2-)
    dest=$(create_home_path $relativePath)
    if ! $(is_linked $dest $f); then
        if [ -f $dest ]; then
            destBackupDir=$(dirname "$BACKUP_DIR/$relativePath")
            if has_parent_directory $relativePath && [ ! -d $destBackupDir ]; then
                echo_indent "create backup directory: $destBackupDir"
                mkdir -p $destBackupDir
            fi
            destBackupFile="$destBackupDir/$(basename $f)"
            echo_indent "backup: $dest -> $destBackupFile"
            cp -L $dest $destBackupFile
        fi
        fullSource="$PWD/$f"
        echo_indent "link: $dest -> $fullSource"
        ln -sf $fullSource $dest
        echo ''
    fi
done
