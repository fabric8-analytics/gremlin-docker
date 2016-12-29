#! /usr/bin/bash

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
export GREMLIN_HOME="/opt/dynamodb/gremlin_home/"
envsubst < /tmp/passwd.template > /tmp/passwd
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=/tmp/passwd
export NSS_WRAPPER_GROUP=/etc/group

if [ $REST -eq 1 ] || [ $PYTHON -eq 1 ]; then
    ipython
else
    cd ${SERVER_DIR}
    exec bin/gremlin.sh 
fi
