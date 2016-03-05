## This script was done for getting your titanpads as plaintext.
## Idea was to set up Titanpads online to your webspace
##
## Original script below
## https://github.com/domenkozar/titanpad-backup-tool/blob/master/titanpad_backup.sh
## thanks to domenkozar!
##
##
##
##
## Modified by www.skaletz.me
## firstcontact@skaletz.me
##
##  ./titanpad_backup.sh <padpw> <padnumber>
## you can see the Number of pad in URL 
## https://$DOMAIN.titanpad.com/ep/pad/auth/"NUMBER"
##
##
DOMAIN="Domainname" # Here you have to input your own Domainname
COOKIES=~/.titanpad_cookies
LOCATION="titanpad/pad_$2_$(date "+%Y-%m-%d").txt"

touch $COOKIES

# make directory for titanpad
mkdir -p ~/titanpad

# saving Cookies for session
wget    --no-check-certificate \
»·······--keep-session-cookies \
»·······-O /dev/null \
»·······--save-cookies $COOKIES \
»·······"https://$DOMAIN.titanpad.com/ep/pad/auth/$2?cont=https%3a%2f%2f$DOMAIN.titanpad.com%2fep%2fpad%2fexport%2f3%2flatest%3fformat%3dtxt"
# giving password to titanpad
wget    --no-check-certificate \
»·······--load-cookies $COOKIES \
»·······-O /dev/null \
»·······--post-data "password=$1" \
»·······"https://$DOMAIN.titanpad.com/ep/pad/auth/$2?cont=https%3a%2f%2f$DOMAIN.titanpad.com%2fep%2fpad%2fexport%2f3%2flatest%3fformat%3dtxt"

# download your titanpad
wget --load-cookies $COOKIES --no-check-certificate -O ~/$LOCATION "https://$DOMAIN.titanpad.com/ep/pad/export/$2/latest?format=txt"

# delete Cookies
rm $COOKIES

# delete older files than a month
find ~/titanpad/pad_$2* -mtime +30 -exec rm {} \;
