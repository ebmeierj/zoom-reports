#!/bin/ash

/usr/bin/envsubst "$(for envVar in `env | cut -d '=' -f 1`; do echo -n "\$\$$envVar "; done;)" < $1 > $2
