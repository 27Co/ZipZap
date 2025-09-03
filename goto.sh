# Usage: z <shortcut>
# Reads maps.txt

# TODO: modify exiting mapping
# currently, -a an existing key does nothing
# because it doesn't enter the if block
# should add else

# TODO: rename z to zi and za

declare -A ZZ_MAPS
ZZ_PREV_DIR=$PWD

# load mappings once
while IFS='=' read -r key value; do
    if [ -z $key ] || [ -z $value ] || [ ! -d $value ]; then
        echo "invalid key or directory: $key=$value"
        continue
    fi
    case $key in
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
                [ -z $newKey ] && echo "invalid key" && return 1
                [ -d $newKey ] && echo "missing key" && return 1
                # add if new
                if [ -z ${ZZ_MAPS[$newKey]} ]; then # indeed new
                    # check target
                    if [ -z $1 ] || [ ! -d $1 ]; then
                        echo "z: invalid target directory [$1]"
                        return 1
                    fi
                    echo "$newKey=$1" >> maps.txt # for future
                    ZZ_MAPS[$newKey]=$1   # for current session
                    echo "Added mapping: $newKey -> $1"
                    # if returning here, not cd-ing this time
                    # use another `z <key>` to go there
                    #return
                fi
                # TODO: modify existing mapping
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
        [ -d $1 ] && ZZ_PREV_DIR=$PWD && cd $1 && return
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
