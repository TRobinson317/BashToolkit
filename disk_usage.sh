#!/bin/bash

# Ask the user for a directory
echo "Enter the directory:"
read directory

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "The directory does not exist."
    exit 1
fi

# Use du to calculate the disk usage of the directory
du -sh "$directory"
