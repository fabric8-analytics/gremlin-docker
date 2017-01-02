#! /usr/bin/bash

SERVER_DIR=dynamodb-titan-storage-backend/server/dynamodb-titan100-storage-backend-1.0.0-hadoop1/
PROPS=${SERVER_DIR}/conf/gremlin-server/dynamodb.properties
GREMLIN_CONF=${SERVER_DIR}/conf/gremlin-server/gremlin-server.yaml
GREMLIN_HOST=$HOSTNAME

sed -i.bckp 's#host: .*#host: '$GREMLIN_HOST'#' ${GREMLIN_CONF}
sed -i.bckp 's#storage.dynamodb.client.credentials.class-name=.*#storage.dynamodb.client.credentials.class-name='$1'#' ${PROPS}
sed -i.bckp 's#storage.dynamodb.client.credentials.constructor-args=.*#storage.dynamodb.client.credentials.constructor-args='$2'#' ${PROPS}

if [ -v aws_region ]; then
  sed -i.bckp 's#storage.dynamodb.client.endpoint=.*#storage.dynamodb.client.endpoint='$aws_region'#' ${PROPS}
fi

if [ "$REST" == "1" ]; then
    sed -i.bckp 's#channelizer: .*#channelizer: org.apache.tinkerpop.gremlin.server.channel.HttpChannelizer#' ${GREMLIN_CONF}
fi

cd ${SERVER_DIR}

sleep 20

exec bin/gremlin-server.sh conf/gremlin-server/gremlin-server.yaml
