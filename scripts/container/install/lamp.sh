#Include functions file, needed to check some config values in the config file
source "/tmp/_di/scripts/common/functions.sh"

#Include config file
CONFIG_FILE="/tmp/_di/custom/config.sh"
source $CONFIG_FILE

#######################################################
#CREATE DB (Mysql 5.6)
#For some reason, when installing Mysql, it is using version 5.7 instead of 5.6, even when explicitly adding the repos for 5.6 in the Lamp Image
#######################################################
#service mysqld start && mysql < /tmp/_di/custom/dbinstall.sql

#######################################################
# CREATE DB (Mysql 5.7)
#######################################################

#Start MySql
service mysqld start
/etc/init.d/mysqld start

#Get new password (MySql 5.7 creates random psw for root user on install https://stackoverflow.com/questions/33991228/what-is-the-default-root-pasword-for-mysql-5-7)
password=$(cat /var/log/mysqld.log | grep "A temporary password is generated for" | tail -1 | sed -n 's/.*root@localhost: //p')
echo Root password is $password
echo new psw is $DB_PASSWORD

#TODO: if password is not empty, change to DB_PASSWORD
	if ! is_var_empty $password; then
		mysql --connect-expired-password -uroot -p"$password" -Bse "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"

	fi

#mysql --connect-expired-password -uroot -p"$password" -Bse "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
mysql -uroot -p"$DB_PASSWORD" < /tmp/_di/custom/dbinstall.sql





#not needed, this just shows the log file line where it spits the psw. Leaving for reference
#grep 'temporary password' /var/log/mysqld.log




