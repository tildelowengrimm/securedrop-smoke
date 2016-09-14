#! /bin/zsh

source private/pushover-creds.sh   #should define $APPKEY and $USRKEY

MSG="$1"

pushmsg () {
  torify curl -s \
    --form-string "token=$APPKEY" \
    --form-string "user=$USRKEY" \
    --form-string "title=$2" \
    --form-string "message=$1" \
    https://api.pushover.net/1/messages.json > /dev/null
  }
