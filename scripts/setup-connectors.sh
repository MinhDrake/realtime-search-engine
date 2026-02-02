#!/bin/bash
# scripts/setup-connectors.sh

CONNECT_HOST="localhost:8083"

echo "Waiting for Kafka Connect to start..."
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://$CONNECT_HOST/)" != "200" ]]; do 
    echo "Kafka Connect not ready..."
    sleep 5
done
echo "Kafka Connect is ready!"

echo "----------------------------------------------------------------"
echo "1. Creating Debezium Postgres Source Connector"
echo "----------------------------------------------------------------"

curl -i -X PUT -H "Content-Type:application/json" \
    http://$CONNECT_HOST/connectors/source-postgres-products/config \
    -d '{
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "database.hostname": "postgres",
        "database.port": "5432",
        "database.user": "postgres",
        "database.password": "postgres",
        "database.dbname": "products_db",
        "database.server.name": "dbserver1",
        "topic.prefix": "dbserver1",
        "table.include.list": "public.products",
        "plugin.name": "pgoutput",
        "decimal.handling.mode": "double",
        "transforms": "unwrap",
        "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
        "transforms.unwrap.drop.tombstones": "false",
        "transforms.unwrap.delete.handling.mode": "rewrite"
    }'

echo -e "\n\n----------------------------------------------------------------"
echo "2. Creating Elasticsearch Sink Connector"
echo "----------------------------------------------------------------"

curl -i -X PUT -H "Content-Type:application/json" \
    http://$CONNECT_HOST/connectors/sink-elastic-products/config \
    -d '{
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "connection.url": "http://elasticsearch:9200",
        "topics": "dbserver1.public.products",
        "type.name": "_doc",
        "key.ignore": "true",
        "schema.ignore": "true",
        "behavior.on.null.values": "delete"
    }'

echo -e "\n\nDone! Connectors configured."
