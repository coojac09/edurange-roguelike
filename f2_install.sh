#!/bin/bash
cat /tmp/edurange-roguelike/motd/f2_message.txt > /etc/motd

while read player; do
	player=$(echo -n $player)
	cd /home/$player

	cat /tmp/edurange-roguelike/motd/f2_message.txt > message.txt

	echo "$message" > message
	chmod 404 message
	echo "cat message" >> .bashrc

	echo $(edurange-get-var user $player secret_floor_two) > flag
	chown $player:$player flag
	chmod 400 flag

	# change password
	password=$(edurange-get-var user $player floor_two_password)
	echo -e "${password}\n${password}" | passwd $player

	# do directories
	for i in {1..100}; do
		mkdir dir$i
		cd dir$i
		mySeedNumber=$$`date +%N`; # seed will be the pid + nanoseconds
		myRandomString=$( echo $mySeedNumber | md5sum | md5sum );
		# create our actual random string
		myRandomResult="${myRandomString:2:100}"
		echo $myRandomResult > scroll.txt
		cd ..
		chown -R $player:$player dir$i
	done
	cd dir`shuf -i 1-100 -n 1` 
	echo "the password is $password, and the ip address is 10.0.0.16" > scroll.txt
	chmod 400 scroll.txt
	chown $player:$player scroll.txt
done
