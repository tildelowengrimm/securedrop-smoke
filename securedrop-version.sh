#! /bin/zsh

TMPFILE="/tmp/securedrop-version"

source pushmsg.sh   #provides pushmsg() function, reads $1 as message, $2 as title
source slackmsg.sh  #provides slackmsg() function, reads $1 as message

notify () {
  pushmsg $1 $2
  slackmsg $1
  }

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


get-version() {
  PAGE=$( torify curl -s "${ONION}" )
  if ! echo "$PAGE" | egrep -q "Powered by SecureDrop [0-9].[0-9].[0-9]" ; then
      echo "Problem getting SecureDrop version."
      exit 2
    else
      VERSION_NEW=$( echo "$PAGE" | grep -Po "(?<=Powered by SecureDrop )[0-9].[0-9].[0-9]" )
    fi
#  }
#
#write-version() {
#  if ! echo "$VERSION_NEW" | egrep -q "[0-9].[0-9].[0-9]" ; then
#    echo "Invalid version to write."
#    exit 4
#    fi
  if ! echo "$VERSION_NEW" > "$TMPFILE" ; then
    echo "Unable to write to \`""$TMPFILE""\` ."
    exit 1
    fi
  }


if [[ -e "$TMPFILE" ]] ; then
    VERSION_OLD=$( cat "$TMPFILE" )
    if ! echo "$VERSION_OLD" | egrep -q "[0-9].[0-9].[0-9]" ; then
      get-version
      exit 0
      fi
  else
    get-version
    exit 0
  fi

get-version

if [[ ! "$VERSION_OLD" == "$VERSION_NEW" ]] ; then
    notify "The SecureDrop instance at <$ONION> has changed version from $VERSION_OLD to $VERSION_NEW." "SecureDrop version change: $VERSION_OLD to $VERSION_NEW"
  fi

exit 0
