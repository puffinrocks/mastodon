#!/bin/sh
set -e

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
            
            rake secret > /mastodon/private/secret
            
            rake assets:precompile

            rails runner /mastodon/create_admin.rb
        fi
        ;;
esac

for i in `seq 1 120`; do
    if [ -e /mastodon/private/secret ]; then
        break
    fi
    sleep 1
done

SECRET=`cat /mastodon/private/secret`

export PAPERCLIP_SECRET=$SECRET
export SECRET_KEY_BASE=$SECRET
export OTP_SECRET=$SECRET

exec "$@"
