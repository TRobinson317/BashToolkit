#!/bin/bash

spell_check() {
    # Ask user for the directory
    echo "Please enter the directory:"
    read directory

    # Verify the directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory does not exist."
        return 1
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
}

find_duplicates() {
    # Ask user for the directory
    echo "Please enter the directory:"
    read directory

    # Verify the directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory does not exist."
        return 1
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
}

compress_decompress() {
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
            return 1
        fi

        echo "Enter the desired name for the tarball:"
        read tarname

        # Verify the tarball name is not empty
        if [ -z "$tarname" ]; then
            echo "The tarball name cannot be empty."
            return 1
        fi

        tar -czf "$tarname.tar.gz" -C "$directory" . || {
            echo "An error occurred while compressing the files."
            return 1
        }

    # Case 2: Decompress tarball
    elif [[ "$operation" == "d" ]]; then
        echo "Enter the tarball to decompress:"
        read tarball

        # Verify the tarball exists
        if [ ! -f "$tarball" ]; then
            echo "The tarball does not exist."
            return 1
        fi

        echo "Enter the directory to decompress the tarball to:"
        read directory

        # Verify the directory exists
        if [ ! -d "$directory" ]; then
            echo "The directory does not exist."
            return 1
        fi

        tar -xzf "$tarball" -C "$directory" || {
            echo "An error occurred while decompressing the tarball."
            return 1
        }

    # Error: Invalid operation
    else
        echo "Invalid operation. Please enter 'c' or 'd'."
        return 1
    fi

    echo "Operation completed successfully."
}

text_search() {
    # Ask the user for a directory and a text to search for
    echo "Enter the directory:"
    read directory

    echo "Enter the text to search for:"
    read search_text

    # Check if the directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory does not exist."
        return 1
    fi

    # Use grep to search for the text in all files in the directory
    grep -r "$search_text" "$directory"
}

calculate_disk_usage() {
    # Ask the user for a directory
    echo "Enter the directory:"
    read directory

    # Check if the directory exists
    if [ ! -d "$directory" ]; then
        echo "The directory does not exist."
        return 1
    fi

    # Use du to calculate the disk usage of the directory
    du -sh "$directory"
}

echo "Please choose an option:"
echo "1. Spell Check"
echo "2. Find Duplicate Files"
echo "3. Compress/Decompress Files"
echo "4. Text Search"
echo "5. Calculate Disk Usage"
read option

case $option in
    1) 
    spell_check
    ;;
    2) 
    find_duplicates
    ;;
    3) 
    compress_decompress
    ;;
    4) 
    text_search
    ;;
    5) 
    calculate_disk_usage
    ;;
    *) 
    echo "Invalid option."
    ;;
esac
