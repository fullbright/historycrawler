#!/bin/bash

echo *************************************
echo **                           	    **
echo ** 	HISTORY CRAWLER		        **
echo ** 	Install tools		        **
echo ** 				                **
echo *************************************

#CURRENT_USER=$(whoami)
CURRENT_USER="pi"
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

echo "The install vim and the awesome vimrc"
# awesome vimrc requires ctags
apt-get install vim -y
apt-get install ctags -y
apt-get install aptitude -y

git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

echo "Adding customiations to vim awesome"
echo "colorscheme mayansmoke" >> ~/.vim_runtime/my_configs.vim
echo "colorscheme peaksea" >> ~/.vim_runtime/my_configs.vim

echo "Give .vim_runtime folder ownership to $CURRENT_USER user"
chown $CURRENT_USER:$CURRENT_USER ~/.vim_runtime -R

echo ** Installation finished	**
