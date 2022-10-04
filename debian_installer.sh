#!/bin/sh

#first do:
#from client side
#scp ~/cfg/_myapps/gpgmda/gpgmda root@mail.domain.net:/bin/gpgmda || exit 1
#scp ~/cfg/_myapps/gpgmda/check_postfix_config root@mail.domain.net:/root/check_postfix_config || exit 1
#scp ~/cfg/_myapps/gpgmda/aliases root@mail.domain.net:/etc/aliases || exit 1

#exit 1 # comment this out to run on postfix server

# maks sure user is in sudo group
# install sudo
# fix sudoers

apt-get -y update || exit 1
apt-get -y upgrade || exit 1
#apt-get -y gpgv2 || exit 1
apt-get -y install e2fsprogs || exit 1
apt-get -y install nano || exit 1
apt-get -y install htop || exit 1
apt-get -y install mc || exit 1
apt-get -y install postfix || exit 1
apt-get -y install postfix-pcre || exit 1
apt-get -y install postfix-policyd-spf-python || exit 1
apt-get -y install rsync || exit 1
apt-get -y install rdiff-backup || exit 1
id -u user >/dev/null 2>&1 || adduser user
id -u sentuser >/dev/null 2>&1 || adduser sentuser
[ $(getent group mailreaders) ] || { groupadd mailreaders || exit 1 ; }
groups root | grep mailreaders || { usermod -a -G mailreaders root && exec su -l $USER || exit 1 ; }
groups user | grep mailreaders || { usermod -g mailreaders user || exit 1 ; }
groups sentuser | grep mailreaders || { usermod -g mailreaders sentuser || exit 1 ; }
#copy .gnupg to /home/user and /home/sentuser
chown -R user:user /home/user || exit 1
chown -R sentuser:sentuser /home/sentuser || exit 1
./check_postfix_config user@v6y.net sentuser@v6y.net || exit 1 #makes folders, expect failure here due to missing symlink
test -h /home/user/gpgMaildir/.sent || { ln -sf /home/sentuser/gpgMaildir/new /home/user/gpgMaildir/.sent || exit 1 ; }
newaliases



