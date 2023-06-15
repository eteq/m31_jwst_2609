FROM python:3 AS stage1

WORKDIR /root

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=type=cache,target=/var/cache/apt \
    /bin/sh -c set -ex; apt-get update; apt-get install -y --no-install-recommends sudo software-properties-common espeak

#RUN curl https://static.rust-lang.org/dist/rust-1.67.1-x86_64-unknown-linux-gnu.tar.gz -sSf | tar xzf - && rust-1.67.1-x86_64-unknown-linux-gnu/install.sh && rm -rf rust-*-x86_64-unknown-linux-gnu
#RUN cargo install cargo-edit

WORKDIR /containerapp

RUN wget --content-disposition https://stsci.box.com/shared/static/t90gqazqs82d8nh25249oq1obbjfstq8.gz; tar xzf webbpsf-data*.tar.gz;chmod -R a+r /containerapp/webbpsf-data; rm webbpsf-data*.tar.gz
ENV WEBBPSF_PATH=/containerapp/webbpsf-data

# CUDA
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    wget https://developer.download.nvidia.com/compute/cuda/repos/debian11/x86_64/cuda-keyring_1.0-1_all.deb;  dpkg -i cuda-keyring_1.0-1_all.deb; add-apt-repository contrib; apt-get update; apt-get -y install cuda-compiler-12-1 cuda-command-line-tools-12-1 cuda-nsight-compute-12-1 cuda-libraries-dev-12-1


COPY astrocontainer_requirements.txt ./
RUN --mount=type=cache,target=/root/.cache pip install --upgrade pip
RUN --mount=type=cache,target=/root/.cache pip install -r astrocontainer_requirements.txt

#RUN --mount=type=cache,target=/root/.cache pip install maturin
#RUN --mount=type=cache,target=/root/.cache curl -sSfL https://github.com/emakryo/rustdef/archive/refs/tags/v0.4.0.tar.gz | tar xzf - && cd rustdef-0.4.0 && maturin build && pip install target/wheels/rustdef-0.4.0-*.whl && cd ..

COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache pip install -r requirements.txt

# separate from the requirements because it depdns on the cuda build above
RUN --mount=type=cache,target=/root/.cache pip install cupy-cuda12x

# for jupyter
EXPOSE 8888 

COPY entrypoint_script.sh /containerapp/
ENTRYPOINT ["/containerapp/entrypoint_script.sh"]

CMD [ "python" ]
