#! /bin/sh

./docker/script/rm_server_pid.sh
RAILS_SERVE_STATIC_FILES=1 bundle exec rails server --environment production --port $RAILS_PORT --binding 0.0.0.0
