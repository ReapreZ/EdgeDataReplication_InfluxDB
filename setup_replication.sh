#!/bin/bash

set -a
source /app/.env
set +a

echo "Replication is getting setup...!"

# Cleans the environment variables from Windows-specific carriage return characters
INFLUX_LOCAL_ORG=$(echo "$INFLUX_LOCAL_ORG" | tr -d '\r')
INFLUX_LOCAL_URL=$(echo "$INFLUX_LOCAL_URL" | tr -d '\r')
INFLUX_LOCAL_API_TOKEN=$(echo "$INFLUX_LOCAL_API_TOKEN" | tr -d '\r')
INFLUX_LOCAL_BUCKET_NAME=$(echo "$INFLUX_LOCAL_BUCKET_NAME" | tr -d '\r')
INFLUX_CLOUD_ORG=$(echo "$INFLUX_CLOUD_ORG" | tr -d '\r')
INFLUX_CLOUD_URL=$(echo "$INFLUX_CLOUD_URL" | tr -d '\r')
INFLUX_CLOUD_API_TOKEN=$(echo "$INFLUX_CLOUD_API_TOKEN" | tr -d '\r')
INFLUX_CLOUD_ORG_ID=$(echo "$INFLUX_CLOUD_ORG_ID" | tr -d '\r')
INFLUX_CLOUD_BUCKET_ID=$(echo "$INFLUX_CLOUD_BUCKET_ID" | tr -d '\r')

influx config create \
  --config-name remote_config \
  --host-url "$INFLUX_CLOUD_URL" \
  --org "$INFLUX_CLOUD_ORG" \
  --token "$INFLUX_CLOUD_API_TOKEN"

echo "InfluxDB local config is getting created..." 

influx config create \
  --config-name local_config \
  --host-url "$INFLUX_LOCAL_URL" \
  --org "$INFLUX_LOCAL_ORG" \
  --token "$INFLUX_LOCAL_API_TOKEN" \
  --active

echo "Organisation is getting created..."

influx org create \
  --name markone \
  --description "Local Org"

echo "Remote is getting created..."

influx remote create \
  --name remote_conn \
  --remote-url "$INFLUX_CLOUD_URL" \
  --remote-api-token "$INFLUX_CLOUD_API_TOKEN" \
  --remote-org-id "$INFLUX_CLOUD_ORG_ID"

REMOTE_ID=$(influx remote list --name remote_conn | awk 'NR==2 {print $1}')

LOCAL_BUCKET_ID=$(influx bucket list \
  --name "$INFLUX_LOCAL_BUCKET_NAME" \
  --org "$INFLUX_LOCAL_ORG" \
  --json \
  | grep '"id":' \
  | head -n1 \
  | sed 's/.*"id": "\(.*\)",/\1/')

influx replication create \
  --name replication_markone \
  --local-bucket-id "$LOCAL_BUCKET_ID" \
  --remote-bucket-id "$INFLUX_CLOUD_BUCKET_ID" \
  --remote-id "$REMOTE_ID"

echo "Replication setup completed!"