#!/bin/sh
set -e

case "$*" in
    *rails*server*)
        if [ ! -e /mastodon/public/system/migrated-1 ]; then
            echo "initializing/updating Mastodon"
            touch /mastodon/public/system/migrated-1
            sleep 5
            #TODO - rake secret
            VERSION_BAK=$VERSION
            unset VERSION
            rake db:migrate
            rake assets:precompile
            export VERSION=$VERSION_BAK
        fi
        ;;
esac

exec "$@"
