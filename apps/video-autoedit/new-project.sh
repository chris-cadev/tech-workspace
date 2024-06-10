#!/bin/bash

# TODO: implement yamldirs https://pypi.org/project/yamldirs/

self=`readlink -f $(realpath "$0")`

while [[ $# -gt 0 ]]
do
    key="$1"
    
    case $key in
        -b|--base-dir)
            base_dir="$2"
            shift
            shift
        ;;
        -t|--template)
            template_file="$2"
            shift
            shift
        ;;
        -j|--json)
            json="$2"
            shift
            shift
        ;;
        *)
            echo "Unknown option: $1"
            exit 1
        ;;
    esac
done

if [ -z "$base_dir" ]; then
    echo "Base directory is required (-b or --base-dir)"
    exit 1
fi

template_file=${template_file:-"$HOME/lab/edition/projects/folder-structure.md"}
template_json="`cat $template_file | sed 's/---//g' | python -c 'import sys,yaml,json; print(json.dumps(yaml.safe_load(str(sys.stdin.read()))))'`"
json=${json:-"$template_json"}

key_values=`jq -r 'to_entries[] | (.key + "::::" + (if .value | type == "array" then (.value[] | tostring) elif .value | type == "object" then (.value | tojson) else "" end))' <<< "$json"`

for key_value in $key_values; do
    key=`echo "$key_value" | awk -F "::::" '{print $1}'`
    value=`echo "$key_value" | awk -F "::::" '{print $2}'`
    if [ -z "$value" ]; then
        mkdir -p "$base_dir/$key"
        elif [[ "$value" =~ ^\{.*\}$ ]]; then
        # recursive call
        "$self" --base-dir "$base_dir/$key" --json "$value"
        elif [ ! -z "$value" ]; then
        mkdir -p "$base_dir/$key/$value"
    fi
done