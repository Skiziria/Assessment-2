#!/bin/bash
#create the path to where the shell was executed from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#set dialog sizes
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=25
WIDTH=100

#setting up dialog
display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "System Information" \
    --title "$PWD" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 15 \
    "1" "Go to starting directory" \
    "2" "Go to the previous directory" \
    "3" "Manually change the directory" \
    "4" "Display all items in the directory" \
    "5" "Display the sizes & names of all directories and files" \
    "6" "Traverse current Directory" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    0 )
	clear
	echo "Program terminated."
	;;
    1 )
    	#go to the starting directory 
	cd $DIR
	;;
    2 )
    	#go to parent directory
	cd ..
	;;
    3 )
    	#create a dialog where you can manually input the path to where you want to be taken following this style /home/user/Desktop
	DIALOG=${DIALOG=dialog}

	FILE=`$DIALOG --stdout --title "Please choose a file" --fselect $PWD/ 14 48`

	case $? in
	0)
		echo "\"$FILE\" chosen\m"
 		cd $FILE
		;;
	1)
		echo "Cancel pressed.\n";;
	255)
		
		echo "Box closed.\n";;
	esac
	;;
    4 )
    	#display all the files and directories with execution premmistions
	result=$(ls -lh)
	display_result "All files and directories containing this directory"
	;;
    5 )
    	#display all files and directories with their sizes
	du -ah --max-depth=1 | sort -hr > /home/surando/Desktop/test.txt
	result=$(du -ah --max-depth=1 | sort -hr)
	display_result "All files containing this directory"
      	;;
    6)
    	#use the trav.sh shell and put the output in trav.txt in the starting direcotry
	$DIR/trav.sh > $DIR/trav.txt
	#add the total amount at the bottom of trav.txt file
	COUNT=$(gawk '{ sum += $3 }; END { print sum }' $DIR/trav.txt)
	echo "total| " $COUNT >> $DIR/trav.txt
	#display the content of trav.txt in a dialog
	dialog --stdout --textbox $DIR/trav.txt 22 70
	;;
  esac
done
