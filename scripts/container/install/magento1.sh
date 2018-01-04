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

exit;