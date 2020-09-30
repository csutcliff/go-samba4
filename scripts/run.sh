#!/bin/bash

# exec custom command
if [[ $# -gt 0 ]] ; then
        exec "$@"
        exit
fi

exec /usr/bin/supervisord -c /etc/supervisord.conf
