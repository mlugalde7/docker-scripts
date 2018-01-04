#Get the root dir of this file, all other files are relative to this dir
CURRENT_DIR="$(dirname "$0")"

#Include the helper functions
source $CURRENT_DIR"/../common/functions.sh"

#Check that config file exists, include if it does, exit and error if it doesn't
CONFIG_FILE=$CURRENT_DIR"/../../custom/config.sh"
check_config_file $CONFIG_FILE
source $CONFIG_FILE

#Check that the required configuration values are set and have valid values
check_config_values

#Make sure persistent ssh folder exists, create if it doesn't (needed for github creds
if [ ! -d $SSH_DIR ]; then
    mkdir -p $SSH_DIR
fi

#Check that DB File is present and DB folder (for persistent db) exists
check_db

#Check that the code dir exists and the public dir has an index.php file
check_code

#Create dbinstall.sql file to create and import the DB
create_dbinstall_file $DB_NAME $DOCKER_SETUP_DIR $DOCKER_CUSTOM_DIR

#Get the docker command
D_CMD=$(create_docker_run_cmd "install" $PROJECT_TYPE $DOCKER_SETUP_DIR)

#echo "$D_CMD"
#exit

#Run the docker command
$D_CMD

if ! is_var_empty $ERR_SSH_DIR; then
    echo $ERR_SSH_DIR
fi;

exit