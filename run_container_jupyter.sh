#!/usr/bin/env sh

CONTAINER_EXEC=`dirname $0`/containerexec_link


EXTERNALPORT=${1:-8888}

echo "You may need to use one of these ip addresses depending on how your container network is set up:"
ip addr
echo "Regardless of what the log below says, the port to connect to is: $EXTERNALPORT\n"
echo "" # blank line to make the above a bit more prominent

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
           --mount type=bind,source="$(pwd)"/content,target=/containerapp/content \
           --mount type=bind,source=/mnt/extdata/m31_jwst_data/MAST_2022-08-24T1111,target=/containerapp/content/MAST_2022-08-24T1111 \
           --mount type=bind,source=/mnt/extdata/m31_jwst_data/mastDownload,target=/containerapp/content/mastDownload \
           --mount type=bind,source=/mnt/extdata/crds_cache,target=/containerapp/content/crds_cache \
           -p $EXTERNALPORT:8888 \
           m31_jwst_2609 \
           "jupyter lab  --ip=\"0.0.0.0\" --notebook-dir=\"content\" --LabApp.user_settings_dir=\"content/.jupyter_config/user-settings\" --LabApp.workspaces_dir=\"content/.jupyter_config/workspaces\" --allow-root"

if [ $? -eq 126 ]
then
  echo "If the failure above was due to a port not being available, try explicitly requesting a free port like \"./run_container_jupyter 8899\""
fi
