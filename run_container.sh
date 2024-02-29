#!/usr/bin/env sh

CONTAINER_EXEC=`dirname $0`/containerexec_link

if [ -z "$GPUS" ]
then
	GPUS_OPTION=""
else
	GPUS_OPTION="--gpus $GPUS"
fi
$CONTAINER_EXEC run -it --rm --privileged $GPUS_OPTION \
           -e HOST_UID="$(id -u)" \
           -e HOST_GID="$(id -g)" \
           -e PYDEVD_DISABLE_FILE_VALIDATION=1 \
           -e MAST_TOKEN=`cat ~/.mast_token` \
           -e CUPY_CACHE_DIR=/containerapp/content/cupy_cache \
           --mount type=bind,source="$(pwd)"/content,target=/containerapp/content \
           `cat extramounts` \
           m31_jwst_2609 "$@"
