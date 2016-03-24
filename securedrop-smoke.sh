#! /bin/sh +x


#SECUREDROP
ONION="http://nopenopenope.onion"
STRNG="<title>SecureDrop | Protecting Journalists and Sources</title>"

#PUSHOVER
APPKEY=nopenopenope
USRKEY=nopenopenope


MESSAGE="SecureDrop instance unavailable"


pushmsg () {
  torify curl -s \
    --form-string "token=$APPKEY" \
    --form-string "user=$USRKEY" \
    --form-string "title=$TITLE" \
    --form-string "message=$MSG" \
    https://api.pushover.net/1/messages.json > /dev/null
  }


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
