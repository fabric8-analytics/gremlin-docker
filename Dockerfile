FROM registry.centos.org/centos/centos:7

MAINTAINER Shubham <shubham@linux.com>

EXPOSE 8182

RUN yum -y install epel-release &&\
    yum -y install git zip unzip awscli &&\
    yum -y install java java-devel maven &&\
    yum -y install wget &&\
    yum clean all


ENV JAVA_HOME /usr/lib/jvm/java-openjdk
ENV M2_DIR=/m2
ENV M2_REPO=${M2_DIR}/repository
ENV MAVEN_OPTS="-Dmaven.repo.local=${M2_REPO}"


# Clone Janusgraph from a particular version and create jar
RUN git clone https://github.com/awslabs/dynamodb-janusgraph-storage-backend.git --branch jg0.2.0-1.2.0 /opt/dynamodb/dynamodb-janusgraph-storage-backend/ &&\
    cd /opt/dynamodb/dynamodb-janusgraph-storage-backend &&\
    mvn clean install

# Modify few entries in the install-gremlin-server.sh file
RUN cd /opt/dynamodb/dynamodb-janusgraph-storage-backend/ &&\
    sed -i "\#gpg --verify src/test/resources/${JANUSGRAPH_VANILLA_SERVER_ZIP}#d" src/test/resources/install-gremlin-server.sh &&\
    sed -i 's#JANUSGRAPH_VANILLA_SERVER_ZIP=.*#JANUSGRAPH_VANILLA_SERVER_ZIP=/opt/dynamodb/dynamodb-janusgraph-storage-backend/server/janusgraph-0.2.0-hadoop2.zip#' src/test/resources/install-gremlin-server.sh &&\
    src/test/resources/install-gremlin-server.sh

WORKDIR /opt/dynamodb/

# Cleanup Directories
RUN mkdir -p ${M2_DIR}/root &&\
    rm -Rf ${M2_REPO}/ &&\
    rm -rf ~/.m2/repository &&\
    rm -rf ~/.groovy/grapes &&\
    mkdir -p ${M2_REPO}/org/slf4j/slf4j-api/1.7.21/ &&\
    curl -o ${M2_REPO}/org/slf4j/slf4j-api/1.7.21/slf4j-api-1.7.21.jar http://central.maven.org/maven2/org/slf4j/slf4j-api/1.7.21/slf4j-api-1.7.21.jar

# Install Gremlin Python
RUN cd dynamodb-janusgraph-storage-backend/server/dynamodb-janusgraph-storage-backend-1.2.0 &&\
    bin/gremlin-server.sh -i org.apache.tinkerpop gremlin-python 3.2.3

ADD scripts/entrypoint.sh /bin/entrypoint.sh

#RUN cd dynamodb-janusgraph-storage-backend/server/dynamodb-janusgraph-storage-backend-1.2.0 &&\
#    elasticsearch/bin/elasticsearch

RUN chmod +x /bin/entrypoint.sh &&\
    chgrp -R 0 /opt/dynamodb/ &&\
    chmod -R g+rw /opt/dynamodb/ &&\
    find /opt/dynamodb/ -type d -exec chmod g+x {} +

ADD scripts/entrypoint-local.sh /bin/entrypoint-local.sh
RUN chmod +x /bin/entrypoint-local.sh

COPY scripts/post-hook.sh /bin/

ENTRYPOINT ["/bin/entrypoint.sh"]

