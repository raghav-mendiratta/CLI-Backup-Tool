#!/bin/bash

function zip_func() {

	while true
	do
		read -p "Enter File Path (';' to exit): " path
		file_name=$(basename "$path")
		
		if [ "$path" == ";" ]; then
			break
		elif [ ! -e "$path" ]; then
			echo "Invalid Path"
		elif [ -e "$file_name.zip" ]; then
			echo ""
			echo "File already Exists"
			echo ""
			continue		
		else
			while true
			do
			
			read -p "MAX Compression level(slow) (y/n): " user_inp
			
			 if [ "$user_inp" == "y" ]; then
				 echo ""
				 zip -r -9 "${file_name}.zip" "$path"
				 echo ""
				 echo "Zip File Created: ${file_name}.zip"
				 command -v notify-send >/dev/null && notify-send "Zip File Created: ${file_name}.zip"
				 echo ""
				 break
			elif [ "$user_inp" == "n" ]; then
				 echo ""
				 zip -r "${file_name}.zip" "$path"
				 echo ""
				 echo "Zip File Created: ${file_name}.zip"
				 command -v notify-send >/dev/null && notify-send "Zip File Created: ${file_name}.zip"
				 echo ""
				 break
			else
				 continue
			 fi
			 
			done
		fi
		
	done
}
