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

for source in $(find virtualhome -type f | sort); do
    echo "create symlink for $source"
    relativeSource=$(echo $source | cut -d / -f 2-)
    destFile=$(create_home_path $relativeSource)
    if [ -f $destFile ]; then
        destBackupDir=$(dirname "$BACKUP_DIR/$relativeSource")
        if has_parent_directory $relativeSource && [ ! -d $destBackupDir ]; then
            echo_indent "create backup directory: $destBackupDir"
            mkdir -p $destBackupDir
        fi
        destBackupFile="$destBackupDir/$(basename $source)"
        echo_indent "backup: $destFile -> $destBackupFile"
        cp -L $destFile $destBackupFile
    fi
    fullSource="$PWD/$source"
    echo_indent "link: $destFile -> $fullSource"
    ln -sf $fullSource $destFile
    echo -e '\n'
done

echo 'done'
