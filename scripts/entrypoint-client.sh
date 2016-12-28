#! /usr/bin/bash

if [ $REST -eq 1 ] || [ $PYTHON -eq 1 ]; then
    ipython
else
    cd ${SERVER_DIR}
    exec bin/gremlin.sh 
fi
