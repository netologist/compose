#!/bin/bash

set -e

compositions=()
for fullpath in templates/*; do 
    filename=$(basename -- "$fullpath"); 
    compositions+=("${filename%.*}")
done

echo "${compositions[@]}" > templates.txt
echo "Templates list saved to templates.txt"