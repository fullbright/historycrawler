#!/bin/bash

echo *************************************
echo **                           	    **
echo ** 	HISTORY CRAWLER		        **
echo ** 	Install tools		        **
echo ** 				                **
echo *************************************

#CURRENT_USER=$(whoami)
#CURRENT_USER="pi"
if [ -n "$1" ]; then CURRENT_USER=$1; else CURRENT_USER="pi"; fi

echo "Current user is $CURRENT_USER"

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi


echo "Update the repository"
apt-get update --yes
apt-get upgrade --yes

echo "Install git first"
apt-get install git curl -y

echo "Install ssh, python, pip, byobu"
apt-get install ssh python python-pip byobu -y

echo "The install vim and the awesome vimrc"
# awesome vimrc requires ctags
apt-get install vim -y
apt-get install ctags -y
apt-get install aptitude -y

git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

git clone https://github.com/fullbright/bash_awesome.git ~/.bash_awesome
sh ~/.bash_awesome/install_awesome_bash.sh

echo "Adding customiations to vim awesome"
echo "colorscheme mayansmoke" >> ~/.vim_runtime/my_configs.vim
echo "colorscheme peaksea" >> ~/.vim_runtime/my_configs.vim
echo "set paste" >> ~/.vim_runtime/my_configs.vim
echo "set number" >> ~/.vim_runtime/my_configs.vim
echo "set tabstop=4 shiftwidth=4 expandtab" >> ~/.vim_runtime/my_configs.vim

echo "Give .vim_runtime folder ownership to $CURRENT_USER user"
chown $CURRENT_USER:$CURRENT_USER ~/.vim_runtime -R

echo "Installing automatic backup"

dest="/mnt/backup"
echo "Creating the destination folder if not exist and ajust privileges"
mkdir -p $dest
chown $CURRENT_USER:$CURRENT_USER $dest -R

echo "Copy backup script to it's destination"
wget https://raw.githubusercontent.com/fullbright/historycrawler/master/backup.sh -O $dest/backup.sh
chmod +x $dest/backup.sh

echo "Adding the crontab task"
#write out current crontab
crontab -u $CURRENT_USER -l > mycron
#echo new cron into cron file
#echo "00 09 * * 1-5 echo hello" >> mycron
echo "0 0 * * * bash $dest/backup.sh" >> mycron
#install new cron file
crontab -u $CURRENT_USER mycron
rm mycron

echo ** Installation finished	**
