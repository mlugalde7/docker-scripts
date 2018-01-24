# Let's invoke lamp's install script
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $this_dir"/lamp.sh"

#Configure Base URL's
#TODO: Configure Base URL's

#Check that local.xml file exists. Create if it doesn't
mage_localxml_file=$DOCKER_CODE_ROOT_DIR"/app/etc/local.xml"
#magento_check_localxml $mage_localxml_file

#Configure DB Creds at local.xml
magento_set_config $mage_localxml_file "username" "root"
magento_set_config $mage_localxml_file "password" "$DB_PASSWORD"
magento_set_config $mage_localxml_file "dbname" $PROJECT_NAME

#Check var/ and media/ folder exist. Create, set permissions and ownership if they don't
magento_folder $DOCKER_CODE_ROOT_DIR'/var'
magento_folder $DOCKER_CODE_ROOT_DIR'/media'


#sed -i '/TEXT_TO_BE_REPLACED/c\This line is removed by the admin.' /tmp/foo

#Clear cache
rm -rf $DOCKER_CODE_ROOT_DIR"/var/cache"

#go to folder
cd var/www/"$PROJECT_NAME"
echo ":)"

#run composer install
composer="composer install"
$composer


#change files permission 

chmod -R 777 app/etc var pub/media pub/static generated

#new database 


##!/usr/bin/env bash

# Magento install variables
dbhost="127.0.0.2"
dbname="dbname"
dbuser="dbuser"
dbpass="dbpass"
base_url="http://local.$PROJECT_NAME.com/"
admin_firstname="kapiwebdev"
admin_lastname="kapiwebdev"
admin_email="kapiwebdeb@gmail.com"
admin_username="admin"
admin_pass="admin123+"
language="en_US"
backend_frontname="admin"
mage_mode="developer"


                php -d memory_limit=-1 magento/bin/magento setup:install --base-url=$base_url --db-host=$dbhost --db-name=$dbname --db-user=$dbuser --db-password=$dbpass --admin-firstname=$admin_firstname --admin-lastname=$admin_lastname --admin-email=$admin_email --admin-user=$admin_username --admin-password=$admin_pass --language=$language --backend-frontname=$backend_frontname --use-sample-data --magento-init-params="MAGE_MODE=$mage_mode";
                echo Start compilation;
                php -d memory_limit=-1 magento/bin/magento setup:static-content:deploy;
            shift
            ;;
        -r|--run-instalation)
            shift
          
                php -d memory_limit=-1 magento/bin/magento setup:install --base-url=$base_url --db-host=$dbhost --db-name=$dbname --db-user=$dbuser --db-password=$dbpass --admin-firstname=$admin_firstname --admin-lastname=$admin_lastname --admin-email=$admin_email --admin-user=$admin_username --admin-password=$admin_pass --language=$language --backend-frontname=$backend_frontname --magento-init-params="MAGE_MODE=$mage_mode";
                echo Start compilation;
                php -d memory_limit=-1 magento/bin/magento setup:static-content:deploy;
            shift
            ;;

        *)
            echo "The initialization process was not performed!"
            break
            ;;
    esac
done

#open browser

xdg-open http://local."$dbname".com/admin




exit



