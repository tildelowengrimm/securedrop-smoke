SecureDrop Smoke
===============

A simple script to casually check your SecureDrop repo and send you Pushover notifications if it's like for sure definitely down and not just like maybe Tor's being flakey.

Step one
--------

Clone this repo


Step two
--------

Create a file called `private/pushover-creds.sh` and set the $APPKEY and $USRKEY variables with the ones you'd like to use.

Step three
----------

Do the thing:
```
securedrop-smoke.sh 'http://youronionaddress.onion'
```

Over the course of twenty minutes, the script will check on your SecureDrop's onion address a couple of times. If your site spends long enough not being there, you'll get a Pushover notification.

Step four
---------

What are you, a robot? Automate this: put something along these lines in your crontab.

```
*/20 * * * *      /path/to/your/securedrop-smoke.sh 'http://thisonesecuredropinstance.onion'
*/20 * * * *      /path/to/your/securedrop-smoke.sh 'http://someothersecuredrop.onion'
*/20 * * * *      /path/to/your/securedrop-smoke.sh 'http://therealquestioniswhyyourerunningsomanysecuredrops.onion
```

