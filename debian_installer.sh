#!/bin/sh

#first do:
#from client side
#scp ~/cfg/_myapps/gpgmda/gpgmda root@mail.domain.net:/bin/gpgmda || exit 1
#scp ~/cfg/_myapps/gpgmda/check_postfix_config root@mail.domain.net:/root/check_postfix_config || exit 1
#scp ~/cfg/_myapps/gpgmda/aliases root@mail.domain.net:/etc/aliases || exit 1

exit 1 # comment this out to run on postfix server

apt-get -y update || exit 1
apt-get -y upgrade || exit 1
#apt-get -y gpgv2 || exit 1
apt-get -y install e2fsprogs || exit 1
apt-get -y install nano || exit 1
apt-get -y install htop || exit 1
apt-get -y install mc || exit 1
apt-get -y install postfix || exit 1
apt-get -y install rsync || exit 1
apt-get -y install rdiff-backup || exit 1
groupadd mailreaders || exit 1
usermod -a -G mailreaders root || exit 1
adduser user || exit 1
adduser sentuser || exit 1
#copy .gnupg to /home/user and /home/sentuser
chown -R user:user /home/user || exit 1
chown -R sentuser:sentuser /home/sentuser || exit 1
/root/check_postfix_config user@v6y.net sentuser@v6y.net #makes folders, expect failure here due to missing symlink
ln -sf /home/sentuser/gpgMaildir/new /home/user/gpgMaildir/.sent || exit 1
newaliases



