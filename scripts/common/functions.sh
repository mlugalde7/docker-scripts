magento_folder () {
folder=$1

if [ ! -d $folder ]; then
    mkdir $folder
    chown 1000:1000 $folder
    chmod 777 $folder
fi

}


magento_check_localxml() {
    mage_config_file=$1
    mage_etc_folder=$(dirname "$1")

    if ! file_exists $mage_config_file; then
        if file_exists $mage_etc_folder"/local.xml.fdtemplate"; then
            cp $mage_etc_folder"/local.xml.fdtemplate" $mage_config_file
            chown 1000:1000 $mage_config_file
        else
            echo "No local.xml file found, no template found either. Not sure if I should exit or not."
            exit
        fi
    fi
}
magento_set_config() {
    if magento_check_localxml $1; then
        file=$1
        key=$2
        value=$3

        currentValue=$(sed -n 's|<'$key'><\!\[CDATA\[\(.*\)\]\]></'$key'>|\1|p' $file | tr -d ' ')

        if [ -z $currentValue ]; then
            currentValue="<"$key"><\!\[CDATA\[\\]\]><\/"$key">"
            value="<"$key"><\!\[CDATA\["$value"\]\]><\/"$key">"
        fi

        sed -i "s/$currentValue/$value/g" $file
    fi
}



magento2_check_env() {
    mage_config_file=$1
    mage_etc_folder=$(dirname "$1")

    if ! file_exists $mage_config_file; then
        if file_exists $mage_etc_folder"app/etc/env.php."; then
            cp $mage_etc_folder"/app/etc/env.php" $mage_config_file
            chown 1000:1000 $mage_config_file
        else
            echo "No env.php file found, no template found either. Not sure if I should exit or not."
            exit
        fi
    fi
}
magento2_set_config() {
    if magento2_check_env $1; then
        file=$1
        key=$2
        value=$3


         sed -n 's|\"\(username\)\": \"\([^\"]*\)\"|\2|p' /var/www/magento2test/auth.json | tr -d ' '

        #re="\"($key)\": \"([^\"]*)\""
        cv=$(sed -n 's|\"($key)\": \"([^\"]*)\"|\1|p' $file | tr -d ' ')
        echo $cv
        

        currentValue=$(sed -n 's|<'$key'><\!\[CDATA\[\(.*\)\]\]></'$key'>|\1|p' $file | tr -d ' ')

        if [ -z $currentValue ]; then
            currentValue="<"$key"><\!\[CDATA\[\\]\]><\/"$key">"
            value="<"$key"><\!\[CDATA\["$value"\]\]><\/"$key">"
        fi

        sed -i "s/$currentValue/$value/g" $file
    fi
}


configure_aliases() {
    #Configure aliases based on OS (readlink/greadlink, docker run args)
     #Linux
    if [[ "$SYSTEM_OS" == 'Linux' ]]; then
        echo "Running on Linux System"

        #readlink Alias
        readlink='readlink --canonicalize'

        #docker run Alias
        dockerrun='docker run -i -t'

    #Other (assuming mac)
    elif [[ "$unamestr" == 'FreeBSD' ]]; then
        echo "Running on Mac System"

        #readlink Alias
        readlink='greadlink -f'

        #docker run Alias
        dockerrun='docker run -i -t -p 8080:80'
    fi
}


create_dbinstall_file() {
    DBINSTALL_FILE="$3/dbinstall.sql"
    #Remove any previous dbinstall.sql file if any
    if file_exists $DBINSTALL_FILE; then
        rm -f $DBINSTALL_FILE
    fi

    # echo "DROP DATABASE IF EXISTS $1;" >> $DBINSTALL_FILE
    # echo "CREATE DATABASE $1;" >> $DBINSTALL_FILE
    # echo "USE $1;" >> $DBINSTALL_FILE
    # echo "source $2/custom/db.sql;" >> $DBINSTALL_FILE
   # DBINSTALL_FILE="$3/dbinstall.sql"
   #Remove any previous dbinstall.sql file if any
   

    if  file_exists $DBINSTALL_FILE; then
        rm -f $DBINSTALL_FILE
    fi

    if [ $1 == "new" ]; then
        dbname="newdb"
    else
        dbname=$1
    fi

    echo "DROP DATABASE IF EXISTS $dbname;" >> $DBINSTALL_FILE
    echo "CREATE DATABASE $dbname;" >> $DBINSTALL_FILE
    echo "USE $dbname;" >> $DBINSTALL_FILE

    if [ $1 != 'new' ]; then
        echo "source $2/custom/db.sql;" >> $DBINSTALL_FILE
    fi



}

create_dbupdate_file() {
    DBUPDATE_FILE="$3/dbupdate.sql"
    #Remove any previous dbinstall.sql file if any
    if file_exists $DBUPDATE_FILE; then
        rm -f $DBUPDATE_FILE
    fi

    # echo "DROP DATABASE IF EXISTS $1;" >> $DBINSTALL_FILE
    # echo "CREATE DATABASE $1;" >> $DBINSTALL_FILE
    # echo "USE $1;" >> $DBINSTALL_FILE
    # echo "source $2/custom/db.sql;" >> $DBINSTALL_FILE
   # DBINSTALL_FILE="$3/dbinstall.sql"
   #Remove any previous dbinstall.sql file if any
   

    if  file_exists $DBUPDATE_FILE; then
        rm -f $DBUPDATE_FILE
    fi

    if [ $1 == "new" ]; then
        dbname="newdb"
    else
        dbname=$1
    fi

    echo "DROP DATABASE IF EXISTS $dbname;" >> $DBUPDATE_FILE
    echo "CREATE DATABASE $dbname;" >> $DBUPDATE_FILE
    echo "USE $dbname;" >> $DBUPDATE_FILE

    if [ $1 != 'new' ]; then
        echo "source $2/custom/db.sql;" >> $DBUPDATE_FILE
    fi



}

#Requires argument: "start" or "install" depending on the operation needed
create_docker_run_cmd() {
    if [ "$1" == "start" ]; then
        DCMD="sh $3/scripts/container/start.sh"
    elif [ "$1" == "install" ]; then
        DCMD="sh $3/scripts/container/install/$PROJECT_TYPE.sh"

    elif [ "$1" == "update-db" ]; then
        DCMD="sh $3/scripts/container/update-db/$PROJECT_TYPE.sh $DB_NAME"
    else
        echo "create_docker_run_cmd Error: argument provided is not 'install' or 'start'"
        exit
    fi

    docker_image=$(get_docker_image $PROJECT_TYPE)

    #echo "docker run -i -t -v $PROJECT_DIR/:$DOCKER_CODE_ROOT_DIR -v $PROJECT_DB_DIR:$DOCKER_MYSQL_DIR -v $ROOT_DIR:$DOCKER_SETUP_DIR -v $SSH_DIR:$DOCKER_SSH_DIR $docker_image $DCMD"
    echo "$dockerrun -v $PROJECT_DIR/:$DOCKER_CODE_ROOT_DIR -v $PROJECT_DB_DIR:$DOCKER_MYSQL_DIR -v $ROOT_DIR:$DOCKER_SETUP_DIR -v $SSH_DIR:$DOCKER_SSH_DIR $docker_image $DCMD"
#    exit
}


get_docker_image() {
    type=$1

    case "$type" in

        lamp) echo 'kapiwebdev/lamp'
#        lamp) echo 'adriancr/lamp'#
            ;;
        magento1) echo 'kapiwebdev/lamp'
            ;;
        magento2) echo 'kapiwebdev/lamp2'
            ;;
        laravel) echo 'kapiwebdev/lamp'
            ;;
    esac
}


check_code() {
    PDIR="$PROJECT_DIR$PUBLIC_DIR"
    if ! file_exists "$PDIR/index.php"; then
        echo "WARNING: Public dir $PDIR doesn't has an index.php file"
    fi
}

check_db() {
    DB_FILE=$DOCKER_CUSTOM_DIR"/db.sql"

    if ! file_exists $DB_FILE; then
        echo "No db.sql file found in $DB_FILE"
    fi

    if ! dir_exists $PROJECT_DB_DIR; then
        echo "The dir $PROJECT_DB_DIR doesn't exist. We need this to persist the DB"
        exit
    fi
}

check_config_values() {
    #Check that all the values are in there.
    check_config_required

    #Check that PROJECT_DOMAIN is set, set to PROJECT_NAME.com if it isn't.
    if is_var_empty $PROJECT_DOMAIN; then
        PROJECT_DOMAIN=$PROJECT_NAME".com"
    fi

    #Check that DB_NAME is set, set to PROJECT_NAME if it isn't.
    if is_var_empty $DB_NAME; then
        DB_NAME=$PROJECT_NAME
    fi

    #Check if ~/.dockerssh folder exists. Create if it doesn't, add Info Message to end Result
    if [[ ( ! -d "$SSH_DIR" ) || ( ! -f $SSH_DIR"/id_rsa.pub" ) ]]; then
        ERR_SSH_DIR="It seems like you don't have the ssh public key configured. You'll need to run the following command when you first start the container: ssh-keygen -t rsa -C \"your_email@youremail.com\""
    fi
}


format_var() {
    VAR=$1

    VAR=$(clean_var $VAR)
    VAR=$(str_to_lower $VAR)

    echo $VAR
}

check_config_required() {
    REQUIRED=( 'PROJECT_NAME' 'PROJECT_DIR' 'PROJECT_TYPE' )
	MISSING=()
	for i in "${REQUIRED[@]}"
	do
		VAR=$(string_to_var $i)
		if is_var_empty $VAR; then
			#add var to missing array
			MISSING+=($i)
		fi
	done

	#If missing array is empty, return success status
	if [ ${#MISSING[@]} -eq 0 ]; then
		return 0;
    # if missing not empty: error and exit
	else
		MISS_STRING=$(join , "${MISSING[@]}")
		echo "The following values are required in config.sh: $MISS_STRING"
		exit;
	fi
}

check_config_file() {
	if file_exists $1; then
		echo "Config file found, loading values."
	else
		echo "Couldn't find the file $CONFIG_FILE in the current directory."
		exit;
	fi
}

file_exists() {
	if is_var_set $1; then
		FILE=$1
		if [ -f "$FILE" ]; then
			return 0;
		fi
	else
		echo "Warning: no file given to file_exists() ";
	fi
	return 1;
}


dir_exists() {
	if is_var_set $1; then
		FILE=$1
		if [ -d "$FILE" ]; then
			return 0;
		fi
	else
		echo "Warning: no file given to file_exists() ";
	fi
	return 1;
}


#To return string values, you must echo them and capture them where you call the function like this: VAR=$(string_to_var "some_string")
#http://stackoverflow.com/questions/3236871/how-to-return-a-string-value-from-a-bash-function
string_to_var() {
	VAR="${!1}"
	echo $VAR
}


#Checks that a variable is set
#http://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
is_var_set() {
	if [ -z ${1+x} ]; then
		return 1;
	else
		return 0;
	fi
}


is_var_empty() {
	if [ -z $1 ]; then
		return 0;
	else
		return 1;
	fi
}


clean_var() {
    echo "$1" | tr -cd '[[:alnum:]]._'
}


function join { 
	local IFS="$1"; 
	shift; 
	echo "$*"; 
}


function str_to_lower() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}































