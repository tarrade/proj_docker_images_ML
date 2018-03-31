# proj_docker_images_ML
Create docker images based on centos 6.9 to emulate an hedge node rhel 6.9 Linux server of an Hadoop Data Lake.
An python env with all the needed Machine Learning, Deep Learning, NLP and Visualization is created using conda.
This env is then extracted and can be moved on the hege to be used in a kernel with JupyterHub or deployed on the node of the Hadoop cluster.

# How to build and install a env from  a local machine to a distant Linux server without Internet
## On your local computer with Docker installed and with an Internet connection
First update the environment.yml with you favorite python packages for Machine Learning, Deep Learning and Data Science

First build the docker image
```docker build .```
or
```docker build -t docker-anaconda-env .```

Then run the docker image and copy zipped env in `/Users/tarrade/docker/extracted_kernel/`
```docker run -v /Users/tarrade/docker/extracted_kernel/:/extracted_kernel  -t docker-anaconda-env```

## On your server (without access to internet)
```
PATH=/opt/cloudera/extras/anaconda3/bin:$PATH
```

# How to use Docker
## build a docker image
```docker build -t docker-anaconda-env .```

## see the docker containers
```docker ps```

## see the docker images
```docker images```

## save the image as a tar.gz file
```docker save docker-anaconda-env | gzip > docker-anaconda-env.tar.gz```

## kill a container
```docker kill e25b13246d27```

## rmi command to delete an image
```docker rmi -f 77af5f8975f2```

## extract a file from a running container
```docker cp e25b13246d27:/root/anaconda3/pkgs/. pkgs```

## run an docker image
```docker run -i -t docker-anaconda-env  /bin/bash```

## clean up useless stuff
```docker rm $(docker ps -a -q)```
```docker rmi $(docker images -f "dangling=true" -q)```

## to exist from a container (from Mac at least)
```exit```

