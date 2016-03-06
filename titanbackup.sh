## "titanbackup.sh"
    VERSION="Sat Mar 05 21:42:23 CET 2016"
## size: 3700 bytes

## Idea: Download a textpad from your site on titanpad.com
## Usage:   ./titanpad_backup.sh <padpw> <padnumber>
## Example: ./titanpad_backup.sh foobar  2342

## you can see the number of pad in URL
## https://$DOMAIN.titanpad.com/ep/pad/auth/"NUMBER"

## This script was done for getting your titanpads as plaintext.
## Idea was to set up Titanpads online to your webspace
##
## Original script by Domen Kozar:
## https://github.com/domenkozar/titanpad-backup-tool/blob/master/titanpad_backup.sh
##
## Domen    Kozar   www.domenkozar.com  domen@dev.si
## Matthias Skaletz www.skaletz.me      firstcontact@skaletz.me
## Sven     Guckes  www.guckes.net      titan_backup@guckes.net

## Sven:  rewrite with usage output, header, credits,
## EVA principle (Eingabe, Verabeitung, Ausgabe - Input, Processing, Output),
## quieting down the output of wget with "--quiet",
## and some additional output for testing. :)

# -------------------------------------------------------------

# this script expects two parameters.
# when there  are not two parameters, show usage:
  if [[ $# -ne 2 ]]
  then
   echo "Usage:   $0 password padname"
   echo "Example: $0 foobar 2342"
   echo "to download the pad https://foobar.titanpad.com/2342"
   echo $VERSION
   exit 0
  fi

# -------------------------------------------------------------

# Here you have to input your own Domainname
# DOMAIN="${3:skaletz}"
  DOMAIN=skaletz
  if [[ $VERBOSE ]]; then
  echo DOMAIN=$DOMAIN
  fi

# the downloaded pads will stored in
# the $PAD_DIR using a filename which
# include the current date as "yyyy-mm-dd":
  TODAY=$(date '+%Y-%m-%d')
  PAD_DIR=$HOME/titanpad
  PAD_FILE=$PAD_DIR/pad.$2.$TODAY.txt

  if [[ $VERBOSE ]]; then
  echo PAD_FILE=$PAD_FILE
  fi

# the downoad URLs to be used:
  DOWNLOAD_URL1="https://$DOMAIN.titanpad.com/ep/pad/auth/$2?cont=https://$DOMAIN.titanpad.com/ep/pad/export/3/latest?format=txt"
  DOWNLOAD_URL2="https://$DOMAIN.titanpad.com/ep/pad/export/$2/latest?format=txt"

  if [[ $VERBOSE ]]; then
  echo URL1=$DOWNLOAD_URL1
  echo URL2=$DOWNLOAD_URL2
  fi

# the program to download with:
  WGET=$(which wget)
# TODO: check for existence
# TODO: adapt script for use with "curl"
  if [[ $VERBOSE ]]; then
  echo $WGET
  fi

# we need cookies for downloading
  COOKIES=~/.titanpad_cookies
  touch $COOKIES
  if [[ $VERBOSE ]]; then
  ls -l $COOKIES
  fi

# make directory for titanpad
  mkdir -p $PAD_DIR
  if [[ $VERBOSE ]]; then
  ls    -l $PAD_DIR
  fi

# -------------------------------------------------------------

# here we go..

# time of beginning:
  if [[ $VERBOSE ]]; then
  echo BEGIN: $(date)
  fi

# saving Cookies for session
echo getting cookies..
$WGET \
--quiet \
--no-check-certificate \
--keep-session-cookies \
-O /dev/null \
--save-cookies $COOKIES \
$DOWNLOAD_URL1

# giving password to titanpad
echo posting password..
$WGET \
--quiet \
--no-check-certificate \
--load-cookies $COOKIES \
-O /dev/null \
--post-data "password=$1" \
$DOWNLOAD_URL1

# download your titanpad
echo downloading pad..
$WGET \
--quiet \
--load-cookies $COOKIES \
--no-check-certificate \
-O $PAD_FILE \
$DOWNLOAD_URL2

# -------------------------------------------------------------
# cleaning up

# delete Cookies
  rm $COOKIES

# delete files in $PAD_DIR which are older than a month (30 days):
# cd $PAD_DIR; find . -mtime +30 -exec rm {} \;

# show downloaded pad
  ls -l $PAD_FILE

# time of completion
  if [[ $VERBOSE ]]; then
  echo END: $(date)
  fi

# modeline for the editor vim (www.vim.org) with End-Of-File marker:
# vim: set et ft=sh tw=999 nowrap: authors: domenkozar skaletz guckes EOF
