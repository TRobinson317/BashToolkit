#!/bin/bash

# Ask user for the directory
echo "Please enter the directory:"
read directory

# Verify the directory exists
if [ ! -d "$directory" ]; then
    echo "The directory does not exist."
    exit 1
fi

# Find duplicates
echo "Searching for duplicate files in $directory..."

# Create a temporary file to store md5 hash values
tmpfile=$(mktemp)

# Find all files in the directory, calculate their md5 hash and output the results to the temporary file
find "$directory" -type f -exec md5sum {} \; > "$tmpfile"

# Find duplicate hashes in the temporary file
duplicates=$(sort "$tmpfile" | uniq -w32 -d)

if [ -z "$duplicates" ]; then
    echo "No duplicate files found."
else
    echo "Duplicate files found:"
    echo "$duplicates"
fi

# Delete the temporary file
rm "$tmpfile"
