# Let's invoke lamp's install script
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $this_dir"/lamp.sh"

cd /opt/magento2test
ls 
pwd

#composer config -g http-basic.repo.magento.com 3ec5f766cde4b12d6d1429897c4a77ae 8d2b948729ce17a8662287730e5c1f14

#composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

chmod -R 777 var/ app/etc/ pub/media pub/static generated






echo hola