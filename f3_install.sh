#!/bin/bash

DIRS=()

rm -rf /etc/motd

cat /tmp/edurange-roguelike/motd/f3_message.txt > /etc/motd

for FILE in /home/*; do
	if [[ -d FILE ]]; then
		DIRS+=( "$FILE" )
		echo $FILE
	fi
done

for studentDIR in "${DIRS[@]}"; do
	RAND=$[RANDOM%3+1]
	player=$(basename $studentDIR)

	cd /home/"$player" || exit

	edurange-get-var user "$player" secret_floor_three > flag
	chown "$player":"$player" flag
	chmod 400 flag

	password=$(edurange-get-var user "$player" floor_three_password)
	echo -e "${password}\n${password}" | passwd "$player"

	nextPass=$(edurange-get-var user "$player" floor_four_password)

	case $RAND in 
		1)	cat /tmp/edurange-roguelike/texts/chaos.txt > $studentDIR/chaos.txt
			cat /tmp/edurange-roguelike/motd/f3_inst1.txt > $studentDIR/message.txt
			cat > $studentDIR/scroll.txt <<EOF
----------------------------
Well done! You've solved the challenge!
----------------------------
The IP Address for the next floor is 10.0.0.47

The Password is: $nextPass
EOF
			zip -e lockbox.zip scroll.txt -P bleak
			rm -rf scroll.txt

			echo "cat $studentDIR/message.txt" >> $studentDIR/.bashrc

			;;

		2)	cat /tmp/edurange-roguelike/texts/logic.txt > $studentDIR/logic.txt
			cat /tmp/edurange-roguelike/motd/f3_inst2.txt > $studentDIR/message.txt
			cat > $studentDIR/scroll.txt <<EOF
-----------------------------
Well done! You've solved the challenge!
-----------------------------
The IP Address for the next floor is 10.0.0.47

The Password is: $nextPass
EOF
			zip -e lockbox.zip scroll.txt -P beef
			rm -rf scroll.txt

			echo "cat $studentDIR/message.txt" >> $studentDIR/.bashrc
			;;

		3)
			cat /tmp/edurange-roguelike/texts/lighthouse.txt > $studentDIR/lighthouse.txt
			cat /tmp/edurange_roguelike/motd/f3_inst3.txt > $studentDIR/message.txt
			cat > $studentDIR/scroll.txt <<EOF
----------------------------
Well done! You've solved the challenge!
---------------------------
The IP Address for the next floor is 10.0.0.47

The Password is: $nextPass
EOF
		zip -e lockbox.zip scroll.txt -P tell
		rm -rf scroll.txt
	
		echo "cat $studentDIR/message.txt" >> $studentDIR/.bashrc
		;;

		*)
			touch $studentDIR/ohno.txt
			;;
	esac

	if [ "$player" = "instructor" ]; then
		continue
	fi
	mkdir "$studentDIR"/bin
	chmod 755 "$studentDIR"/bin
	echo "PATH=$studentDIR/bin" >> "$studentDIR"/.bashrc
	echo "export PATH" >> "$studentDIR"/.bashrc

	ln -s /bin/cat "$studentDIR"/bin
	ln -s /bin/su "$studentDIR"/bin/
	ln -s /bin/bash "$studentDIR"/bin/
	ln -s /bin/ls "$studentDIR"/bin/
	ln -s /bin/date "$studentDIR"/bin/
	ln -s /usr/bin/whoami "$studentDIR"/bin/
	ln -s /usr/bin/cut "$studentDIR"/bin/
	ln -s /usr/bin/ssh "$studentDIR"/bin/
	ln -s /usr/bin/sudo "$studentDIR"/bin/
	ln -s /usr/bin/vi "$studentDIR"/bin/
	
	ln -s /bin/grep "$studentDIR"/bin/
	ln -s /bin/unzip "$studentDIR"/bin/

	chattr +i "$studentDIR"/.bashrc
	chmod -x "$studentDIR"/bin
done
