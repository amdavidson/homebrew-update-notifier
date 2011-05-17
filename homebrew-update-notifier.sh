#!/bin/bash
#
# Notify of Homebrew updates via Growl on Mac OS X
#
# Original Author: Chris Streeter http://www.chrisstreeter.com
# Original Homepage: https://github.com/streeter/dotfiles/blob/master/bin/port-update-notifier
#
# Ported to Homebrew by: Andrew Davidson http://amdavidson.com
# Homepage: http://github.com/amdavidson/homebrew-update-notifier
#
# Requires: Growl Notify Extra to be installed (but fails gracefully). Info
#       about how to get the extra is at http://growl.info/extras.php


TERM_APP='/Applications/Utilities/Terminal.app'
BREW_EXEC='$HOME/.homebrew/bin/brew'
GROWL_NOTIFY='/usr/local/bin/growlnotify'
GROWL_TITLE="Homebrew Update(s) Available"
GROWL_ARGS="-n 'MacPorts' -d $GROWL_NOTIFY -a $BREW_EXEC"

$BREW_EXEC update 2>&1 > /dev/null
outdated=`$BREW_EXEC outdated`

if [ -z "$outdated" ] ; then
    if [ -e $GROWL_NOTIFY ]; then
        # No updates available
        $GROWL_NOTIFY $GROWL_ARGS -m '' -t "No Homebrew Updates Available"
    fi
else
    # We've got an outdated port or two
    
    # Nofity via growl
    if [ -e $GROWL_NOTIFY ]; then
        lc=$((`echo "$outdated" | wc -l` - 1))
        outdated=`echo "$outdated" | tail -$lc | cut -d " " -f 1`
        message=`echo "$outdated" | head -5`
        if [ "$outdated" != "$message" ]; then
            message="Some of the outdated packages are:
$message"
        else
            message="The following packages are outdated:
$message"
        fi
        # Send to growlnotify
        echo "$message" | $GROWL_NOTIFY $GROWL_ARGS -t $GROWL_TITLE
    fi
fi
