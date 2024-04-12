cyan(){
  echo "\e[1;36m$1\e[m"
}

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

link_home() {
    local home_full_path="$PWD/home"
    if [ ! -d "$home_full_path" ]; then
        echo "home does not found in $PWD"
        return 1
    fi
    for f in $(find $home_full_path -type f -exec readlink -f {} + | sort); do
        local link_file="$(replace_path $f $home_full_path/)"
        local home_link_file="$HOME/$link_file"
        local home_link_dir="$(dirname $home_link_file)"
        if [ -f $home_link_file ] && [ "$(readlink $home_link_file)" != "$f" ]; then
            backup_home_file $home_link_file "$HOME/dotfiles-wsl-backup"
        fi
        if [ ! -d "$home_link_dir" ]; then
            mkdir -p "$home_link_dir"
        fi
        ln -sf $f $home_link_file
        echo -e "$(cyan $home_link_file) -> $f"
    done
}

link_home
