#!/usr/bin/env bash
##############################
#CONFIGURATION
##############################

#
# *DO NOT* ADD THE TRAILING SLASH TO THE DIRECTORIES!
#

##########REQUIRED
# One of the following: laravel, magento1, magento2, lamp
PROJECT_TYPE="THE_PROJECT_TYPE"

##########REQUIRED
# No spaces or strange chars. Gets stripped, lowercased and allows only alphanumeric _ .
# Will be used for folder names, default domain, default db name, etc
PROJECT_NAME="THE_PROJECT_NAME"

##########REQUIRED
#Root folder of the project code
PROJECT_DIR="THE_ABS_PATH_TO_ROOT"

##########REQUIRED
#Folder where Mysql related files will be saved so that we can persist DB Changes on container reboots.
PROJECT_DB_DIR="THE_ABS_PATH_TO_DB"

##########REQUIRED. But can be empty (EX: Magento is empty)
# Leave empty if public dir is the same than code root dir (magento for example)
# Laravel example: PUBLIC_DIR="/public".
PUBLIC_DIR="THE_PUBLIC_DIR"



#Example testing.com. If empty defaults to $PROJECT_NAME.com
PROJECT_DOMAIN=""

#Example testing. If empty defaults to $PROJECT_NAME
DB_NAME=""

DB_PASSWORD="Kafe_#1234"

#
#
#
#
# Usually you shouldn't edit anything beyond this point
#
#
#
#



#Clean PROJECT_NAME in case someone used a wrong format
PROJECT_NAME=$(format_var ${PROJECT_NAME})

#Detect OS
SYSTEM_OS=$(uname)

configure_aliases

#Used for the domain: local.DOMAIN.com
LOCAL_PREFIX="local"

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

#Linux
#ROOT_DIR=$(readlink --canonicalize $ROOT_DIR)
#Mac
#ROOT_DIR=$(greadlink -f $ROOT_DIR)

ROOT_DIR=$($readlink "$ROOT_DIR")


HOME_DIR="$( cd ~ && pwd)"
SSH_DIR=$HOME_DIR"/.dockerssh"



#A link to the PROJECT PUBLIC folder will be created inside the server's www dir.
# Define server's dir
DOCKER_WWW_DIR="/var/www"

#Define the code's root dir inside docker's container
DOCKER_CODE_ROOT_DIR="/opt/$PROJECT_NAME"

#For persistent mysql storage
DOCKER_MYSQL_DIR="/var/lib/mysql"

#Docker Container Includes Folder
DOCKER_SETUP_DIR="/tmp/_di"

DOCKER_SCRIPTS_DIR=$ROOT_DIR"/scripts"

DOCKER_CUSTOM_DIR=$ROOT_DIR"/custom"

DOCKER_SSH_DIR="/root/.ssh"


#CONTAINER_REQ_DIR=$ROOT_DIR"/scripts"



##############################
#END CONFIGURATION
##############################

