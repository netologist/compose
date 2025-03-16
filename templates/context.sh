#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

compositions=()
for fullpath in *; do
    name=$(basename -- "$fullpath");
    if [ -d "$name" ]; then
        compositions+=("${name%.*}")

        if [ -f "$name/docker-compose.yaml" ]; then
            context=()
            shopt -s dotglob
            for file in $name/*; do
                f=$(basename -- "$file");
                if [ "$f" == ".context" ]; then
                    continue
                fi
                context+=("$f")
            done
            echo "${context[@]}" > $name/.context
        fi
    fi
done

echo "${compositions[@]}" > $SCRIPT_DIR/.context
echo "Templates list saved to $SCRIPT_DIR/.context"