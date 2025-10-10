#!/bin/bash

set -euo pipefail

DEPS_DIR=$1
DEPS_IDX=$2

echo "-----> Configuring $SIDECAR_NAME Sidecar"

TELEGRAF_CONF_FILE=$DEPS_DIR/$DEPS_IDX/telegraf/telegraf.conf


## Get Telegraf Config from Environment Variable
PROM_REMOTE_WRITE_URL=$(echo $TELEGRAF_CONFIG | jq -r '.prom_remote_write_url')
PROM_REMOTE_WRITE_USER=$(echo $TELEGRAF_CONFIG | jq -r '.prom_remote_write_user')
PROM_REMOTE_WRITE_PASSWD=$(echo $TELEGRAF_CONFIG | jq -r '.prom_remote_write_passwd')

## Write to observability service
sed -i 's|prom_remote_write_url|'$PROM_REMOTE_WRITE_URL'|' $TELEGRAF_CONF_FILE
sed -i 's|prom_remote_write_user|'$PROM_REMOTE_WRITE_USER'|' $TELEGRAF_CONF_FILE
sed -i 's|prom_remote_write_passwd|'$PROM_REMOTE_WRITE_PASSWD'|' $TELEGRAF_CONF_FILE

## Extract configs from vcap and substitute placeholders
ORGANIZATION_NAME=$(echo $VCAP_APPLICATION | jq -r '.organization_name')
SPACE_NAME=$(echo $VCAP_APPLICATION | jq -r '.space_name')
APPLICATION_NAME=$(echo $VCAP_APPLICATION | jq -r '.application_name')

echo ":::::::::::: CF ::::::::::::::::::::::::::::::::::"
echo "ORGANIZATION_NAME: $ORGANIZATION_NAME"
echo "SPACE_NAME: $SPACE_NAME"
echo "APPLICATION_NAME: $APPLICATION_NAME"
echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ""
echo ""


sed -i 's|stackit_organization_name|'$ORGANIZATION_NAME'|' $TELEGRAF_CONF_FILE
sed -i 's|stackit_space_name|'$SPACE_NAME'|' $TELEGRAF_CONF_FILE
sed -i 's|stackit_application_name|'$APPLICATION_NAME'|' $TELEGRAF_CONF_FILE

RABBITMQ_HOST=$(echo $VCAP_SERVICES | jq -r '.["appcloud-rabbitmq40"][0].credentials.host')
RABBITMQ_USER=$(echo $VCAP_SERVICES | jq -r '.["appcloud-rabbitmq40"][0].credentials.username')
RABBITMQ_PASSWORD=$(echo $VCAP_SERVICES | jq -r '.["appcloud-rabbitmq40"][0].credentials.password')

echo ":::::::::::: RabbitMq ::::::::::::::::::::::::::::::::::"
echo "RABBITMQ_HOST: $RABBITMQ_HOST"
echo "RABBITMQ_USER: $RABBITMQ_USER"
echo "RABBITMQ_PASSWORD: $RABBITMQ_PASSWORD"
echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ""
echo ""




sed -i 's|rabbitmq_user|'$RABBITMQ_USER'|' $TELEGRAF_CONF_FILE
sed -i 's|rabbitmq_password|'$RABBITMQ_PASSWORD'|' $TELEGRAF_CONF_FILE
sed -i 's|rabbitmq_host|'$RABBITMQ_HOST'|' $TELEGRAF_CONF_FILE

MARIADB_HOST=$(echo $VCAP_SERVICES | jq -r '.["appcloud-mariadb106"][0].credentials.host')
MARIADB_USER=$(echo $VCAP_SERVICES | jq -r '.["appcloud-mariadb106"][0].credentials.username')
MARIADB_PASSWORD=$(echo $VCAP_SERVICES | jq -r '.["appcloud-mariadb106"][0].credentials.password')
MARIADB_NAME=$(echo $VCAP_SERVICES | jq -r '.["appcloud-mariadb106"][0].credentials.name')

echo ":::::::::::: MariaDB ::::::::::::::::::::::::::::::::::"
echo "MARIADB_HOST: $MARIADB_HOST"
echo "MARIADB_USER: $MARIADB_USER"
echo "MARIADB_PASSWORD: $MARIADB_PASSWORD"
echo "MARIADB_NAME: $MARIADB_NAME"
echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ""
echo ""


sed -i 's|mariadb_user|'$MARIADB_USER'|' $TELEGRAF_CONF_FILE
sed -i 's|mariadb_password|'$MARIADB_PASSWORD'|' $TELEGRAF_CONF_FILE
sed -i 's|mariadb_host|'$MARIADB_HOST'|' $TELEGRAF_CONF_FILE
sed -i 's|mariadb_name|'$MARIADB_NAME'|' $TELEGRAF_CONF_FILE


REDIS_HOST=$(echo $VCAP_SERVICES | jq -r '.["appcloud-redis7"][0].credentials.host')
REDIS_USER=$(echo $VCAP_SERVICES | jq -r '.["appcloud-redis7"][0].credentials.redis.username')
REDIS_PASSWORD=$(echo $VCAP_SERVICES | jq -r '.["appcloud-redis7"][0].credentials.redis.password')
REDIS_CACRT=$(echo $VCAP_SERVICES | jq -r '.["appcloud-redis7"][0].credentials.cacrt')

echo ":::::::::::: Redis ::::::::::::::::::::::::::::::::::"
echo "REDIS_HOST: $REDIS_HOST"
echo "REDIS_USER: $REDIS_USER"
echo "REDIS_PASSWORD: $REDIS_PASSWORD"
echo "REDIS_CACRT: $REDIS_CACRT"
echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ""
echo ""

sed -i 's|redis_host|'$REDIS_HOST'|' $TELEGRAF_CONF_FILE
sed -i 's|redis_user|'$REDIS_HOST'|' $TELEGRAF_CONF_FILE
sed -i 's|redis_password|'$REDIS_PASSWORD'|' $TELEGRAF_CONF_FILE


echo ":::::::::::: Telegraf Config ::::::::::::::::::::::::::::::::::"
cat $TELEGRAF_CONF_FILE
echo ":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
echo ""
echo ""
