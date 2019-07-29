#!/bin/bash

DIRS=()

cat /tmp/edurange-roguelike/motd/message.txt >> /etc/motd

for FILE in /home/*; do
	if [[ -d $FILE ]]; then 
		DIRS+=( "$FILE" )
		echo $FILE
	fi
done

cp /bin/bash /bin/rbash

for studentDIR in "${DIRS[@]}"; do
	player=$(basename $studentDIR)
	cp /tmp/edurange-roguelike/motd/message.txt /$studentDIR/

	mkdir $studentDIR/Entrance
done

