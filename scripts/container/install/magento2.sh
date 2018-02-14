# Let's invoke lamp's install script
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $this_dir"/lamp.sh"

#Configure Base URL's
#TODO: Configure Base URL's

#Check that local.xml file exists. Create if it doesn't
mage_config_file=$DOCKER_CODE_ROOT_DIR"/app/etc/env.php"
#magento_check_localxml $mage_localxml_file

# #Configure DB Creds at local.xml
# magento_set_config $mage_localxml_file "username" "root"
# magento_set_config $mage_localxml_file "password" "$DB_PASSWORD"
# magento_set_config $mage_localxml_file "dbname" $PROJECT_NAME

#Check var/ and media/ folder exist. Create, set permissions and ownership if they don't
magento_folder $DOCKER_CODE_ROOT_DIR'/var'
magento_folder $DOCKER_CODE_ROOT_DIR'/pub/media'


#sed -i '/TEXT_TO_BE_REPLACED/c\This line is removed by the admin.' /tmp/foo

#Clear cache
rm -rf $DOCKER_CODE_ROOT_DIR"/var/cache"

#go to folder
cd $DOCKER_CODE_ROOT_DIR
echo $DOCKER_CODE_ROOT_DIR
exit


#get cred keys repo
#auth.json.kwdtemplate


cv=$(sed -n 's|\"\(username\)\": \"\([^\"]*\)\"|\2|p' $DOCKER_CODE_ROOT_DIR/pagetest.json | tr -d ' ')
cv=${cv%?}

cv2=$(sed -n 's|\"\(password\)\": \"\([^\"]*\)\"|\2|p' $DOCKER_CODE_ROOT_DIR/pagetest.json | tr -d ' ')

key1=$(echo -n $cv | base64 -d)
key2=$(echo -n $cv2 | base64 -d)


#create test file




      echo '{
             "http-basic":{
             "repo.magento.com":{
               "username": "'$key1'", 
               "password": "'$key2'" }
           }


          }' > auth.json






#run composer install
composer="composer install"
$composer



#change files permission 

chmod -R 777 app/etc var pub/media pub/static generated


#new database 


##!/usr/bin/env bash

# Magento install variables
dbhost="127.0.0.1"
dbname=$DB_NAME
dbuser="root"
dbpass=$DB_PASSWORD
base_url="http://$LOCAL_PREFIX.$PROJECT_NAME.com/"
admin_firstname="kapiwebdev"
admin_lastname="kapiwebdev"
admin_email="kapiwebdeb@gmail.com"
admin_username="admin"
admin_pass="hola1234"
language="en_US"
backend_frontname="admin"
mage_mode="developer"


php -d memory_limit=-1 bin/magento setup:install --base-url=$base_url --db-host=$dbhost --db-name=$dbname --db-user=$dbuser --db-password=$dbpass --admin-firstname=$admin_firstname --admin-lastname=$admin_lastname --admin-email=$admin_email --admin-user=$admin_username --admin-password=$admin_pass --language=$language --backend-frontname=$backend_frontname --magento-init-params="MAGE_MODE=$mage_mode";
echo Start compilation
php -d memory_limit=-1 bin/magento setup:static-content:deploy

chmod -R 777 app/etc var pub/media pub/static generated

exit

# xdg-open http://local."$dbname".com/admin open browser
