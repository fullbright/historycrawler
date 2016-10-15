#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################

dest="/mnt/backup"
# List the content of the archive
latestbackup=$(ls -t $dest | head 1)
tar -tzvf $latestbackup

# What to restore. 
echo "Use this command to restore a file you are seing in the archive to it's destination"
echo "tar -xzvf /mnt/backup/host-Monday.tgz -C /tmp etc/hosts"
echo "The -C option to tar redirects the extracted files to the specified directory. The above example will extract the /etc/hosts file to /tmp/etc/hosts. tar recreates the directory structure that it contains."
echo "Also, notice the leading "/" is left off the path of the file to restore."

echo "This script must be improved."
