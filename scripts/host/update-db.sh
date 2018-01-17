#Display --tz-utc option message so we remember to mysqldump the db with this option set to false
#mysqldump -uUSER -p --tz-utc=false DB > db.sql
echo "Remember to set --tz-utc=false in server dump!!!"

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


#get param (db file)
dbdump=$1 


#Check that db exists

#If local file, copy in current dir
if [ -f $dbdump ]; then
    echo "Local DB file"
    cp $dbdump .
#If Remote file, get to current dir
elif [[ `wget -S --spider $dbdump  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    echo "Remote DB File"
    wget $dbdump
elif [ $dbdump == "no" ]; then
    echo "No DB file specified, initializing with empty DB."
#If not, no DB File, Error an exit
else
    echo "DB file not found"
    exit;
fi




#date
 now=`date '+%d%m%Y%H%M%S'`
 
DB_NAME="$DB_NAME""$now"





#get the file

base=$(basename -- "$1")

 mv "$base" $CURRENT_DIR"/../../custom"

#go to /custom
cd $CURRENT_DIR"/../../custom"

#tar
tar -zxvf "$base" 

#delete original file
rm -f "$base"



#create db import file, create at custom

#create_dbupdate_file

create_dbinstall_file $DB_NAME $DOCKER_SETUP_DIR $DOCKER_CUSTOM_DIR

#start docker (get docker cmd, execute)
#Get the docker command
D_CMD=$(create_docker_run_cmd "update-db" $PROJECT_TYPE $DOCKER_SETUP_DIR)

#Run the docker command
$D_CMD

exit
