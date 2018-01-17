#Include functions file, needed to check some config values in the config file
source "/tmp/_di/scripts/common/functions.sh"

#Include config file
CONFIG_FILE="/tmp/_di/custom/config.sh"
source $CONFIG_FILE

#Start mysql
#service mysqld start
/etc/init.d/mysqld start

mysql -uroot -p"$DB_PASSWORD" < /tmp/_di/custom/dbinstall.sql

sed -i '/DB_DATABASE/c\DB_DATABASE='$1 /opt/$PROJECT_NAME/.env

#Run bash, this makes sure container keeps running as its services (mysql, apache)
/bin/bash

