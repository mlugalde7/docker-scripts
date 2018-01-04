# Let's invoke lamp's install script
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $this_dir"/lamp.sh"

if [ ! -d $DOCKER_CODE_ROOT_DIR"/storage" ]; then
    mkdir -p $DOCKER_CODE_ROOT_DIR"/storage"
fi

chmod -R 777 $DOCKER_CODE_ROOT_DIR"/storage"

if [ ! -d $DOCKER_CODE_ROOT_DIR"/public/cache" ]; then
    mkdir -p $DOCKER_CODE_ROOT_DIR"/public/cache"
fi

chmod -R 777 $DOCKER_CODE_ROOT_DIR"/public/cache"

#Needed for Cartalyst mainly
chown 1000:1000 .env && chmod 777 .env

#Install dependencies
#composer install

echo "Laravel Install complete. Remember to set DB Creds at app/config.php"