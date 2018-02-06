#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

function wait_for_db {
  sleep 3

  while [[ $(pg_isready -h "${POSTGRES_HOST}" \
           -U "${POSTGRES_USER}") = "no response" ]]; do
    echo "Waiting for postgresql to start..."
    sleep 1
  done
}

function development {
  cd /phylotastic-portal

  bundle exec rake db:drop
  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rake db:seeds
  bundle exec rails s -p 3000 -b '0.0.0.0'
}

function production {
  cd /app && npm run build && mkdir -p public
  cp -r ./dist/* ./public && rm -R ./dist/*

  bundle exec rake db:migrate
  bundle exec rails s -p 3000 -b '0.0.0.0'
}

if [[ ! ${POSTGRES_HOST:?Requires POSTGRES_HOST} \
   || ! ${POSTGRES_USER:?Requires POSTGRES_USER} ]]; then
  exit 1
fi

wait_for_db

if [[ ${RAILS_ENV} = "production" ]]; then production; else development; fi
