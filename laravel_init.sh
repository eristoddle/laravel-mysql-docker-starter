#!/bin/bash
set -e

#We will restart it in the forground at the end of the script
service apache2 stop

#Laravel log permissions
sudo chown -R www-data:www-data /var/www/html/api/storage
sudo chmod -R 777 /var/www/html/api/storage
sudo chmod -R 777 /var/www/html/api/bootstrap/cache
cd /var/www/html/api
php artisan cache:clear
composer dump-autoload

#Launch apache in the foreground
#We do this in the forground so that Docker can watch
#the process to detect if it has crashed
apache2 -DFOREGROUND
