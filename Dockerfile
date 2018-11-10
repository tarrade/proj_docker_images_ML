# use centos for our image to mimic BigBox
FROM centos:6.9

# define the language
ENV LANG=en_US.UTF-8

# check libc version
RUN ldd --version

# adding libraries to download linux/anaconda packages packages
RUN yum install -y bzip2\
    wget unzip \
    ca-certificates \
    which \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    zip \
    tar \
    cyrus-sasl-devel \
    curl \
    git \
    mercurial \
    subversion \
    scl \
    git;\
    yum clean all

# get new compiler
RUN wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
RUN yum install -y devtoolset-2-gcc devtoolset-2-binutils ; yum clean all
RUN yum install -y devtoolset-2-gcc-c++ devtoolset-2-gcc-gfortran ; yum clean all
RUN yum -y install python-pip; yum clean all
RUN /opt/rh/devtoolset-2/root/usr/bin/gcc --version

# set the path
ENV PATH /opt/rh/devtoolset-2/root/usr/bin:$PATH

# Anaconda installation
RUN wget https://repo.continuum.io/archive/Anaconda3-5.3.0-Linux-x86_64.sh && \
    /bin/bash Anaconda3-5.3.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm Anaconda3-5.3.0-Linux-x86_64.sh

# seting the path
ENV PATH /opt/conda/bin:$PATH

# defined channels for conda
RUN conda config --append channels defaults
RUN conda config --append channels conda-forge
RUN conda config --get channels

#adding the config file in the docker image
ADD environment.yml environment.yml

# checking that the file is now present
RUN ls -la

# update conda
RUN conda update -n base conda -y

# tricks to be removed
#RUN pip install --upgrade pip msgpack PyHamcrest==1.9.0
#conda install arrow-cpp -c conda-forge && \

# install extra conda packages
RUN conda env create -f=environment.yml -n env_ds_bigbox

RUN source activate env_ds_bigbox && \
	which python && \
	conda list && \
	conda-pack -n env_ds_bigbox -o env_ds_bigbox.tar.gz && \
	ls -la && \
	source deactivate env_ds_bigbox

# activate the env_ds_bigbox environment
ENV PATH /opt/conda/envs/env_ds_bigbox/bin:$PATH

# copy the env in a folder which is mounted on an external folder
CMD /bin/mv env_ds_bigbox.tar.gz /extracted_kernel/

# clean all downloaded packages
RUN conda clean -a -y

# remove pkgs if not needed: to be checked
RUN rm -rf /opt/conda/pkgs/*

# old method
#RUN source activate env_py35 && \
#	which python && \
#	conda list && \
#	ls -la && \
#	source deactivate env_py35

#RUN conda create -n env_ds_bigbox --clone env_py35 --offline && \
#    cd /opt/conda/envs/ && \
#    ls -la && \
#    zip -r env_ds_bigbox.zip env_ds_bigbox && \
#    cd / \
#    ls -la

# activate the env_ds_bigbox environment
#ENV PATH /opt/conda/envs/env_ds_bigbox/bin:$PATH

# copy the env in a folder which is mounted on an external folder
#CMD /bin/mv /opt/conda/envs/env_ds_bigbox.zip /extracted_kernel/
#CMD /bin/mv /opt/conda/envs/env_ds_bigbox.tar.zip /extracted_kernel/

# remove pkgs if not needed: to be checked
#RUN rm -rf /opt/conda/pkgs/*

# checking path and env
#RUN echo $PATH
#RUN conda env list
#RUN ls -la
