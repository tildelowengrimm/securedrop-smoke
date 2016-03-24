#! /bin/sh

pushmsg () {
  torify curl -s \
    --form-string "token=$APPKEY" \
    --form-string "user=$USRKEY" \
    --form-string "title=$TITLE" \
    --form-string "message=$MSG" \
    https://api.pushover.net/1/messages.json > /dev/null
  }

