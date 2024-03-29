#!/usr/bin/env bash

#todo add check for debug=1 in gpgmda
#todo apt-get install clamsmtp

argcount=2
usage="user@domain.com sentuser@domain.com"
test "$#" -eq "${argcount}" || { echo "$0 ${usage}" && exit 1 ; } #"-ge=>=" "-gt=>" "-le=<=" "-lt=<" "-ne=!="

test -s /bin/gpgmda || { cp -v gpgmda /bin/gpgmda || exit 1 ; }
test -x /bin/gpgmda || { chmod +x /bin/gpgmda || exit 1 ; }

mailbox_command=$(postconf | grep gpgmda | cut -d ' ' -f 3)
echo "mailbox_command: ${mailbox_command}"
test -n "${mailbox_command}" || { postconf -e "mailbox_command = /bin/gpgmda" && /etc/init.d/postfix restart || exit 1 ; }
mailbox_command=$(postconf | grep gpgmda | cut -d ' ' -f 3)
test -n "${mailbox_command}" || { echo "\"postconf | grep gpgmda\" returned nothing. Check that /etc/postfix/main.cf has the line \"mailbox_command = /bin/gpgmda\" and that path to gpgmda is correct. Exiting." ; exit 1 ; }

test -f "${mailbox_command}" || { echo "File: ${mailbox_command} does not exist. Check that /etc/postfix/main.cf has the line \"mailbox_command = /bin/gpgmda\" and that path to gpgmda is correct. Exiting." ; exit 1 ; }
test -x "${mailbox_command}" || { echo "File: ${mailbox_command} does not have execute permissions. Run \"chmod +x ${mailbox_command}\". Exiting." ; exit 1 ; }

echo -e "\nTesting ${mailbox_command}:"

echo "metastable intermolecular composite" | "${mailbox_command}" || { echo "${mailbox_command} returned > 0. Exiting." ; exit 1 ; }

echo -e "Testing user accounts:"
user=$(echo "${1}" | cut -d '@' -f 1)
sentuser=$(echo "${2}" | cut -d '@' -f 1)
test -d /home/"${user}" || { echo "user folder \"/home/${user}\" was not found. Exiting." ; exit 1 ; }
test -d /home/"${sentuser}" || { echo "user folder \"/home/${sentuser}\" was not found. Exiting." ; exit 1 ; }
echo "OK"

echo -e "\nTesting sudo:"
su "${user}" -c "ls /home/${user}" || exit 1
su "${sentuser}" -c "ls /home/${sentuser}" || exit 1
echo "OK"


echo -e "\nTesting gpgmda as each user:"
su "${user}" -c "echo metastable | ${mailbox_command}" || exit 1
su "${sentuser}" -c "echo metastable | ${mailbox_command}" || exit 1
echo "OK"

echo -n -e "\nChecking if /home/user/gpgMaildir exists:"
test -d /home/user/gpgMaildir || { echo "/home/user/gpgMaildir does not exist or is not a folder, run \"mkdir /home/user/gpgMaildir\" to fix" ; }
echo " OK"

echo -n -e "\nChecking if /home/sentuser/gpgMaildir exists:"
test -d /home/sentuser/gpgMaildir || { echo "/home/sentuser/gpgMaildir does not exist or is not a folder, run \"mkdir /home/sentuser/gpgMaildir\" to fix" ; }
echo " OK"

echo -e "\nTesting for /home/${user}/gpgMaildir/.sent symlink:"
test -L "/home/${user}/gpgMaildir/.sent" || { echo ".sent symlink missing, run \"ln -sf /home/sentuser/gpgMaildir/new /home/user/gpgMaildir/.sent\" to fix. Exiting." ; exit 1 ; }
su "${user}" -c "ls /home/${user}/gpgMaildir/.sent" || { echo "User \"${user}\" does not have permission to read /home/${user}/gpgMaildir/.sent, run \"chown -R sentuser:mailreaders /home/${sentuser} && chown -h user:mailreaders /home/${user}/gpgMaildir/.sent && chmod -R g+rx /home/${sentuser}\" to fix. Exiting." ; exit 1 ; }
echo "OK"

echo "All tests completed OK. Exiting."
exit 0
