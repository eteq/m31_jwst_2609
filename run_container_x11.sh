#!/usr/bin/env sh

CONTAINER_EXEC=`dirname $0`/containerexec_link

$CONTAINER_EXEC run -it --rm --privileged --gpus all \
           -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -v $HOME/.Xauthority:$HOME/.Xauthority \
           -e HOST_UID="$(id -u)" \
           -e HOST_GID="$(id -g)" \
           --mount type=bind,source="$(pwd)"/content,target=/containerapp/content \
           --mount type=bind,source=/mnt/extdata/m31_jwst_data/MAST_2022-08-24T1111,target=/containerapp/content/MAST_2022-08-24T1111 \
           --mount type=bind,source=/mnt/extdata/m31_jwst_data/mastDownload,target=/containerapp/content/mastDownload \
           --mount type=bind,source=/mnt/extdata/crds_cache,target=/containerapp/content/crds_cache \
           m31_jwst_2609 "$@"
