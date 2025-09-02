# Usage: z <shortcut>
# Reads maps.txt

declare -A ZZ_MAPS
ZZ_PREV_DIR="$PWD"

# load mappings once
while IFS='=' read -r key value; do
    echo "key: $key, value: $value"
    [ -z "$key" ] && continue
    [ -z "$value" ] && continue
    [ ! -d "$value" ] && echo "$value is not a directory" && continue
    case "$key" in \#*) continue ;; esac    # skip comments
    ZZ_MAPS["$key"]="$value"
done < "maps.txt"

# similar to cd
# supports shortcut to go to mapped directories
z() {
    if [ $# -eq 0 ]; then
        ZZ_PREV_DIR="$PWD";cd
    elif [ $# -eq 1 ]; then
        local there=${ZZ_MAPS[$1]}
        [ ! -z "$there" ] && ZZ_PREV_DIR="$PWD"&&cd "$there" && return
        [ ! -d "$1" ] && echo "z: no such key or directory: $1" && return 1
        ZZ_PREV_DIR="$PWD";cd "$1"
    else
        echo "Usage: z [shortcut/directory]"
        return 1
    fi
}

zz() {
    cd "$ZZ_PREV_DIR"
}
