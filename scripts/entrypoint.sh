#! /usr/bin/bash

# Files for which configuration needs to change
SERVER_DIR=dynamodb-janusgraph-storage-backend/server/dynamodb-janusgraph-storage-backend-1.1.0/
PROPS=${SERVER_DIR}/conf/gremlin-server/dynamodb.properties
GREMLIN_CONF=${SERVER_DIR}/conf/gremlin-server/gremlin-server.yaml
GREMLIN_HOST=0.0.0.0
UUID=$(cat /proc/sys/kernel/random/uuid)
STORAGE_BACKEND=com.amazon.janusgraph.diskstorage.dynamodb.DynamoDBStoreManager
USE_TITAN_IDS=true
TITAN_IDS=titan_ids

export JAVA_OPTIONS=${JAVA_OPTIONS:- -Xms512m -Xmx2048m}

export JAVA_OPTIONS="$JAVA_OPTIONS -javaagent:/opt/dynamodb/$SERVER_DIR/lib/jamm-0.3.0.jar"

echo "Proceeding with JAVA_OPTIONS=$JAVA_OPTIONS"

sed -i.bckp 's#host: .*#host: '$GREMLIN_HOST'#' ${GREMLIN_CONF}

if grep -i '^graph.unique-instance-id=' "$PROPS" 1>/dev/null; then
    sed -i.bckp 's#graph.unique-instance-id=.*#graph.unique-instance-id='${UUID}'#' ${PROPS}
else
    echo "graph.unique-instance-id=${UUID}" >> ${PROPS}
fi

echo "graph.titan-version=1.1.0-SNAPSHOT" >> ${PROPS}

sed -i.bckp 's#consoleReporter: .*#consoleReporter: {enabled: false}, #' ${GREMLIN_CONF}
sed -i.bckp 's#csvReporter: .*#csvReporter: {enabled: false}, #' ${GREMLIN_CONF}
sed -i.bckp 's#jmxReporter: .*#jmxReporter: {enabled: false}, #' ${GREMLIN_CONF}
sed -i.bckp 's#slf4jReporter: .*#slf4jReporter: {enabled: false}, #' ${GREMLIN_CONF}
sed -i.bckp 's#gangliaReporter: .*#gangliaReporter: {enabled: false}, #' ${GREMLIN_CONF}
sed -i.bckp 's#graphiteReporter: .*#graphiteReporter: {enabled: false}} #' ${GREMLIN_CONF}

if [ -n "$DYNAMODB_CLIENT_CREDENTIALS_CLASS_NAME" ]; then
    sed -i.bckp 's#storage.dynamodb.client.credentials.class-name=.*#storage.dynamodb.client.credentials.class-name='${DYNAMODB_CLIENT_CREDENTIALS_CLASS_NAME}'#' ${PROPS}
fi

if [ -n "$DYNAMODB_CLIENT_CREDENTIALS_CONSTRUCTOR_ARGS" ]; then
    sed -i.bckp 's#storage.dynamodb.client.credentials.constructor-args=.*#storage.dynamodb.client.credentials.constructor-args='${DYNAMODB_CLIENT_CREDENTIALS_CONSTRUCTOR_ARGS}'#' ${PROPS}
fi

if [ -n "$MAX_CONTENT_LENGTH" ]; then
    sed -i.bckp 's#maxContentLength: .*#maxContentLength: '$MAX_CONTENT_LENGTH'#' ${GREMLIN_CONF}
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
    sed -i.bckp 's#storage.dynamodb.stores.edgestore.initial-capacity-write=.*#storage.dynamodb.stores.edgestore.initial-capacity-write='$WRITE_UNITS'#' ${PROPS}
    sed -i.bckp 's#storage.dynamodb.stores.graphindex.initial-capacity-write=.*#storage.dynamodb.stores.graphindex.initial-capacity-write='$WRITE_UNITS'#' ${PROPS}
else
    sed -i.bckp 's#storage.dynamodb.stores.edgestore.initial-capacity-write=.*#storage.dynamodb.stores.edgestore.initial-capacity-write=25#' ${PROPS}
    sed -i.bckp 's#storage.dynamodb.stores.graphindex.initial-capacity-write=.*#storage.dynamodb.stores.graphindex.initial-capacity-write=25#' ${PROPS}
fi

if [ -n "$READ_UNITS" ]; then
    sed -i.bckp 's#storage.dynamodb.stores.edgestore.initial-capacity-read=.*#storage.dynamodb.stores.edgestore.initial-capacity-read='$READ_UNITS'#' ${PROPS}
    sed -i.bckp 's#storage.dynamodb.stores.graphindex.initial-capacity-read=.*#storage.dynamodb.stores.graphindex.initial-capacity-read='$READ_UNITS'#' ${PROPS}
else
    sed -i.bckp 's#storage.dynamodb.stores.edgestore.initial-capacity-read=.*#storage.dynamodb.stores.edgestore.initial-capacity-read=25#' ${PROPS}
    sed -i.bckp 's#storage.dynamodb.stores.graphindex.initial-capacity-read=.*#storage.dynamodb.stores.graphindex.initial-capacity-read=25#' ${PROPS}
fi

if grep -i '^storage.backend=' "$PROPS" 1>/dev/null; then
    sed -i.bckp 's#storage.backend=.*#storage.backend='${STORAGE_BACKEND}'#' ${PROPS}
 else
    echo "storage.backend=$STORAGE_BACKEND" >> ${PROPS}
fi

if grep -i '^storage.dynamodb.prefix=' "$PROPS" 1>/dev/null; then
    sed -i.bckp 's#storage.dynamodb.prefix=.*#storage.dynamodb.prefix='${DYNAMODB_PREFIX}'#' ${PROPS}
 else
    echo "storage.dynamodb.prefix=$DYNAMODB_PREFIX" >> ${PROPS}
fi

if grep -i '^storage.dynamodb.client.signing-region=' "$PROPS" 1>/dev/null; then
    sed -i.bckp 's#storage.dynamodb.client.signing-region=.*#storage.dynamodb.client.signing-region='${AWS_DEFAULT_REGION}'#' ${PROPS}
 else
    echo "storage.dynamodb.client.signing-region=$AWS_DEFAULT_REGION" >> ${PROPS}
fi

if grep -i '^storage.dynamodb.use-titan-ids=' "$PROPS" 1>/dev/null; then
    sed -i.bckp 's#storage.dynamodb.use-titan-ids=.*#storage.dynamodb.use-titan-ids='${USE_TITAN_IDS}'#' ${PROPS}
 else
    echo "storage.dynamodb.use-titan-ids=$USE_TITAN_IDS" >> ${PROPS}
fi

if grep -i '^ids.store-name=' "$PROPS" 1>/dev/null; then
    sed -i.bckp 's#ids.store-name=.*#ids.store-name='${TITAN_IDS}'#' ${PROPS}
 else
    echo "ids.store-name=$TITAN_IDS" >> ${PROPS}
fi


if [ -n "${DATA_MODEL}" ] && ( [ "$DATA_MODEL" = "SINGLE" ] || [ "$DATA_MODEL" = "MULTI" ] ); then
    if grep -i '^storage.dynamodb.stores.edgestore.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.edgestore.data-model=.*#storage.dynamodb.stores.edgestore.data-model='${DATA_MODEL}'#' ${PROPS}
    else
        echo "storage.dynamodb.stores.edgestore.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.graphindex.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.graphindex.data-model=.*#storage.dynamodb.stores.graphindex.data-model='${DATA_MODEL}'#' ${PROPS}
    else
        echo "storage.dynamodb.stores.graphindex.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.systemlog.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.systemlog.data-model=.*#storage.dynamodb.stores.systemlog.data-model='${DATA_MODEL}'#' ${PROPS}
    else
        echo "storage.dynamodb.stores.systemlog.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.titan_ids.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.titan_ids.data-model=.*#storage.dynamodb.stores.titan_ids.data-model='${DATA_MODEL}'#' ${PROPS}
    else
        echo "storage.dynamodb.stores.titan_ids.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.system_properties.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.system_properties.data-model=.*#storage.dynamodb.stores.system_properties.data-model='${DATA_MODEL}'#' ${PROPS}
    else
        echo "storage.dynamodb.stores.system_properties.data-model=$DATA_MODEL" >> ${PROPS}
    fi
    if grep -i '^storage.dynamodb.stores.txlog.data-model=' "$PROPS" 1>/dev/null; then
        sed -i.bckp 's#storage.dynamodb.stores.txlog.data-model=.*#storage.dynamodb.stores.txlog.data-model='${DATA_MODEL}'#' ${PROPS}
    else
        echo "storage.dynamodb.stores.txlog.data-model=$DATA_MODEL" >> ${PROPS}
    fi
fi

cd ${SERVER_DIR}

exec bin/gremlin-server.sh conf/gremlin-server/gremlin-server.yaml
