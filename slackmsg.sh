#! /bin/zsh

source private/slack-creds.sh #should define $SLACKWEBHOOK

CONTEXT='{
    "username": "SecureDrop Overseer",
    "icon_url": "https://securedrop.org/sites/all/themes/securedrop/images/logo.png",
    "channel": "#tech_securedrop"
  }'

slackmsg () {
    PAYLOAD=$( jq .text=\""$1"\" <<< "$CONTEXT" )
    torify curl -X POST -H 'Content-type: application/json' --data "$PAYLOAD" "$SLACKWEBHOOK"  }
