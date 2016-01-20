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
cd ~
./google-refine-2.5/refine &
echo "Done."

echo "Starting overview ..."
cd ~
cd overview*
./run &
cd ..
echo "Done"

echo "Starting Meandre ..."
cd ~
sh ./Meandre-1.4.12/Start-Infrastructure.sh
sh ./Meandre-1.4.12/Start-Workbench.sh
echo "Done."

echo "Starting Voyant Server ..."
cd ~
java -jar VoyantServer.jar &
echo "Done."

echo "Starting Mallet application"
cd ~
java -jar TopicModelingTool.jar &
echo "Done."

echo "Finished starting all the applications."
