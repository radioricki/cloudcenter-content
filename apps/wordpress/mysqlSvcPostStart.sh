#!/bin/bash -x
exec > >(tee -a /var/tmp/mysqlSvcPostStart_$$.log) 2>&1

. /usr/local/osmosix/etc/.osmosix.sh
. /usr/local/osmosix/etc/userenv
. /usr/local/osmosix/service/utils/cfgutil.sh

echo "Username: $(whoami)"
echo "Working Directory: $(pwd)"

env

# Only if app was migrated and therefore should already have data. Otherwise skip.
# Use simple DB script to replace old front-end IP with new front-end IP in database
# TODO: Change name of this file to postMigrate.
wget https://raw.githubusercontent.com/datacenter/cloudcenter-content/master/apps/wordpress/wp_migration.sql
replaceToken wp_migration.sql '%APP_SERVER_IP%' $CliqrTier_haproxy_2_PUBLIC_IP
mysql -u root -pwelcome2cliqr < wp_migration.sql
