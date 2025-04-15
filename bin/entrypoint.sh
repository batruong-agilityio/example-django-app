#!/bin/bash

set -e
cmd="$@"

postgres_ready() {
python << END
import sys
from decouple import config
import psycopg2
try:
    conn = psycopg2.connect(
        dbname=config("DATABASE_NAME"),
        user=config("DATABASE_USER"),
        password=config("DATABASE_PASSWORD"),
        host=config("DATABASE_HOST"))

except psycopg2.OperationalError:
    sys.exit(-1)
sys.exit(0)
END
}

if [[ "$DATABASE_ENGINE" == "django.db.backends.postgresql" ]]; then
    # Waits for postgres server to go up
    until postgres_ready; do
    >&2 echo "Postgres is unavailable - sleeping - $DATABASE_HOST"
    sleep 2
    done
fi

# Runs database migration if DATABASE_MIGRATE flag is set
echo "Db Migrate: $DATABASE_MIGRATE"
if [[ "$DATABASE_MIGRATE" == "true" ]]; then
    ./bin/dj-migrate.sh
fi

echo "All ready"

exec $cmd
