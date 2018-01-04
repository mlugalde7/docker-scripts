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

#Get the docker command
D_CMD=$(create_docker_run_cmd "start" $PROJECT_TYPE $DOCKER_SETUP_DIR)

#Run the docker command
$D_CMD

