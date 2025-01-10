# Edge Data Replication Prototype

This repository contains a prototype for demonstrating **Edge Data Replication** using InfluxDB. The goal of this prototype is to showcase how data from a local InfluxDB instance can be efficiently replicated to a cloud-based InfluxDB instance. This project is a part of my Bachelor thesis on the topic "Datasynchronisation in an IoT-Application"

## Features

- **Local InfluxDB Setup**: A Dockerized local InfluxDB instance with pre-configured settings.
- **Automated Replication**: Scripts to automate the replication process from local to cloud.
- **Example Data**: Preloaded example CSV data to test the replication process.

## Prerequisites

Ensure the following are installed on your system:

- Docker and Docker Compose
- InfluxDB CLI (for manual testing if needed)

## Setup Instructions

### 1. Set Environment Variables

rename the develop.ev file to .env and
Modify the .env file with your credentials:

```env
MARKONE_INFLUX_USERNAME=your_local_username
MARKONE_INFLUX_PASSWORD=your_local_password
MARKONE_INFLUX_LOCAL_API_TOKEN=your_local_api_token
MARKONE_INFLUX_LOCAL_ORG=your_local_org
MARKONE_INFLUX_LOCAL_BUCKET_NAME=your_local_bucket
MARKONE_INFLUX_LOCAL_URL=https://your-local-instance-url
MARKONE_INFLUX_CLOUD_API_TOKEN=your_cloud_api_token
MARKONE_INFLUX_CLOUD_URL=https://your-cloud-instance-url
MARKONE_INFLUX_CLOUD_BUCKET_NAME=your_cloud_bucket
INFLUX_CLOUD_ORG_ID=your_cloud_org_id
INFLUX_CLOUD_BUCKET_ID=your_cloud_bucket_id
```

### 2 Start the Services

Run the following command to start the local InfluxDB instance:
```bash
docker-compose up -d
```

### 3. Replication Setup

The replication setup script will automatically run when the container starts. It performs the following steps:

- Configures the local InfluxDB instance.
- Creates a connection to the cloud instance.
- Sets up replication between the local and cloud instances.

### 4. Testing

To insert Data into your local Database you need to create a local config and then insert values into it.

```bash
influx config create --config-name local_config --host-url your_local_url --org org_name  --token your_api_key  --active

influx write --bucket bucket_name --org org_name 'myMeasurement,myTag=myValue myField=25'
```
To see if the data is inside of your database you can use this SQL-Command.

```sql
SELECT *
FROM "myMeasurement"
WHERE
time >= now() - interval '15 minutes'
AND
("myField" IS NOT NULL)
```