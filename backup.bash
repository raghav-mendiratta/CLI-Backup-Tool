#!/bin/bash
source ./zip_function.bash
source ./rsync_function.bash
source ./cloud_function.bash

GREEN='\033[0;32m'
NC='\033[0m'
echo ""

while true
do
	echo ""
	echo -e "${GREEN} ===== Main Backup Menu ===== ${NC}"
	echo ""
	echo "1 -> Backup a File/Folder (zip)"
	echo "2 -> Backup a File/Folder (rsync)"
	echo "3 -> Cloud Backup AWS"
	echo "; -> Exit"
	echo ""

	read -p "Enter your Choice: " choice

	case $choice in
		1)
			echo ""
			zip_func
			;;
		2)
			echo ""
			rsync_func
			;;
		3)
			echo ""
			cloud_aws
			;;
			
		";")

			break
			;;

		*)
			echo ""
			echo "Invalid Choice"
			echo ""
	esac
done
	






