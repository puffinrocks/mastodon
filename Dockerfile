FROM gargron/mastodon:v1.3.3

ENV VERSION 1.3.3

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
