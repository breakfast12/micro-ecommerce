#!/bin/bash

APP_PORT=${PORT:-8000}
WORKERS=${WORKERS:-2}
TIMEOUT=${TIMEOUT:-300}
LOG_LEVEL=${LOG_LEVEL:-info}

source /opt/venv/bin/activate

cd /app/

if [ "$ENV" == "development" ]; then
    gunicorn --reload cfehome.wsgi:application \
        --workers $WORKERS \
        --timeout $TIMEOUT \
        --log-level $LOG_LEVEL \
        --bind 0.0.0.0:$APP_PORT
else
    gunicorn cfehome.wsgi:application \
        --workers $WORKERS \
        --timeout $TIMEOUT \
        --log-level $LOG_LEVEL \
        --bind 0.0.0.0:$APP_PORT
fi

