#!/bin/sh

PGDATA=/tmp/data
rm -rf $PGDATA
initdb -D $PGDATA
postgres -D $PGDATA -c listen_addresses='' -k /tmp &
redis-server &
bundle exec rails db:setup
bundle exec foreman start

