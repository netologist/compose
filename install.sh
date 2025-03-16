#!/bin/bash

set -e

compositions=($(curl -s https://raw.githubusercontent.com/netologist/docker-compose-templates/main/templates/.context))
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

if [ -f ./deployments/$compose/docker-compose.yaml ] || [ -f ./deployments/$compose/docker-compose.yml ]; then
    echo "docker-compose.yaml already exists. Do you want to overwrite it? (y/n)"
    read overwrite < /dev/tty
    if [ "$overwrite" != "y" ]; then
        echo "Aborted"
        exit 1
    fi
fi

echo "Copying $compose template..."

rm -f ./deployments/$compose || true

files=($(curl -s https://raw.githubusercontent.com/netologist/docker-compose-templates/main/templates/$compose/.context))
length=${#files[@]}

mkdir -p ./deployments/$compose
for ((i=1; i<=$length; i++)); do
    file=${files[$i-1]}
    curl -s https://raw.githubusercontent.com/netologist/docker-compose-templates/main/templates/$compose/$file > ./deployments/$compose/$file
done
