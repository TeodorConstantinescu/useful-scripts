#!/bin/bash

# Recursively creates .gitignore files in the parent directory
# of the script and all its subfolders wherever they are not
# already present

# Credits to Rareș Onț for the first version

convert_to_unix_path() {
    local path="$1"
    # Convert backslashes to forward slashes
    path="${path//\\//}"
    # Remove leading slash if present
    path="${path#/}"
    # Convert drive letter to lowercase and add a forward slash after the drive letter
    path="/${path:0:1}/${path:2}"
    echo "$path"
}

# Function to create .gitignore file
create_gitignore() {
	local dir="$1"
	
	# Convert Windows path to Unix-style path
    dir=$(convert_to_unix_path "$dir")
	
    # Check if directory already contains a .gitignore file
    if [ -e "$dir/.gitignore" ]; then
		local test=test
        echo ".gitignore file already exists in $dir"
		filesAlreadyThere=$(($filesAlreadyThere+1))
	else
        touch "$dir/.gitignore"
        echo ".gitignore file created in $dir"
		filesCreated=$(($filesCreated+1))
    fi
}

# Main function to traverse directories
traverse_directories() {
    local dir="$1"

	# Set IFS to newline to handle spaces in directory names
    IFS=$'\n'
	local dirs=$(find "$dir" -type d -not -path "*/.gitignore*" -not -path '*/.*')
    
   
    for d in $dirs; do
        create_gitignore "$d"
    done
	
	unset IFS
}

# Get script parent directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
filesAlreadyThere=0
filesCreated=0

echo "Will start creating .gitignore files within the following folder and all its subfolders: \"$SCRIPT_DIR\""
echo "Do you want to continue? (y/n)"
read answer

if [ "$answer" == "y" ]; then
    # Start traversing from the current directory
	traverse_directories "$SCRIPT_DIR"
	echo "Created $filesCreated files and $filesAlreadyThere files were already created."
elif [ "$answer" == "n" ]; then
    echo "Aborted."
else
    echo "Invalid input, aborted."
fi

echo "Press any key to continue..."
read answer