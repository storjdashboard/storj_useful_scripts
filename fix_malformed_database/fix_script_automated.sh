#!/bin/bash

# Disclaimer
echo "***********************************************************"
echo "* DISCLAIMER:                                             *"
echo "* This script is provided as-is with no warranties.       *"
echo "* The script originator takes no responsibility for any   *"
echo "* damage that may occur to the databases during its use.  *"
echo "* Use at your own risk.                                   *"
echo "***********************************************************"
echo

# Prompt for acknowledgment
read -p "Do you acknowledge and accept the disclaimer? (yes/no): " response
if [[ $response != "yes" ]]; then
    echo "You did not accept the disclaimer. Exiting script."
    exit 1
fi

# Function to prompt for input
prompt() {
    read -p "$1" response
    echo $response
}

# Prompting for necessary inputs
db_directory=$(prompt "Enter the directory containing the SQLite database files: ")
backup_directory=$(prompt "Enter the directory where you want to save backups: ")
fixed_db_directory=$(prompt "Enter the directory where you want to save the fixed databases: ")

# Check if sqlite3 is installed
if ! command -v sqlite3 &> /dev/null; then
    echo "sqlite3 could not be found. Please install it before running this script."
    exit 1
fi

# Creating directories if they do not exist
mkdir -p "$backup_directory"
mkdir -p "$fixed_db_directory"

# Function to fix a single database
fix_database() {
    local db_path=$1
    local db_filename=$(basename "$db_path")
    local backup_path="$backup_directory/$db_filename.bak"
    local fixed_db_path="$fixed_db_directory/$db_filename"

    echo "Checking integrity of $db_path..."
    integrity_check=$(sqlite3 "$db_path" "PRAGMA integrity_check;")

    if [[ $integrity_check != "ok" ]]; then
        echo "Integrity check failed for $db_path. Attempting to fix..."

        # Backing up the original database
        echo "Backing up the original database..."
        cp "$db_path" "$backup_path"
        if [ $? -ne 0 ]; then
            echo "Failed to backup the database $db_path."
            return 1
        fi

        # Clear any existing dump.sql file
        rm -f dump.sql

        # Exporting the database to SQL
        echo "Exporting the database to SQL..."
        sqlite3 "$db_path" ".mode insert" ".output dump.sql" ".dump"
        if [ $? -ne 0 ]; then
            echo "Failed to export the database $db_path. It may be too corrupted."
            return 1
        fi

        # Creating a new database from the SQL dump
        echo "Creating a new database from the SQL dump..."
        sqlite3 "$fixed_db_path" < dump.sql
        if [ $? -ne 0 ]; then
            echo "Failed to create the new database $db_path."
            return 1
        fi

        # Cleaning up
        echo "Cleaning up..."
        rm dump.sql

        echo "The database $db_path has been successfully fixed and saved to $fixed_db_path"
    else
        echo "The database $db_path is not malformed."
    fi
}

# Cycle through each .db file in the directory
for db_file in "$db_directory"/*.db; do
    if [ -f "$db_file" ]; then
        fix_database "$db_file"
    fi
done

echo "All databases have been processed."
