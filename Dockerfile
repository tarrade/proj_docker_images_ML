# use centos for our image to mimic BigBox
FROM centos:6.9

# define the language
ENV LANG=en_US.UTF-8

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
RUN /opt/rh/devtoolset-2/root/usr/bin/gcc --version

# set the path
ENV PATH /opt/rh/devtoolset-2/root/usr/bin:$PATH

# adding libraries when needed
#RUN yum -y install g++
#RUN yum -y install libfreetype6-dev
#RUN yum -y install libpng12-dev
#RUN yum -y install libzmq3-dev
#RUN yum -y install pkg-config
#RUN yum -y install rsync
#RUN yum -y install software-properties-common

# removing list
#RUN rm -rf /var/lib/apt/lists/*


#RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
#    wget --quiet https://repo.continuum.io/archive/Anaconda3-4.1.1-Linux-x86_64.sh -O ~/anaconda.sh && \
#    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#    rm ~/anaconda.sh
#ENV PATH /opt/conda/bin:$PATH


# Anaconda installation
RUN wget https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh && \
    /bin/bash Anaconda3-5.0.1-Linux-x86_64.sh -b -p /opt/conda && \
    rm Anaconda3-5.0.1-Linux-x86_64.sh

# seting the path
ENV PATH /opt/conda/bin:$PATH

# defined channels for conda
RUN conda config --add channels conda-forge
RUN conda config --add channels defaults

#adding the config file in the docker image
ADD environment.yml environment.yml

# checking that the file is now present
RUN ls -la

# install extra conda packages
#RUN conda create -n env_py35 numpy pandas scikit-learn matplotlib tensorflow pyarrow plotly python=3.5

#RUN conda create -n env_py35 anaconda python=3.5
RUN conda env create -f=environment.yml -n env_py35
#RUN conda env create

RUN source activate env_py35 && \
	which python && \
	##git clone --recursive https://github.com/dmlc/xgboost.git && \
	##cd xgboost && make -j4 && cd python-package && python setup.py install && \
	#conda install xgboost  && \
	#conda install pyarrow && \
	#conda install plotly && \
	#conda install eli5 && \
	#conda install tensorflow && \
    #conda install numpy && \
    #conda install tensorflow && \
    #conda install pandas && \
    #conda install scikit-learn  && \
    #conda install matplotlib && \
	source deactivate env_py35

RUN conda create -n env_ds_bigbox --clone env_py35 --offline && \
    cd /opt/conda/envs/ && \
    zip env_ds_bigbox.zip env_ds_bigbox && \
    cd /
    #tar -cvzf /opt/conda/envs/env_ds_bigbox.tar.gz /opt/conda/envs/env_ds_bigbox/

# activate the env_ds_bigbox environment
ENV PATH /opt/conda/envs/env_ds_bigbox/bin:$PATH

# copy the env in a folder which is mounted on an external folder
#CMD /bin/mv /opt/conda/envs/env_ds_bigbox.tar.gz /extracted_kernel/
CMD /bin/mv /opt/conda/envs/env_ds_bigbox.zip /extracted_kernel/

# remove pkgs if not needed: to be checked
RUN rm -rf /opt/conda/pkgs/*

# checking path and env
RUN echo $PATH
RUN conda env list

