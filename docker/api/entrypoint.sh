#!/bin/sh
mkdir -p $HOME


if [ ! -f /etc/rails-first-run ]; then
  touch /etc/rails-first-run

  echo "Executing bin/setup"
  /app/bin/setup --skip-db-create
fi

if [ -f /app/tmp/pids/server.pid ]; then
  rm -f /app/tmp/pids/server.pid
fi

exec "$@"
