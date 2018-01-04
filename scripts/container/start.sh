#Include functions file, needed to check some config values in the config file
source "/tmp/_di/scripts/common/functions.sh"

#Include config file
CONFIG_FILE="/tmp/_di/custom/config.sh"
source $CONFIG_FILE

#Make Link of public dir and move it to $WWW_DIR (/var/www)
ln -s $DOCKER_CODE_ROOT_DIR "$DOCKER_WWW_DIR/$PROJECT_NAME"

#Create vhost file
cp $DOCKER_SETUP_DIR/scripts/container/vhost_template /etc/httpd/conf.d/$PROJECT_NAME.conf

#Update vhost file with the project name and local prefix url
sed -i "s/TEMPLATE/$PROJECT_NAME/g" /etc/httpd/conf.d/$PROJECT_NAME.conf
sed -i "s,PUBLIC,$PUBLIC_DIR,g" /etc/httpd/conf.d/$PROJECT_NAME.conf
sed -i "s/URL_PREFIX/$LOCAL_PREFIX/g" /etc/httpd/conf.d/$PROJECT_NAME.conf

#Start mysql
service mysqld start

#Start apache
service httpd start

#Run bash, this makes sure container keeps running as its services (mysql, apache)
/bin/bash

