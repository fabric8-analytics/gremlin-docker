FROM registry.centos.org/datamodel/centos-java:concaf

MAINTAINER Shubham <shubham@linux.com>

EXPOSE 8182

RUN yum -y install git zip unzip &&\
		yum clean all

# Prep, build and install DynamoDB storage backend driver with support for titan, and install Gremlin server
RUN git clone https://github.com/awslabs/dynamodb-titan-storage-backend.git /opt/dynamodb/dynamodb-titan-storage-backend/ &&\
    cd /opt/dynamodb/dynamodb-titan-storage-backend/ &&\
    mvn install &&\
    src/test/resources/install-gremlin-server.sh

WORKDIR /opt/dynamodb/

# Install Gremlin Python
RUN mkdir -p /root/.m2/repository/org/slf4j/slf4j-api/1.7.21/ &&\
    cd dynamodb-titan-storage-backend/server/dynamodb-titan100-storage-backend-1.0.0-hadoop1 &&\
    curl -o /root/.m2/repository/org/slf4j/slf4j-api/1.7.21/slf4j-api-1.7.21.jar http://central.maven.org/maven2/org/slf4j/slf4j-api/1.7.21/slf4j-api-1.7.21.jar &&\
    bin/gremlin-server.sh -i org.apache.tinkerpop gremlin-python 3.2.3

ADD scripts/entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh &&\
    chgrp -R 0 /opt/dynamodb/ &&\
    chmod -R g+rw /opt/dynamodb/ &&\
    find /opt/dynamodb/ -type d -exec chmod g+x {} +

ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ${dynamodb_class_name} ${dynamodb_constructor_args}
