#!/bin/bash

echo *************************************
echo **                           	    **
echo ** 	HISTORY CRAWLER		        **
echo ** 	Run applications	        **
echo ** 				                **
echo *************************************

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi


echo "Starting history crawler"

echo "Starting Google Refine ..."
./google-refine-2.5/refine &
echo "Done."

echo "Starting overview ..."
cd overview*
./run &
cd ..
echo "Done"

echo "Starting Meandre ..."
sh ./Meandre-1.4.12/Start-Infrastructure.sh
sh ./Meandre-1.4.12/Start-Workbench.sh
echo "Done."

echo "Finished starting all the applications."
