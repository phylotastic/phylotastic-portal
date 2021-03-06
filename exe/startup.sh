#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function wait_for_db {
  sleep 3

  while [[ $(pg_isready -h "${PG_HOST}" \
           -U "${PG_USER}") = "no response" ]]; do
    echo "Waiting for postgresql to start..."
    sleep 1
  done
}

function development {
  cd /phylotastic-portal

  bundle exec rake db:drop
  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rake db:migrate RAILS_ENV=test
  
  rails s
}

function production {
  cd /app && npm run build && mkdir -p public
  cp -r ./dist/* ./public && rm -R ./dist/*

  bundle exec rake db:migrate
  rails s
}

echo "Running 1\n"

if [[ ! ${PG_HOST:?Requires PG_HOST} \
   || ! ${PG_USER:?Requires PG_USER} ]]; then
  exit 1
fi

echo "Running 2\n"

wait_for_db

if [[ ${RAILS_ENV} = "production" ]]; then production; else development; fi