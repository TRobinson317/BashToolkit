#!/bin/bash

# Ask user for the operation
echo "Enter 'c' to compress files or 'd' to decompress a tarball:"
read operation

# Case 1: Compress files
if [[ "$operation" == "c" ]]; then
    echo "Enter the directory of files to compress:"
    read directory

    # Verify the directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory does not exist."
        exit 1
    fi

    echo "Enter the desired name for the tarball:"
    read tarname

    # Verify the tarball name is not empty
    if [ -z "$tarname" ]; then
        echo "The tarball name cannot be empty."
        exit 1
    fi

    tar -czf "$tarname.tar.gz" -C "$directory" . || {
        echo "An error occurred while compressing the files."
        exit 1
    }

# Case 2: Decompress tarball
elif [[ "$operation" == "d" ]]; then
    echo "Enter the tarball to decompress:"
    read tarball

    # Verify the tarball exists
    if [ ! -f "$tarball" ]; then
        echo "The tarball does not exist."
        exit 1
    fi

    echo "Enter the directory to decompress the tarball to:"
    read directory

    # Verify the directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory does not exist."
        exit 1
    fi

    tar -xzf "$tarball" -C "$directory" || {
        echo "An error occurred while decompressing the tarball."
        exit 1
    }

# Error: Invalid operation
else
    echo "Invalid operation. Please enter 'c' or 'd'."
    exit 1
fi

echo "Operation completed successfully."
