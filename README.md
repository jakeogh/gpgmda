gpgmda - Encrypt mail and it's metadata while at rest.

https://github.com/jakeogh/gpgmda

# DESCRIPTION:
-------------------------
This is a set of scripts to store[1], distribute[2] and manage[3] mail.

[1] Mail is stored on the server encrypted with gpg by the included MDA script gpgmda (tested on postfix).

[2] Mail is distributed to any number of clients (mail readers) via ssh/rsync.

[3] Mail is read, tagged, and replied to with alot. Standard end-to-end public key encryption and decryption are supported.


# DEPENDENCIES:
-------------------------
 xapian: http://xapian.org

 notmuchmail: http://notmuchmail.org

 alot: https://github.com/pazz/alot

 gnupg: http://gnupg.org

 getmail: http://pyropus.ca/software/getmail (optional)

 ssh: http://openssh.org

 rsync: http://rsync.samba.org

 tar: http://www.gnu.org/software/tar

 parallel: http://www.gnu.org/software/parallel

 coreutils: http://www.gnu.org/software/coreutils


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

 Called by alot to send message via ssh through the mailserver hosting gpgmda. Note this determines the user that postfix uses to send mail.

* getmail_gmail

 Download gmail account (needs fixing).

* gpgmda_to_maildir

 Convert gpgMaildir to Maildir (individual messages or all messages) by calling gpgmda_decrypt_msg.
	
* gpgmda_decrypt_msg

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

* generate_gpgmda_example_configs

 Create example config files under ~/.gpgmda (run this and then read the examples in ~/.gpgmda/).


# INSTALLATION:

1. Install the dependencies.

2. Read gpgmda.README and setup gpgmda on your mailserver.

3. Execute generate_gpgmda_example_configs locally, edit and rename the example files.

4. Run "mail_update --update --read user@domain.net" to rsync, decrypt, index and read your mail.

5. Run "mail_update --read user@domain.net" to just read your mail.

6. Add aliases in ~/.bashrc for steps 5 and 6.

7. Fix bugs, send pull requests.


# FEATURES:

As far as I know, this is the only open system that protects the email headers as well as the body and attachments of mail "at rest" on the server. Other solutions[4] apply public key encryption opportunistically to the body and attachments, but this leaves the metadata (like FROM TO and SUBJECT) in plaintext.

Your email is backed up. By default, these scripts leave your email (encrypted) on the server and your local copy syncs to it. If it's deleted it off the server, your local copy remains, and vice versa.

If the email server is compromised, the attacker only gets a copy of your encrypted mail (they get NO metadata, no headers, etc), incoming metadata and possibly the plaintext of incoming mail if it's not already encrypted from the sender.

Alot (the email client) has all the features you would expect from a modern web client like gmail.

* Tagging. Like gmail, you can add tags and group messages by tags.
* Threading.
* Searching. Notmuch (the email index) has extensive search capabilities via xapian (the search engine).
* HTML view. You can configure alot to pipe a message to any app, so it's easy to view a HTML email by automatically (if desired) sending it to a web browser. In theory you could even render in the terminal with "links2 -g".
* Themes.
* Multiple accounts.
* Full support for PGP/MIME encryption and signing.
* Active development community.
* 

 alot Docs:

	Overview: https://github.com/pazz/alot

	Manual: http://alot.readthedocs.org/en/latest/



[4] Similar software:

gpgit:
 
* https://grepular.com/Automatically_Encrypting_all_Incoming_Email

* https://github.com/mikecardwell/gpgit

	

	

Contribute / Goals:

 Feedback and patches are greatly appreciated. The goal is to make this system turnkey, it should work on all platforms and should have a comprehensive (automated) script to configure the postfix server and clients.

 Support for MUA's other than alot exists, this system creates a normal local Maildir from the encrypted Maildir on the server which any email client can use. Testing and documentation is needed.

 It would be nice if the (yet to exist) setup script can configure [Opportunistic encryption](https://en.wikipedia.org/wiki/Opportunistic_encryption) and spam protection on the mail server.
