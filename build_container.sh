#!/usr/bin/env sh

CONTAINER_EXEC=`dirname $0`/containerexec_link

$CONTAINER_EXEC build -t m31_jwst_2609:latest . "$@"
