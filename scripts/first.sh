#!/bin/bash

RAND=echo$((1 + RANDOM % 3))

case $RAND in

	1)
		touch Entrance/scroll.txt
		echo "The secret word is: \"Alhambra\" \n type \"./stairs\" to continue" > Entrance/scroll.txt
		;;
	2)
		touch Entrance/.scroll
		echo "The secret word is: \"Alhambra\" \n type \"/.stairs\" to continue" > Entrance/.scroll
		;;
	3)
		touch Entrance/s\ c\ r\ o\ l\ l.txt
		echo "The secret word is: \"Alhambra\" \n type \"./stairs\" to continue" > Entrance/s\ c\ r\ o\ l\ l.txt
		;;
esac


