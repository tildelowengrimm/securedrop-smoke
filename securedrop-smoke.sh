#! /bin/zsh

## Static Definitions

# a string to check for on the SecureDrop homepage (HTML)
STRNG="<title>SecureDrop | Protecting Journalists and Sources</title>"

# the heart of the notification message to send
MESSAGE="SecureDrop instance unavailable"


## Configure the Onion address for the SecureDrop instance we're checking

if [ -e ./private/onions.sh ] ; then
    source ./private/onions.sh
  fi

if [ -z $ONION ] ; then
    ONION=$1
  fi

if [ -z $ONION ] ; then
    >&2 echo "No Tor onion service address supplied. Please specify an address as the first command-line argument or in a config file."
    exit 1
  fi

if ! echo "$ONION" | egrep -q 'http:\/\/[a-z,0-9]{16}.onion' ; then
    >&2 echo "Invalid Tor onion service address supplied. Please speficy an address in the form \`http://xxxxxxxxxxxxxxxx.onion\`."
    exit 2
  fi
    

source pushmsg.sh   #provides pushmsg() function, reads $TITLE & $MSG


check () {
  if torify curl -s "${ONION}" | grep -q "${STRNG}" ; then
      exit 0
    elif [ $PUSH = "yes" ] ; then
      pushmsg
    fi
  }


TITLE="SecureDrop down?"
MSG="${MESSAGE} once at $(date --rfc-3339=seconds)."
PUSH=no
check

sleep 200

TITLE="SecureDrop down!"
MSG="${MESSAGE} twice over five minutes at $(date --rfc-3339=seconds)."
PUSH=no
check

sleep 1000

TITLE="SecureDrop definitely down?"
MSG="${MESSAGE} for twenty minutes at $(date --rfc-3339=seconds)."
PUSH=yes
check

exit 0
