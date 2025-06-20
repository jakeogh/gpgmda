**gpgmda - Encrypt mail and it's metadata while at rest on the server.**

https://github.com/jakeogh/gpgmda

# DESCRIPTION:
-------------------------
**gpgmda is a Mail Delivery Agent ([MDA](https://en.wikipedia.org/wiki/Mail_delivery_agent)) for postfix.**

**gpgmda is a MDA which encrypts incoming and outgoing messages with a public key.**

It's intended to be used with [gpgmda-client](https://github.com/jakeogh/gpgmda-client).

gpgmda is the result of google changing gmail TOS to read my/your/all mail. I wish I could find the original announcement... it's circa 2012.

# Important Notes:

- Google is skynet.

- Incoming and outgoing mail is written to disk encrypted with your public key on the mail server (postfix so far).

- Mail is distributed to any number of mail clients (and converted to std maildir format) via ssh/rsync.

- Mail is optionally read, tagged, and replied to with [alot](https://github.com/pazz/alot). Standard end-to-end public key encryption and decryption are supported. Any maildir compatible client can be used.


# DEPENDENCIES:
-------------------------
**global:**

- bash: https://www.gnu.org/software/bash/
- gnupg: http://gnupg.org
- ssh: http://openssh.org
- rsync: http://rsync.samba.org
- tar: http://www.gnu.org/software/tar
- coreutils: http://www.gnu.org/software/coreutils
- sudo: https://www.sudo.ws

**server-side:**

- postfix: http://www.postfix.org/

**client-side:**

- gpgmda-client: https://github.com/jakeogh/gpgmda-client

**client-side optional [alot](https://github.com/pazz/alot) deps:**

- xapian: http://xapian.org
- notmuchmail: http://notmuchmail.org
- alot: https://github.com/pazz/alot

**client-side optional pop3/imap deps:**

- getmail: http://pyropus.ca/software/getmail (optional, used if you have POP/IMAP accounts you want to pull/migrate from)


# COMPONENTS:
-------------------------
**gpgmda**

- Encrypting local message delivery agent ([MDA](https://en.wikipedia.org/wiki/Mail_delivery_agent)). The only server side script here. 
- incoming mail -> postfix -> gpg(email_plaintext) -> encrypted Maildir file on postfix server. See gpgmda.README.

**gpgmda.README**

- Documentation for gpgmda.

**gpgmda_client**

- Download new mail, decrypt, add to notmuch, and read with alot (or your client of choice).

**mail_send**

- Called by alot to send message via ssh through the mail server hosting gpgmda. Note this determines the user that postfix uses to send mail.

**getmail_gmail**

- Download gmail account (needs fixing).

**LICENSE**

- Public Domain

**nottoomuch-addresses.sh**

- Script for managing the notmuch address book and address autocomplete in alot.
- See: https://github.com/domo141/nottoomuch/blob/master/nottoomuch-addresses.rst

**generate_example_configs**

- Create example config files under ~/.gpgmda (run this and then read the examples in ~/.gpgmda/).

**check_postfix_config**

- Setup script for postfix. (needs work)


# INSTALLATION:
-------------------------
1. Install the dependencies.

2. Read gpgmda.README and setup gpgmda on your mail server (the check_postfix_config.sh script should help).

3. If you are using gpgmda-client, continue to step #4

4. Execute generate_gpgmda_example_configs.sh locally, edit and rename the example files.

5. Run "gpgmda_client --download --decrypt --update_notmuch --read user@domain.net" to rsync, decrypt, index and read your mail.

6. Run "gpgmda_client --read user@domain.net" to just read your mail.

7. Add aliases in ~/.bashrc for steps 4 and 5.

8. Fix bugs, send patches.


# FEATURES:
-------------------------
This system protects the headers, body and attachments of mail "at rest" on the server. Similar MDA's apply public key encryption to the body and attachments, but this leaves the metadata (like FROM, TO and SUBJECT) in plaintext.

If you use this, your email is backed up; by default these scripts leave your mail (sent or received) encrypted on the server and your local machine syncs to it. If it's deleted it off the server, your local copy remains, and vice versa.

If the server is compromised the attacker gets:

* a copy of your encrypted mail (they get no past content, metadata, headers, or timestamps, it's all encrypted)
* nobody has steped up and made a filesystem with "noctime" but when that happens, I'll add it here, until then, 40 years after it should have been fixed, we still have ctime side channel for individual files
* using mbox instead does not fix the ctime issue, data is appended, so ctime can be inferred
* new inbound metadata and the plaintext of incoming mail if it's not [gpg](https://emailselfdefense.fsf.org/en/) encrypted by the sender
* the ability to forge messages since mail automatically encrypted with a public key and then stored on-disk obviously cant be automatically signed by your private key


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


**Similar-ish software:**

- https://news.ycombinator.com/item?id=18372486
- https://news.ycombinator.com/item?id=41246211

gpgit:

- https://grepular.com/Automatically_Encrypting_all_Incoming_Email
- https://github.com/mikecardwell/gpgit

S/MIME 3.1: (?)

- https://tools.ietf.org/html/rfc3851#page-14
- https://news.ycombinator.com/item?id=10006655


# CONTRIBUTE:
-------------------------
Feedback and patches are greatly appreciated. The goal is to make this work on all platforms and have a script configure the postfix server and clients (see check_postfix_config.sh).

Support for MUA's other than alot already exists, gpgmda-client creates a normal local Maildir from the encrypted Maildir on the server. Any maildir compatible email client can use it.

It would be nice if the server-side setup script could also configure [opportunistic encryption](https://en.wikipedia.org/wiki/Opportunistic_encryption) and spam protection on the mail server.

IF YOU DECIDE TO USE THIS, PLEASE JUST MAKE IT WORK FOR YOU AND FEEL FREE TO SEND ONE BIG PATCH.
