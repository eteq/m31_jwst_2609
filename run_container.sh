#!/usr/bin/env sh

CONTAINER_EXEC=`dirname $0`/containerexec_link

$CONTAINER_EXEC run -it --rm --privileged --gpus all \
           -e HOST_UID="$(id -u)" \
           -e HOST_GID="$(id -g)" \
           --mount type=bind,source="$(pwd)"/content,target=/containerapp/content \
           `cat extramounts` \
           m31_jwst_2609 "$@"