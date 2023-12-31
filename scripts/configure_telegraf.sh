#!/bin/bash

set -euo pipefail

DEPS_DIR=$1
DEPS_IDX=$2

echo "-----> Configuring $SIDECAR_NAME Sidecar"

TELEGRAF_CONF_FILE=$DEPS_DIR/$DEPS_IDX/telegraf/telegraf.conf

getOrganizationName()
{
    echo $(echo $VCAP_APPLICATION | jq -r '.organization_name')
}

getSpaceName()
{
    echo $(echo $VCAP_APPLICATION | jq -r '.space_name')
}

getApplicationName()
{
    echo $(echo $VCAP_APPLICATION | jq -r '.application_name')
}

if [ -z ${ORGANIZATION_NAME+x} ];
then
  export ORGANIZATION_NAME=$(getOrganizationName)
fi

if [ -z ${SPACE_NAME+x} ];
then
  export SPACE_NAME=$(getSpaceName)
fi

if [ -z ${APPLICATION_NAME+x} ];
then
  export APPLICATION_NAME=$(getApplicationName)
fi

sed -i 's|stackit_organization_name|'$ORGANIZATION_NAME'|' $TELEGRAF_CONF_FILE
sed -i 's|stackit_space_name|'$SPACE_NAME'|' $TELEGRAF_CONF_FILE
sed -i 's|stackit_application_name|'$APPLICATION_NAME'|' $TELEGRAF_CONF_FILE
sed -i 's|prom_remote_write_url|'$PROM_REMOTE_WRITE_URL'|' $TELEGRAF_CONF_FILE
sed -i 's|prom_remote_write_user|'$PROM_REMOTE_WRITE_USER'|' $TELEGRAF_CONF_FILE
sed -i 's|prom_remote_write_passwd|'$PROM_REMOTE_WRITE_PASSWD'|' $TELEGRAF_CONF_FILE
