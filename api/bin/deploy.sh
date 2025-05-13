#!/bin/bash

# Check required vars
if [ -z "$APP_RELEASE" ]; then
  echo "APP_RELEASE not set. Skipping Honeybadger deploy notification."
  exit 0
fi

if [ -z "$RAILS_ENV" ]; then
  echo "RAILS_ENV not set. Defaulting to 'production'."
  RAILS_ENV="production"
fi

echo "Notifying Honeybadger of deploy:"
echo "Environment: $RAILS_ENV"
echo "Release: $APP_RELEASE"

bundle exec honeybadger deploy \
  --environment="$RAILS_ENV" \
  --revision="$APP_RELEASE" \
  --repository="https://github.com/fruitcakecreative/movement-parties" \
  --user="$(whoami)"
