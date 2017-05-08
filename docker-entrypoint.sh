#!/bin/sh
set -e

if [ ! -e /mastodon/private/secret ]; then
    touch /mastodon/private/secret
    rake secret > /mastodon/private/secret
fi

SECRET=`cat /mastodon/private/secret`

export PAPERCLIP_SECRET=$SECRET
export SECRET_KEY_BASE=$SECRET
export OTP_SECRET=$SECRET

case "$*" in
    *rails*server*)
        if [ ! -e /mastodon/private/migrated-1 ]; then
            touch /mastodon/private/migrated-1
            echo "initializing/updating Mastodon"
            sleep 5
            
            VERSION_BAK=$VERSION
            unset VERSION
            rake db:migrate
            export VERSION=$VERSION_BAK
            
            rake assets:precompile

        fi
        ;;
esac
            rails runner /mastodon/create_admin.rb

exec "$@"
