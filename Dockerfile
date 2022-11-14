FROM ubuntu:22.04

USER root

ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN apt-get -y update
RUN apt-get -y install --no-install-recommends apt-utils \
    build-essential pkg-config wget curl zip bzip2 ca-certificates git

ENV CONDA_DIR=/opt/conda
ENV PATH /opt/conda/bin:$PATH
RUN set -x && \
    arch=$(uname -m) && \
    if [ "${arch}" = "x86_64" ]; then \
        arch="64"; \
    fi && \
    wget -qO /tmp/micromamba.tar.bz2 \
        "https://micromamba.snakepit.net/api/micromamba/linux-${arch}/latest" && \
    tar -xvjf /tmp/micromamba.tar.bz2 --strip-components=1 bin/micromamba && \
    rm /tmp/micromamba.tar.bz2 && \
    PYTHON_SPECIFIER="python=${PYTHON_VERSION%.*}" && \
    if [[ "${PYTHON_VERSION%.*}" == "default" ]]; then PYTHON_SPECIFIER="python"; fi && \
    ./micromamba install \
        --root-prefix="${CONDA_DIR}" \
        --prefix="${CONDA_DIR}" \
        --yes \
        "${PYTHON_SPECIFIER}" \
        'mamba' \
        -c conda-forge && \
    rm micromamba && \
    mamba list python | grep '^python ' | tr -s ' ' | cut -d ' ' -f 1,2 >> "${CONDA_DIR}/conda-meta/pinned"

RUN mamba update -y -n base conda --all
RUN mamba install -y --quiet -c conda-forge numpy
RUN mamba clean --all -f -y

RUN apt-get install -y language-pack-ko fonts-nanum* && \
    localedef -cvi ko_KR -f UTF-8 ko_KR.utf8; localedef -f UTF-8 -i ko_KR ko_KR.UTF-8
RUN apt-get -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install --no-cache pyvespa voila matplotlib folium basemap jupyterlab ipywidgets

RUN pip install git+https://github.com/surrynet/hubs_voila.git

COPY *.ipynb /
