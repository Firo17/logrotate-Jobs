#!/bin/bash

# two date arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <start_date> <end_date>"
    exit 1
fi

# Input date range
start_date="$1"
end_date="$2"

# Validate date format (dd-mm-yyyy)
if ! [[ "$start_date" =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ && "$end_date" =~ ^[0-9]{2}-[0-9]{2}-[0-9]{4}$ ]]; then
    echo "Invalid date format. Please use dd-mm-yyyy."
    exit 1
fi

# Directory for collected data
backup_dir="/var/backup"

# Create a directory with today's date
current_date=$(date '+%d-%b-%Y')
backup_dir="$backup_dir/recuperation-$current_date"

# Create the backup directory
mkdir -p "$backup_dir"


# Create a compressed archive of the collected data
tar -czvf "/var/backup/recuperation-$current_date.tar.gz" "$backup_dir"

# Clean up temporary directory
rm -rf "$backup_dir"

echo "Data retrieval completed and archived to /var/backup/recuperation-$current_date.tar.gz"

#grep command = current data 
#./script-recuperation.sh 10-03-2023 12-03-2023
