#!/bin/bash
# Modified from http://linuxcommand.org/lc3_adv_dialog.php
# while-menu-dialog: a menu driven system information program
# Adjust tcdialog to dialog or similar in Fedora

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=25
WIDTH=100


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
    "1" "Go to home directory" \
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
	cd
	;;
    2 )
	cd ..
	;;
    3 )
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
	result=$(ls -lh)
	display_result "All files containing this directory"
	;;
    5 )
	du -ah --max-depth=1 | sort -hr > /home/surando/Desktop/test.txt
	result=$(du -ah --max-depth=1 | sort -hr)
	display_result "All files containing this directory"
      	;;
    6)
	$DIR/trav.sh > $DIR/trav.txt
	COUNT=$(gawk '{ sum += $3 }; END { print sum }' $DIR/trav.txt)
	echo "total| " $COUNT >> $DIR/trav.txt
	dialog --stdout --textbox $DIR/trav.txt 22 70
	;;
  esac
done
