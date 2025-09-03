# Usage: z <shortcut>
# Reads maps.txt

# TODO: rename z to zi and za

declare -A ZZ_MAPS
ZZ_PREV_DIR=$PWD

# load mappings once
while IFS='=' read -r key value; do
    if [ -z "$key" ] || [ -z "$value" ] || [ ! -d "$value" ]; then
        echo "invalid key or directory: $key=$value"
        continue
    fi
    case "$key" in  # not tested
        \#*) continue ;; # skip comments
    esac
    ZZ_MAPS[$key]=$value
    #echo "loaded: $key -> $value"
done < maps.txt

# similar to cd
# supports shortcut to go to mapped directories
# Note: there should not be spaces in keys or directories
z() {
    # parse options
    while getopts ":ha:" opt; do
        case $opt in
            a)
                shift 2     # shift past -a and its argument
                local newKey=$OPTARG
                # if a directory is taken as OPTARG,
                # it means key is not provided
                [ -z "$newKey" ] && echo "invalid key" && return 1
                [ -d "$newKey" ] && echo "missing key" && return 1
                # check target
                if [ -z "$1" ] || [ ! -d "$1" ]; then
                    echo "z: invalid target directory [$1]"
                    return 1
                fi

                if [ -n "${ZZ_MAPS[$newKey]}" ]; then # exists
                    # remove the entry from maps.txt
                    grep -v "^$newKey=" maps.txt > maps.tmp
                    mv maps.tmp maps.txt
                fi

                # expand to full path
                local fullPath=$(cd "$1" && pwd)
                echo "$newKey=$fullPath" >> maps.txt # for future
                ZZ_MAPS[$newKey]=$fullPath   # for current
                echo "Added mapping: $newKey -> $fullPath"

                # if returning here, not cd-ing this time
                # use another `z <key>` to go there
                #return
                ;;
            h)
                echo "Usage: z [shortcut/directory]"
                return 0
                ;;
            :)
                echo "z: Option -$OPTARG requires an argument."
                return 1
                ;;
            \?)
                echo "z: Invalid option: -$OPTARG"
                return 1
                ;;

        esac
    done
    # already handled above
    #shift $((OPTIND-1))

    
    if [ $# -eq 0 ]; then
        ZZ_PREV_DIR=$PWD; cd
    elif [ $# -eq 1 ]; then
        [ -d "$1" ] && ZZ_PREV_DIR=$PWD && cd $1 && return
        local there=${ZZ_MAPS[$1]}
        [ -n "$there" ] && ZZ_PREV_DIR=$PWD && cd $there && return
        echo "no such key or directory: $1"; return 1
    else
        echo "z: too many arguments"; return 1
    fi
}

zz() {
    cd $ZZ_PREV_DIR
}
