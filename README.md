# m31_jwst_2609

This is Erik Tollerud's analysis and reduction machinery for JWST Cycle 1 GO program  2609 "Searching for the Alpha-Abundance Bimodality in the M31 Disk".


To use this container:

1. update `requirements.txt` with known needed requirements
2. Run `./build_container.sh`
n. `./run_container*.sh` and work inside the container's home directory, which maps to the host's `content` directory. Run the previous steps whenever the requirements change.

If you are using jupyterlab and want to adjust its configuration you can put changes in the `content/.jupyter_config/user-settings` directory.
