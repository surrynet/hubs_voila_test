FROM buildpack-deps:bionic

# avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install --no-install-recommends apt-utils iputils-ping \
    build-essential sudo cmake pkg-config libjpeg-dev libpng-dev ffmpeg libavcodec-dev \
    libavformat-dev libswscale-dev libxvidcore-dev libx264-dev libxine2-dev \
    libv4l-dev v4l-utils libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk-3-dev \
    mesa-utils libgl1-mesa-dri libgtkgl2.0-dev libgtkglext1-dev libatlas-base-dev gfortran libeigen3-dev \
    libleptonica-dev libtesseract-dev tesseract-ocr tesseract-ocr-kor tesseract-ocr-eng \
    unixodbc unixodbc-dev r-cran-rodbc \
    git vim netcat rsync tree psmisc \
    nfs-common netbase swig libboost-all-dev xvfb python3-opengl \
    libsasl2-dev libsasl2-2 libsasl2-modules-gssapi-mit \
    ldap-utils postgresql-client mysql-client

RUN conda update -y -n base conda --all
RUN conda install -y --quiet numpy opencv scijava-jupyter-kernel \
    nb_conda_kernels pyglet pyvirtualdisplay implicit jupyterlab_execute_time python-graphviz pydot
RUN conda clean --all -f -y

RUN apt-get install -y language-pack-ko fonts-nanum* && \
    localedef -cvi ko_KR -f UTF-8 ko_KR.utf8; localedef -f UTF-8 -i ko_KR ko_KR.UTF-8
RUN apt-get -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN python3 -m pip install --no-cache \
    flake8 pylint \
    hdfs xgboost shap jupyter-c-kernel \
    voila voila-gridstack voila-vuetify ipyvuetify bqplot \
    matplotlib ipympl ipycanvas \
    sklearn tensorflow glmnet pytesseract opencv-python-headless \
    mysql-connector-python pyspark sasl thrift thrift-sasl PyHive PyHBase pydruid psycopg2-binary graphviz \
    vaex modin tqdm lightgbm ldap3 bayesian-optimization \
    pyvespa geopandas folium pycountry pgeocode geopy basemap \
    sphinx boto3 apache-airflow==2.3.0 onnx tf2onnx \
    jupyterlab-git jupyterlab_hdf

RUN python3 -m pip install git+https://github.com/surrynet/hubs_voila.git

