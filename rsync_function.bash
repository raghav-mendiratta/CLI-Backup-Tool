#!/bin/bash

function rsync_func(){

		GREEN='\033[0;32m'
		NC='\033[0m'
		
		while true
		 do
		 	echo ""
			echo -e "${GREEN} ----- Rsync Backups Choices ----- ${NC}"		 	
			echo ""
			echo "1 -> Copy Directory Content Only"
			echo "2 -> Copy Whole Directory"
			echo "3 -> Mirror Exact Folder (Risky)"
			echo "4 -> Backup with Compression & Progress"
			echo "5 -> Move Files"
			echo "6 -> Restore Backup"
			echo "7 -> Schedule Backup"
			echo "8 -> Remote backup over SSH"
			echo "9 -> View rsync Help"
			echo "10 -> Custom rsync Command"
			echo "; -> Exit rsync Menu"
			echo ""
		
			read -p "Enter your Choice: " rsync_choice

			for cmd in rsync tar at; do
			  if ! command -v $cmd &>/dev/null; then
    			echo "$cmd is not installed. Please install it to proceed."
    			break
  			  fi
			done


			case $rsync_choice in
			
				1)
					while true
					do
						echo ""
						read -p "Enter Source Path: " source
						read -p "Enter Destination Path: " desti

						if [[ $source == ";" || $desti == ";" ]]; then
							break
						fi
						
						if [[ $source == */ ]]; then
							 fsource="$source"
						elif [[ $source != */ ]]; then
							fsource="${source}/"
						else
							echo ""
							echo "Path end is invalid"
						fi
							
						read -p "Want to Dry Run it first before proceeding (y/n): " dry
						
						if [[ $dry == "y" ]]; then
							echo ""
							rsync -avhn --progress "$fsource" "$desti"
							echo "Dry run Completed Successfully"
							break
						elif [[ $dry == "n" ]]; then
							rsync -avh --progress "$fsource" "$desti"
							echo ""
							echo "Process Completed Successfully"
							break
						else
							continue
						fi
					done
					;;
				2)

					while true
					do
						echo ""
						read -p "Enter Source Path: " source
						read -p "Enter Destination Path: " desti

						if [[ $source == ";" || $desti == ";" ]]; then
							break
						fi

						if [[ $source == */ ]]; then
							fsource="${source%/}"
						elif [[ $source != */ ]]; then
							fsource="$source"
						else
							echo "Path end is Invalid"
						fi
						
						read -p "Want to Dry Run it first before proceeding (y/n): " dry
						
						if [[ $dry == "y" ]]; then
							echo ""
							rsync -avhn --progress "$fsource" "$desti"
							echo "Dry run Completed Successfully"
							break
						elif [[ $dry == "n" ]]; then
							rsync -avh --progress "$fsource" "$desti"
							echo ""
							echo "Process Completed Successfully"
							break
						else
							continue
						fi
					done
					;;
					
				3)

					while true
					do
						echo ""
						RED='\033[0;31m'
						echo "${RED} WARNING: This will delete files in destination if not present in source ${NC}"
						echo ""
						read -p "Enter Source Path: " source
						read -p "Enter Destination Path: " desti

						if [[ $source == ";" || $desti == ";" ]]; then
							break
						fi
						
						if [[ $source == */ ]]; then
							 fsource="$source"
						elif [[ $source != */ ]]; then
							fsource="${source}/"
						else
							echo ""
							echo "Path end is Invalid"
							continue
						fi

						read -p "Want to Dry Run it first before proceeding (y/n): " dry

						if [[ $dry == "y" ]]; then
							echo ""
							rsync -avhn --delete --progress "$fsource" "$desti"
							echo ""
							echo "Dry run Completed Successfully"
							break
						elif [[ $dry == "n" ]]; then
							echo ""
							rsync -avh --delete --progress "$fsource" "$desti"
							echo ""
							echo "Mirroring Completed Successfully"
							break
						else
							continue
						fi
						
					done
					;;

				4) 

					while true
					do
						echo ""
						read -p "Enter Source Directory to Compress: " source
						read -p "Enter Path to Destination File: " desti

						if [[ $source == ";" || $desti == ";" ]]; then
							break
						fi

						while true
						do
							read -p "Do you want to setup a custom file name? (y/n): " ans
							timestamp=$(date +"%Y-%m-%d_%H-%M")

							if [[ $ans == "y" ]]; then
											
								read -p "Enter Custom File Name: " custom_name
								backup_name="${custom_name}.tar.gz"
								
								if [[ -e $backup_name ]]; then
									echo "File Already Exists"
									echo ""
									continue
								else
									break
								fi
							
							elif [[ $ans == "n" ]]; then
								backup_name="${timestamp}.tar.gz"
								break
								
							elif [[ $ans == ";" ]]; then
								break

							else 
								continue
							fi
						done

					echo ""

					if [[ $desti != */ ]]; then
						echo ""
						tar -czvf "${desti}/${backup_name}" --checkpoint=.100 --checkpoint-action=echo="Processed 100 files" "$source"
						echo ""
						echo "File Compressed Successfully: $backup_name"
						echo ""
						break
					elif [[ $desti == */ ]]; then
						echo ""
						tar -czvf "${desti}${backup_name}" --checkpoint=.100 --checkpoint-action=echo="Processed 100 files" "$source"
						echo ""
						echo "File Compressed Successfully: $backup_name"
						echo ""
						break
					elif [[ $source == ";" || $desti == ";" ]]; then
						break
					else
						echo "Invalid Path"
						continue
					fi
					
				done
				;;

				5)
					while true
					do
						read -p "Enter Source Path: " source
						read -p "Enter Destination Path: " desti
						if [[ $source == ";" || $desti == ";" ]]; then
							break
						elif [[ $source != */ ]]; then
							fsource="${source}/"
						elif [[ $source == */ ]]; then
							fsource="${source}"
						else
							echo "Invalid Path"
							continue			
						fi				

						read -p "Want to dry run it first before proceeding (y/n): " dry
						
						if [[ $dry == "y" ]]; then
							echo ""
							rsync -av --remove-source-files --dry-run "$fsource" "$desti"
							echo "Dry run Successfull"
							echo ""
							break
						elif [[ $dry == "n" ]]; then
							echo ""
							rsync -av --remove-source-files "$fsource" "$desti"
							echo "File Moved Successfully"
							echo ""
							break
						else
							continue
						fi
						
					done
					;;	
				6)

				    while true
				    do
				        read -p "Enter Backup Source Path: " backup_source
				        read -p "Enter Restore Destination Path: " restore_dest

				
					   if [[ $backup_source == ";" || $restore_dest == ";" ]]; then
					   		break
					   fi
					   	 
				       if [[ $backup_source != */ ]]; then
				            fsource="${backup_source}/"
				       else
				            fsource="${backup_source}"
				       fi
				
				        read -p "Want to dry run it first before proceeding? (y/n): " dry
				
				        if [[ $dry == "y" ]]; then
				            echo ""
				            rsync -avh --progress --dry-run "$fsource" "$restore_dest"
				            echo "Dry run completed successfully"
				            break
				        elif [[ $dry == "n" ]]; then
				        		read -p "WARNING: This will over write files in destination if already exists. Continue (y/n): " confirm
				        		if [[ $confirm == "y" ]]; then
				            		echo ""
				            		rsync -avh --progress "$fsource" "$restore_dest"
				            		echo "Restore completed successfully"
				            		break
				            	else
				            		break
				            	fi
				        else
				            continue
				        fi
				    done
				    ;;
				7)

					while true
					do 
						read -p "Enter Backup Source Path: " src
    					read -p "Enter Backup Destination Path: " dest
    					read -p "Enter Time (e.g., 4:30): " time
    					read -p "AM or PM: " meridian

    					if [[ $src == ";" || $dest == ";" ]]; then
    						break
    					fi

						if [[ $src != */ ]]; then
							fsource="${src}/"
						elif [[ $src == */ ]]; then
							fsource="${src}"
						else
							echo "Path end is invalid"
							continue
						fi

						full_time="${time} ${meridian}"

						while true
						do

							read -p "Want to dry run it first before proceeding (y/n): " dry

							if [[ $dry == "y" ]]; then
								echo ""
								rsync -avh --progress --dry-run "$src" "$dest"
								echo ""
								echo "Dry run Sucessfull"
								break
							elif [[ $dry == "n" ]]; then
								
								while true 
								do
								
								read -p "Confirm to schedule this backup at $full_time? (y/n): " confirm
									if [[ $confirm == "y" ]]; then
										echo ""
										echo "rsync -avh --progress \"$fsource\" \"$dest\"" | at "$full_time"
										echo ""
										echo "Backup scheduled for $full_time"
										echo ""
										break
									elif [[ $confirm == "n" ]]; then
										echo "Backup Scheduling Canceled"
										echo ""
										break
									else 
										continue
									fi
									
									break 
								done
								break
							else 
								continue
							fi	
						done
					done
					;;

				8)

					while true
					do
						read -p "Enter Local Source Path: " local_src
    					read -p "Enter Remote Username: " remote_user
    					read -p "Enter Remote Host/IP: " remote_ip
    					read -p "Enter Remote Destination Path: " remote_dest
    					read -p "(Optional) Enter SSH Port (default 22): " ssh_port
    					ssh_port=${ssh_port:-22}

    					if [[ $local_src == ";" || $remote_dest == ";" || $remote_ip == ";" || $remote_user == ";" ]]; then
    						break
    					fi
    					
    					if ! [[ $ssh_port =~ ^[0-9]+$ ]]; then
    						echo "Invalid Port!"
    						continue
    					fi


    					while true
    					do
    						read -p "Want to dry run it first before proceeding (y/n): " dry
    						if [[ $dry == "y" ]]; then
    							rsync -avz --dry-run -e "ssh -p $ssh_port" "$local_src" "$remote_user@$remote_ip:$remote_dest"
    							echo ""
    							echo "Dry Run Successful"
    							echo ""
    						elif [[ $dry == "n" ]]; then
    							 rsync -avz -e "ssh -p $ssh_port" "$local_src" "$remote_user@$remote_ip:$remote_dest"
    							 echo ""

    							if [[ $? -eq 0 ]]; then
    								echo ""
    								echo "Remote Backup Completed"
    								echo ""
    								break
    							else 
    								echo ""
    								echo "Remote Backup Failed"
    								echo ""
    								break
    							fi
    						else 
    							continue
    						fi
    					done
    					break
    				done
    				;;	
    			9)
    				echo ""
    				rsync --help
    				;;
    			10)
    				echo ""
    				read -p "Enter custom rsync command : " custom_cmd
    				eval "$custom_cmd"
    				;;
    													
				";")

					break
					;;
				*)
					echo ""
					echo "Invalid Choice"
					;;
			esac
		done								
}
