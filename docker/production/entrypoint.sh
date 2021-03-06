#!/bin/bash
set -e

echo "Creating database..."
bundle exec rake db:create > /dev/null 2>&1 || true

echo "Migrating database..."
bundle exec rake db:migrate

echo "Removing server pid if exists..."
rm -f /app/tmp/pids/server.pid

echo "Done. Running $@..."
exec "$@"
