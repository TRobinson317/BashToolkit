#!/bin/bash

# Ask the user for a directory and a text to search for
echo "Enter the directory:"
read directory

echo "Enter the text to search for:"
read search_text

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "The directory does not exist."
    exit 1
fi

# Use grep to search for the text in all files in the directory
grep -r "$search_text" "$directory"
