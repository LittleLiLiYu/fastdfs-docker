# centos 7
FROM centos:7

LABEL maintainer "littelliliadam@gmail.com"


ENV FASTDFS_PATH=/usr/local/src \
    FASTDFS_BASE_PATH=/home/dfs \
    FASTDFS_NAME=fastdfs-6.04 \
    LIBFAST_COMMON_NAME=libfastcommon-1.0.42 \
    FASTDFS_NGINX_NAME=fastdfs-nginx-module-1.22 \
    NGINX_NAME=nginx-1.16.1

# add profiles
ADD conf/client.conf /etc/fdfs/
ADD conf/http.conf /etc/fdfs/
ADD conf/mime.types /etc/fdfs/
ADD conf/storage.conf /etc/fdfs/
ADD conf/tracker.conf /etc/fdfs/
ADD fastdfs.sh /home
ADD conf/nginx.conf /etc/fdfs/
ADD conf/mod_fastdfs.conf /etc/fdfs/

# add source code
ADD source/${LIBFAST_COMMON_NAME}.tar.gz ${FASTDFS_PATH}
ADD source/${FASTDFS_NAME}.tar.gz ${FASTDFS_PATH}
ADD source/${FASTDFS_NGINX_NAME}.tar.gz ${FASTDFS_PATH}
ADD source/${NGINX_NAME}.tar.gz ${FASTDFS_PATH}

# get all the dependences
RUN yum install gcc gcc-c++ make libtool pcre pcre-devel zlib zlib-devel openssl-devel -y 

# create the dirs
RUN mkdir -p ${FASTDFS_BASE_PATH} \
 && mkdir -p ${FASTDFS_BASE_PATH}/data \
 && mkdir -p ${FASTDFS_BASE_PATH}/storage \
 && mkdir -p ${FASTDFS_BASE_PATH}/tracker \
 && mkdir -p ${FASTDFS_BASE_PATH}/client

# compile the libfastcommon
WORKDIR ${FASTDFS_PATH}/${LIBFAST_COMMON_NAME}

RUN ./make.sh \
 && ./make.sh install \
 && rm -rf ${FASTDFS_PATH}/${LIBFAST_COMMON_NAME}

# compile the fastdfs
WORKDIR ${FASTDFS_PATH}/${FASTDFS_NAME}

RUN ./make.sh \
 && ./make.sh install \
 && rm -rf ${FASTDFS_PATH}/${FASTDFS_NAME}
 
# compile the nginx
WORKDIR ${FASTDFS_PATH}/${NGINX_NAME}

RUN ./configure --add-module=${FASTDFS_PATH}/${FASTDFS_NGINX_NAME}/src/   \
 && make \
 && make install \
 && rm -rf ${FASTDFS_PATH}/${NGINX_NAME} \
 && rm -rf ${FASTDFS_PATH}/${FASTDFS_NGINX_NAME}
 
# make the fastdfs.sh executable 
RUN chmod +x /home/fastdfs.sh

# export config
VOLUME /etc/fdfs


EXPOSE 22122 23000 8888 80
ENTRYPOINT ["/home/fastdfs.sh"]
