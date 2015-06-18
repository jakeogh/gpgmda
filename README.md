gpgmda - Encrypt mail and it's metadata while at rest.

https://github.com/jakeogh/gpgmda

# DESCRIPTION:
-------------------------
This is a set of scripts to store[1], distribute[2] and manage[3] mail.

[1] Mail is stored gpg encrypted on the mail server by the included MDA script gpgmda (tested on postfix).

[2] Mail is distributed to any number of clients (mail readers) via ssh/rsync.

[3] Mail is read, tagged, and replied to with alot. Standard end-to-end public key encryption and decryption are supported.


# DEPENDENCIES:
-------------------------
 xapian: http://xapian.org

 notmuchmail: http://notmuchmail.org

 alot: https://github.com/pazz/alot

 gnupg: http://gnupg.org

 ssh: http://openssh.org

 rsync: http://rsync.samba.org

 tar: http://www.gnu.org/software/tar

 parallel: http://www.gnu.org/software/parallel

 coreutils: http://www.gnu.org/software/coreutils

 getmail: http://pyropus.ca/software/getmail (optional)


# COMPONENTS:
-------------------------
 * gpgmda

 Encrypting local message delivery agent (MDA). The only server side script here.
 incoming mail -> postfix -> gpg(email_plaintext) -> Maildir on postfix server

* gpgmda.README

 Documentation for gpgmda.

* mail_update

 Download new mail, decrypt, add to notmuch, and read with alot.

* mail_send

 Called by alot to send message via ssh through the mail server hosting gpgmda. Note this determines the user that postfix uses to send mail.

* getmail_gmail

 Download gmail account (needs fixing).

* gpgmda_to_maildir

 Convert gpgMaildir to Maildir (individual messages or all messages) by calling gpgmda_decrypt_msg.
	
* decrypt_msg

 Decrypt message encrypted by gpgmda.

* make_alot_theme

 Generate alot theme configuration file (edit this to customize the alot theme).

* make_alot_config

 Generate alot configuration file (edit this to customize alot).

* README.md

 This file.

* LICENSE	

 Public Domain

* nottoomuch-addresses.sh

 Script for managing the notmuch address book and address autocomplete in alot.
 See: https://github.com/domo141/nottoomuch/blob/master/nottoomuch-addresses.rst

* generate_example_configs

 Create example config files under ~/.gpgmda (run this and then read the examples in ~/.gpgmda/).

* check_postfix_config

 Setup script for postfix. (needs work)


# INSTALLATION:
-------------------------
1. Install the dependencies.

2. Read gpgmda.README and setup gpgmda on your mail server (the check_postfix_config script should help).

3. Execute generate_gpgmda_example_configs locally, edit and rename the example files.

4. Run "mail_update --update --read user@domain.net" to rsync, decrypt, index and read your mail.

5. Run "mail_update --read user@domain.net" to just read your mail.

6. Add aliases in ~/.bashrc for steps 5 and 6.

7. Fix bugs, send pull requests.


# FEATURES:
-------------------------
As far as I know, this is the only open system that protects the email headers as well as the body and attachments of mail "at rest" on the server. Other solutions[4] apply public key encryption to the body and attachments, but this leaves the metadata (like FROM TO and SUBJECT) in plaintext.

If you use this, your email is backed up; by default these scripts leave your mail (encrypted) on the server and your local machine syncs to it. If it's deleted it off the server, your local copy remains, and vice versa.

If the server is compromised the attacker gets:

* a copy of your encrypted mail (which means "nothing"; they get no past content, metadata, headers, or timestamps, it's all encrypted or [in the case of timestamps] wiped)
* new inbound metadata and the plaintext of incoming mail if it's not [gpg](https://emailselfdefense.fsf.org/en/) encrypted by the sender
* the ability to forge messages since mail automatically encrypted with a public key and then stored on-disk cant be automatically singed by a private key


[alot](https://github.com/pazz/alot) has all of the features expected from a modern email client:

* Tagging. Like gmail, you can add tags and group messages by tags.
* Threading.
* Searching. Notmuch (the email index) has extensive search capabilities via [xapian](http://xapian.org/).
* HTML view. You can configure alot to pipe a message to any app, so it's easy to view an HTML message by automatically (if desired) sending it to a web browser. In theory you could even render it in the terminal with "links2 -g".
* Themes.
* Multiple accounts.
* Full support for PGP/MIME encryption and signing.

alot Docs:

- Overview: https://github.com/pazz/alot
- Manual: http://alot.readthedocs.org/en/latest/


[4] Similar software:

gpgit:
 
- https://grepular.com/Automatically_Encrypting_all_Incoming_Email
- https://github.com/mikecardwell/gpgit
	

# CONTRIBUTE:
-------------------------
Feedback and patches are greatly appreciated. The goal is to make this turnkey, it should work on all platforms and should have a comprehensive (automated) script to configure the postfix server and clients (see check_postfix_config).

Support for MUA's other than alot already exists, mail_update creates a normal local Maildir from the encrypted Maildir on the server. Any maildir compatible email client can use it. More documentation is needed.

It would be nice if the server-side setup script could also configure [opportunistic encryption](https://en.wikipedia.org/wiki/Opportunistic_encryption) and spam protection on the mail server.
