#!/bin/bash

#argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# For username
username="$1"

# Backup directory
backup_dir="/var/backup"

#backup directory for the user if it doesn't exist
mkdir -p "$backup_dir"

#date
current_date=$(date +%d-%b-%Y)

# backup filename
backup_filename="$backup_dir/${username}-backup-${current_date}.tar.gz"

# Define the user's home directory
user_home_dir="/home/$username"

#  temporary directory for the backup
temp_dir=$(mktemp -d)

# Archive files for the last 7 days
find "$user_home_dir" -type f -ctime -7 -exec cp {} "$temp_dir" \;

# Archive files modified more than 7 days ago
find "$user_home_dir" -type f -mtime +7 -exec cp {} "$temp_dir" \;

# Archive directories with content > 10MB
find "$user_home_dir" -type d -exec du -sm {} + | awk '$1 > 10' | cut -f2- | while read -r dir; do
  cp -r "$dir" "$temp_dir"
done

# Archive hidden files and directories
shopt -s dotglob
cp -r "$user_home_dir"/.[^.]* "$temp_dir"

# Create the final tar.gz archive
tar -czvf "$backup_filename" -C "$temp_dir" .

# Clean up temporary directory
rm -r "$temp_dir"

# Restrict permissions to the user
chmod 600 "$backup_filename"

# Display completion message
echo "Backup of $username completed and stored in $backup_filename"

#use dos2unix first and after run the script