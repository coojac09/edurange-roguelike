#!/bin/bash

DIRS=()
rm -rf /etc/motd
cat /tmp/edurange-roguelike/motd/f2_message.txt > /etc/motd

for FILE in /home/*; do
	if [[ -d $FILE ]]; then
		DIRS+=( "$FILE" )
		echo $FILE
	fi
done


for studentDIR in "${DIRS[@]}"; do
	RAND=$[RANDOM%3+1]
	player=$(basename $studentDIR)

	cd /home/"$player" || exit

	edurange-get-var user "$player" secret_floor_two > flag
	chown "$player":"$player" flag
	chmod 400 flag

	# change password
	password=$(edurange-get-var user "$player" floor_two_password)
	echo -e "${password}\n${password}" | passwd "$player"
	mkdir $studentDIR/maze/

	# do directories
	for i in {1..100}; do
		mkdir maze/dir$i
		cd maze/dir$i || exit
		mySeedNumber=$$$(date +%N); # seed will be the pid + nanoseconds
		myRandomString=$( echo "$mySeedNumber" | md5sum | md5sum );
		# create our actual random string
		myRandomResult="${myRandomString:2:100}"
		echo "$myRandomResult" > scroll.txt
		cd $studentDIR
		chmod -R 666 maze/dir$i
	done

	case $RAND in
		1)	
			for loc in $studentDIR/maze/*; do
				chmod +x $loc/scroll.txt
			done
			cat /tmp/edurange-roguelike/motd/f2_inst1.txt > $studentDIR/message.txt
			cd $studentDIR
			cd maze/dir"$(shuf -i 1-100 -n 1)" || exit
			chmod -x scroll.txt
			echo "the password is $password and the ip address is 10.0.0.31" > scroll.txt
			;;
		2)      
			cat /tmp/edurange-roguelike/motd/f2_inst2.txt > $studentDIR/message.txt	
			groupadd -g 1337 finders
			usermod -G finders $player
			cd $studentDIR
			cd maze/dir"$(shuf -i 1-100 -n 1)" || exit
			echo "the password is $password and the ip address is 10.0.0.31" > scroll.txt
			chgrp finders scroll.txt
			;;

		3)	
			cat /tmp/edurange-roguelike/motd/f2_inst3.txt > $studentDIR/message.txt
			cd $studentDIR
			cd maze/dir"$(shuf -i 1-100 -n 1)" || exit
			echo "the password is $password and the ip address is 10.0.0.31, also here's some padding to change the file size." > scroll.txt
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

	ln -s /bin/cat "$studentDIR"/bin/
	ln -s /bin/su "$studentDIR"/bin/
	ln -s /bin/bash "$studentDIR"/bin/
	ln -s /bin/ls "$studentDIR"/bin/
	ln -s /bin/date "$studentDIR"/bin/
	ln -s /usr/bin/whoami "$studentDIR"/bin/
	ln -s /usr/bin/cut "$studentDIR"/bin/
	ln -s /usr/bin/ssh "$studentDIR"/bin/
	ln -s /usr/bin/sudo "$studentDIR"/bin/
	ln -s /usr/bin/vi "$studentDIR"/bin/
	ln -s /usr/bin/find "$studentDIR"/bin/

	chattr +i "$studentDIR"/.bashrc
done

