escape_slash() {
    echo $1 | sed 's/\//\\\//g'
}

replace_path() {
    echo $1 | sed "s/$(escape_slash $2)//"
}

backup_home_file() {
    if [ ! -f "$1" ]; then
        echo "$1 does not found"
        return 1
    fi
    local truncated_home_path=$(replace_path $1 $HOME/)
    local dest_file="$2/$truncated_home_path"
    local dest_dir=$(dirname $dest_file)
    if [ ! -d "$dest_dir" ]; then
        echo "create backup directory: $dest_dir"
        mkdir -p $dest_dir
    fi
    mv $1 $dest_file
    echo "backup: $1 -> $dest_file"
}

link_virtual_home() {
    local virtual_home_full_path="$PWD/virtualhome"
    if [ ! -d "$virtual_home_full_path" ]; then
        echo "virtualhome does not found in $PWD"
        return 1
    fi
    for f in $(find $virtual_home_full_path -type f -exec readlink -f {} + | sort); do
        local link_file="$(replace_path $f $virtual_home_full_path/)"
        local home_link_file="$HOME/$link_file"
        local home_link_dir="$(dirname $home_link_file)"
        if [ -f $home_link_file ] && [ "$(readlink $home_link_file)" != "$f" ]; then
            backup_home_file $home_link_file "$HOME/dotfiles-wsl-backup"
        fi
        if [ ! -d "$home_link_dir" ]; then
            mkdir -p "$home_link_dir"
        fi
        ln -sf $f $home_link_file
        echo "$home_link_file -> $f"
    done
}

link_virtual_home
