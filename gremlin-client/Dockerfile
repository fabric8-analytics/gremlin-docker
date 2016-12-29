FROM registry.centos.org/datamodel/gremlin:concaf

MAINTAINER Shubham <shubham@linux.com>

ENV SERVER_DIR=/opt/dynamodb/dynamodb-titan-storage-backend/server/dynamodb-titan100-storage-backend-1.0.0-hadoop1\
    GREMLIN_HOST=gremlin

RUN yum -y install epel-release &&\
    yum -y install python-pip ipython nss_wrapper gettext &&\
    yum clean all &&\
    pip install gremlinrestclient gremlinpython

RUN sed -i.bckp 's#hosts: .*#hosts: ['$GREMLIN_HOST']#' "${SERVER_DIR}/conf/remote.yaml" &&\
    cd ${SERVER_DIR} &&\
    echo ":remote connect tinkerpop.server conf/remote.yaml" | bin/gremlin.sh 2>/dev/null

COPY scripts/entrypoint-client.sh /bin/entrypoint.sh
COPY scripts/passwd.template /tmp/

RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
