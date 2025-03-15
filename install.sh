#!/bin/bash

# set -e

if [ -f docker-compose.yaml ] || [ -f docker-compose.yml ]; then
    echo "docker-compose.yaml already exists. Do you want to overwrite it? (y/n)"
    read overwrite < /dev/tty
    if [ "$overwrite" != "y" ]; then
        echo "Aborted"
        exit 1
    fi
fi

compositions=()
for fullpath in templates/*; do 
    filename=$(basename -- "$fullpath"); 
    compositions+=("${filename%.*}")
done
length=${#compositions[@]}

echo ""
echo "Available templates:"

for ((i=1; i<=$length; i++)); do
    echo "$i) ${compositions[$i-1]}"
done

echo ""
echo "Enter the number of the template you want to install:"
read number < /dev/tty

# Check if input is a valid integer
if ! [[ "$number" =~ ^[0-9]+$ ]]; then
    echo "Error: Not a valid number"
    exit 1
fi

# Now check range with valid integer
if [ "$number" -lt 1 ] || [ "$number" -gt "$length" ]; then
    echo "Invalid number: out of range"
    exit 1
fi

compose=${compositions[$number-1]}
echo "Copying $compose template..."

rm -f docker-compose.yml || true
curl -s https://raw.githubusercontent.com/netologist/docker-compose-templates/main/templates/$compose.yaml > docker-compose.yaml