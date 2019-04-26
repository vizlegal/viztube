#!/bin/bash
set -e

if [[ "$VERBOSE" = "true" ]]; then
  set -x
fi

# Use local dir deps
if [[ "$LOCAL_DEV" = "true" ]]; then
  export MIX_HOME=$HOME/.mix
fi

if [ "$1" = 'test' ] || [ "$1" = 'tests' ]; then
  exec env MIX_ENV=test mix test --color --stale
fi

if [ "$1" = 'server' ]; then
  exec mix phx.server
fi

if [ "$1" = 'mix' ]; then
  "$@"
fi

if [ "$1" = 'foreground' ] || [ "$1" = 'remote_console' ]; then
  /app/bin/viztube_umbrella "$@"
fi

exec "$@"
