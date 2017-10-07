#!/bin/sh
set -e

case "$*" in
    *rails*server*)
        if [ ! -e /mastodon/private/secret ]; then
            SECRET=`rake secret`
            echo $SECRET > /mastodon/private/secret
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

if [ "$LETSENCRYPT_HOST" == "" ]; then
    export LOCAL_HTTPS=false
else
    export LOCAL_HTTPS=true
fi

case "$*" in
    *rails*server*)
        if [ ! -e /mastodon/private/migrated-2 ]; then
            echo "initializing/updating Mastodon"
            sleep 5

            VERSION_BAK=$VERSION
            unset VERSION
            rake db:migrate
            export VERSION=$VERSION_BAK

            rake assets:precompile

            rails mastodon:maintenance:remove_deprecated_preview_cards

            rails runner /mastodon/create_admin.rb

            touch /mastodon/private/migrated-2
        fi
        ;;
esac

exec "$@"
