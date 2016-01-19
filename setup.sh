#!/bin/bash

echo *************************************
echo **                           	    **
echo ** 	HISTORY CRAWLER		        **
echo ** 	Full Installation	        **
echo ** 				                **
echo *************************************

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

echo "Installing base tools"
./install_tools.sh

echo "Installing necessary tools for history crawler to work"
./install_history_tools.sh

echo "Setting few things up"
# add configuration commands here

echo "Great ! Now we can run the application"
echo "Use the ./run.sh command to start the application"

