FROM centos:7
LABEL maintainer "DI GREGORIO Nicolas <nicolas.digregorio@gmail.com>"

### Environment variables
ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US.UTF-8' \
    TERM='xterm' 

### Install Application
RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y git \
                   gcc \
                   gcc-c++ \
                   python-devel \
                   python2-pip \
                   openssl-devel \
                   make \
                   && \
    git clone --depth 1 https://github.com/ncopa/su-exec /tmp/su-exec && \
    cd /tmp/su-exec && \
    make && \
    cp /tmp/su-exec/su-exec /usr/local/bin/su-exec && \
    pip --no-cache-dir install --upgrade pyopenssl cheetah requirements && \
    git clone --depth 1 https://github.com/CouchPotato/CouchPotatoServer/ /opt/couchpotato && \
    yum history -y undo last && \
    yum install -y ca-certificates \
                   python \
                   libxml2-python \
                   python-lxml \
                   unrar \
                   git \
                   && \
    yum clean all && \
    rm -rf /opt/couchpotato/.git* \
           /tmp/* \
           /var/cache/yum/* \
           /var/tmp/*

### Volume
VOLUME ["/config", "/downloads", "/movies"]

### Expose ports
EXPOSE 5050

### Running User: not used, managed by docker-entrypoint.sh
#USER couchpotato

### Start CouchPotato
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["couchpotato"]

