FROM registry.centos.org/centos/centos:7

MAINTAINER Shubham <shubham@linux.com>

RUN yum -y update &&\
	  yum -y install java java-devel maven &&\
	  yum clean all

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-openjdk

CMD ["true"]
