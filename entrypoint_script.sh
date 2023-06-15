#!/bin/bash

# from https://www.joyfulbikeshedding.com/blog/2021-03-15-docker-and-the-host-filesystem-owner-matching-problem.html

set -e

# skip the username wrangling if we are in podman and the user doesn't ask to override
if [[ $container == "podman" && -z "$IGNORE_PODMAN_IN_ENTRYPOINT" ]]; then
    echo "Detected podman, assuming rootless. Skipping user setup - if this is not what you wanted, set the IGNORE_PODMAN_IN_ENTRYPOINT environment variable when starting the container."
    stay_root=true
fi


if [[ -z "$HOST_UID" ]]; then
    echo "No HOST_UID, remaining root" >&2
    stay_root=true
fi
if [[ -z "$HOST_GID" ]]; then
    echo "No HOST_GID, remaining root" >&2
    stay_root=true
fi


if [ "$stay_root" = true ] ; then
    cd $HOME
else
    addgroup --gid "$HOST_GID" matchinguser
    adduser --uid "$HOST_UID" --gid "$HOST_GID" --gecos "" --disabled-password m31_jwst_2609er
    cd /home/m31_jwst_2609er
fi

ln -s /containerapp/content

if [ "$1" = "bashroot" ] ; then
    # if first argument is bashroot, go to shell as root even if the user is set up
    bash
else
    if [ "$stay_root" = true ] ; then
        exec "$@"
    else
        # Drop privileges and execute next container command in bash, or 'bash' if not specified. 
        export HOME=/home/m31_jwst_2609er
	if [[ $# -gt 0 ]]; then
            exec sudo -E -u m31_jwst_2609er -- bash -c "$@"
        else
            exec sudo -E -u m31_jwst_2609er -- bash
        fi
    fi
fi
