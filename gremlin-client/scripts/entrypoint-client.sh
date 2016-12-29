#! /usr/bin/bash

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export GREMLIN_HOME="/opt/dynamodb/gremlin_home/"
envsubst < /tmp/passwd.template > /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

GREMLIN_DEFAULT_HOST="gremlin"

if [ $REST -eq 1 ] || [ $PYTHON -eq 1 ]; then
    ipython
else

    if [ -v GREMLIN_HOST ]; then
				sed -i.bckp 's#hosts: .*#hosts: ['$GREMLIN_HOST']#' "${SERVER_DIR}/conf/remote.yaml"
		else
				sed -i.bckp 's#hosts: .*#hosts: ['$GREMLIN_DEFAULT_HOST']#' "${SERVER_DIR}/conf/remote.yaml"
		fi

    if [ -v GREMLIN_PORT ]; then
	      sed -i.bckp 's#port: .*#port: '$GREMLIN_PORT'#' "${SERVER_DIR}/conf/remote.yaml"
	  fi

    cd ${SERVER_DIR} &&\
    (echo ":remote connect tinkerpop.server conf/remote.yaml" && cat) | bin/gremlin.sh
fi
