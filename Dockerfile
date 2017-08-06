FROM gargron/mastodon:v1.5.0

ENV VERSION 1.5.0

COPY create_admin.rb /mastodon/create_admin.rb

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
