FROM registry.centos.org/datamodel/gremlin:concaf

MAINTAINER Shubham <shubham@linux.com>

ENV SERVER_DIR=/opt/dynamodb/dynamodb-titan-storage-backend/server/dynamodb-titan100-storage-backend-1.0.0-hadoop1

RUN yum -y install epel-release &&\
    yum -y install python-pip ipython nss_wrapper gettext &&\
    yum clean all &&\
    pip install gremlinrestclient gremlinpython

COPY scripts/entrypoint-client.sh /bin/entrypoint.sh
COPY scripts/passwd.template /tmp/

RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
