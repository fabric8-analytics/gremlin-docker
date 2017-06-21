#! /usr/bin/bash

# Files for which configuration needs to change
SERVER_DIR=dynamodb-titan-storage-backend/server/dynamodb-titan100-storage-backend-1.0.0-hadoop1/
PROPS=${SERVER_DIR}/conf/gremlin-server/dynamodb.properties
GREMLIN_CONF=${SERVER_DIR}/conf/gremlin-server/gremlin-server.yaml
GREMLIN_HOST=0.0.0.0
UUID=$(cat /proc/sys/kernel/random/uuid)

export JAVA_OPTIONS=${JAVA_OPTIONS:- -Xms512m -Xmx2048m}

export JAVA_OPTIONS="$JAVA_OPTIONS -javaagent:/opt/dynamodb/$SERVER_DIR/lib/jamm-0.3.0.jar"

echo "Proceeding with JAVA_OPTIONS=$JAVA_OPTIONS"

sed -i.bckp 's#host: .*#host: '$GREMLIN_HOST'#' ${GREMLIN_CONF}

if grep -i '^graph.unique-instance-id=' "$PROPS" 1>/dev/null; then
    sed -i.bckp 's#graph.unique-instance-id=.*#graph.unique-instance-id='${UUID}'#' ${PROPS}
else
    echo "graph.unique-instance-id=${UUID}" >> ${PROPS}
fi

if [ -n "$DYNAMODB_CLIENT_CREDENTIALS_CLASS_NAME" ]; then
    sed -i.bckp 's#storage.dynamodb.client.credentials.class-name=.*#storage.dynamodb.client.credentials.class-name='${DYNAMODB_CLIENT_CREDENTIALS_CLASS_NAME}'#' ${PROPS}
fi

if [ -n "$DYNAMODB_CLIENT_CREDENTIALS_CONSTRUCTOR_ARGS" ]; then
    sed -i.bckp 's#storage.dynamodb.client.credentials.constructor-args=.*#storage.dynamodb.client.credentials.constructor-args='${DYNAMODB_CLIENT_CREDENTIALS_CONSTRUCTOR_ARGS}'#' ${PROPS}
fi

if [ -n "$RESPONSE_TIMEOUT" ]; then
    sed -i.bckp 's#serializedResponseTimeout: .*#serializedResponseTimeout: '${RESPONSE_TIMEOUT}'#' ${GREMLIN_CONF}
fi

if [ -n "$SCRIPT_EVALUATION_TIMEOUT" ]; then
    sed -i.bckp 's#scriptEvaluationTimeout: .*#scriptEvaluationTimeout: '${SCRIPT_EVALUATION_TIMEOUT}'#' ${GREMLIN_CONF}
fi

if [ -n "$GREMLIN_POOL" ]; then
    sed -i.bckp 's#gremlinPool: .*#gremlinPool: '${GREMLIN_POOL}'#' ${GREMLIN_CONF}
fi

if [ -n "$THREAD_POOL" ]; then
    sed -i.bckp 's#threadPoolWorker: .*#threadPoolWorker: '${THREAD_POOL}'#' ${GREMLIN_CONF}
fi

if [ -v "$DYNAMODB_CLIENT_ENDPOINT" ]; then
    sed -i.bckp 's#storage.dynamodb.client.endpoint=.*#storage.dynamodb.client.endpoint='${DYNAMODB_CLIENT_ENDPOINT}'#' ${PROPS}
fi

if [ "$REST" == "1" ]; then
    sed -i.bckp 's#channelizer: .*#channelizer: org.apache.tinkerpop.gremlin.server.channel.HttpChannelizer#' ${GREMLIN_CONF}
fi

if [ -n "$DYNAMODB_PREFIX" ]; then
    sed -i.bckp 's#storage.dynamodb.prefix=.*#storage.dynamodb.prefix='$DYNAMODB_PREFIX'#' ${PROPS}
fi

if [ -n "$WRITE_UNITS" ]; then
    sed -i.bckp 's#storage.dynamodb.stores.edgestore.capacity-write=.*#storage.dynamodb.stores.edgestore.capacity-write='$WRITE_UNITS'#' ${PROPS}
    sed -i.bckp 's#storage.dynamodb.stores.graphindex.capacity-write=.*#storage.dynamodb.stores.graphindex.capacity-write='$WRITE_UNITS'#' ${PROPS}
else
    sed -i.bckp 's#storage.dynamodb.stores.edgestore.capacity-write=.*#storage.dynamodb.stores.edgestore.capacity-write=25#' ${PROPS}
    sed -i.bckp 's#storage.dynamodb.stores.graphindex.capacity-write=.*#storage.dynamodb.stores.graphindex.capacity-write=25#' ${PROPS}
fi

if [ -n "$READ_UNITS" ]; then
    sed -i.bckp 's#storage.dynamodb.stores.edgestore.capacity-read=.*#storage.dynamodb.stores.edgestore.capacity-read='$READ_UNITS'#' ${PROPS}
    sed -i.bckp 's#storage.dynamodb.stores.graphindex.capacity-read=.*#storage.dynamodb.stores.graphindex.capacity-read='$READ_UNITS'#' ${PROPS}
else
    sed -i.bckp 's#storage.dynamodb.stores.edgestore.capacity-read=.*#storage.dynamodb.stores.edgestore.capacity-read=25#' ${PROPS}
    sed -i.bckp 's#storage.dynamodb.stores.graphindex.capacity-read=.*#storage.dynamodb.stores.graphindex.capacity-read=25#' ${PROPS}
fi

if ( [ -n "$DATA_MODEL"i ] && [ "$DATA_MODEL" = "SINGLE" ] || [ "$DATA_MODEL" = "MULTI" ] ); then
    if grep -i '^storage.dynamodb.stores.edgestore.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.edgestore.data-model=.*#storage.dynamodb.stores.edgestore.data-model=$DATA_MODEL#' ${PROPS}
    else
        echo "storage.dynamodb.stores.edgestore.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.graphindex.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.graphindex.data-model=.*#storage.dynamodb.stores.graphindex.data-model=$DATA_MODEL#' ${PROPS}
    else
        echo "storage.dynamodb.stores.graphindex.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.systemlog.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.systemlog.data-model=.*#storage.dynamodb.stores.systemlog.data-model=$DATA_MODEL#' ${PROPS}
    else
        echo "storage.dynamodb.stores.systemlog.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.titan_ids.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.titan_ids.data-model=.*#storage.dynamodb.stores.titan_ids.data-model=$DATA_MODEL#' ${PROPS}
    else
        echo "storage.dynamodb.stores.titan_ids.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.system_properties.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.system_properties.data-model=.*#storage.dynamodb.stores.system_properties.data-model=$DATA_MODEL#' ${PROPS}
    else
        echo "storage.dynamodb.stores.system_properties.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.txlog.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.txlog.data-model=.*#storage.dynamodb.stores.txlog.data-model=$DATA_MODEL#' ${PROPS}
    else
        echo "storage.dynamodb.stores.txlog.data-model=$DATA_MODEL" >> ${PROPS}
    fi
fi
cd ${SERVER_DIR}

exec bin/gremlin-server.sh conf/gremlin-server/gremlin-server.yaml
