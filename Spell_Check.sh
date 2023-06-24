#!/bin/bash

# Ask user for the directory
echo "Please enter the directory:"
read directory

# Verify the directory exists
if [ ! -d "$directory" ]; then
    echo "The directory does not exist."
    exit 1
fi

# Iterate over all text files in the directory
for file in "$directory"/*.txt; do
    echo "Checking $file"
    misspelled=$(aspell list < "$file")
    if [ -z "$misspelled" ]; then
        echo "No misspelled words in $file"
    else
        echo "Misspelled words in $file:"
        echo $misspelled
    fi
done
