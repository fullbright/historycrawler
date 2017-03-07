#!/bin/bash
####################################
#
# Backup to NFS mount script.
#
####################################
# Inpired from :
# https://help.ubuntu.com/lts/serverguide/backup-shellscripts.html

# What to backup. 
backup_files="/var/spool/mail /etc /root /boot /opt"

# Where to backup to.
dest="/mnt/backup"

# Create archive filename.
day=$(date +%A)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"
date
echo

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files

# Backup docker containers if any
echo "Backup docker containers if any"
if which docker; then
    echo "Docker - Backing up the web data"
    docker run --rm --volumes-from my_webdata -v $dest:/backup ubuntu tar cvf /backup/backup-webdata-$(hostname)-$(date +%A).tar /var/www/html
    echo "Docker - Backup finished"
    
    echo "Docker - Backing up the mysql database"
    docker run --rm --volumes-from my_datastore -v $dest:/backup ubuntu tar cvf /backup/backup-mysql-$(hostname)-$(date +%A).tar /var/lib/mysql
    echo "Docker - Backup finished."
else
    echo "Docker executable not found."
fi
echo "End of docker backup"

# Print end status message.
echo
echo "Backup finished"
date

# Long listing of files in $dest to check file sizes.
ls -lh $dest
