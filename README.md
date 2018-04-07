# proj_docker_images_ML
Create docker images based on centos 6.9 to emulate an hedge node rhel 6.9 Linux server of an Hadoop Data Lake.
An python env with all the needed Machine Learning, Deep Learning, NLP and Visualization is created using conda.
This env is then extracted and can be moved on the hege to be used in a kernel with JupyterHub or deployed on the node of the Hadoop cluster.

This docker image was created on a MacBookPro with Docker version 18.03.0

Note:
- using tornado=4.5.3 to avoid an issue with Jupyter kernel crashing !
  https://github.com/ipython/ipython/issues/11030

- One package is installed with pip: pip install sklearn

# How to build and install a env from  a local machine to a distant Linux server without Internet
## On your local computer with Docker installed and with an Internet connection
First update the environment.yml with you favorite python packages for Machine Learning, Deep Learning and Data Science

First build the docker image

```docker build .```

or

```docker build -t docker-anaconda-env .```

Then run the docker image and copy zipped env in `/Users/tarrade/docker/extracted_kernel/`

```docker run -v /Users/tarrade/docker/extracted_kernel/:/extracted_kernel  -t docker-anaconda-env```

## On your server (without access to internet), first be sure you have some local installation of anaconda
```
export PATH=/opt/cloudera/extras/anaconda3-4.1.1/bin:$PATH
unzip env_ds_bigbox.zip
mv env_ds_bigbox YOURPTHATH/envs/.
source activate env_ds_bigbox
```

# How to use Docker
## build a docker image
```docker build -t docker-anaconda-env .```

## run the docker image to you can see what is in it and check the list of python packages
```docker run -i -t docker-anaconda-env  /bin/bash```

### how to start and use Jupyter
```docker run -i -p 8888:8888 -t docker-anaconda-env  /bin/bash```
and in the docker image run:
```jupyter notebook --ip 0.0.0.0 --no-browser --allow-root```
then in a web browser and copy the url in a web browser like the one below:
```http://0.0.0.0:8888/?token=820bc0681fcc5467bb8c2e334fe1a783834ce990bda8b16f```

we can also find the url by running the following command:
```docker exec -it 91f13d4505b6 jupyter notebook list```

## run the docker image and mount the extracted_kernel folder to get the .zip env
```docker run -v /Users/tarrade/docker/extracted_kernel/:/extracted_kernel  -t docker-anaconda-env```

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

