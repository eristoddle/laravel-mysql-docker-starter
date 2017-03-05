#!/bin/bash
set -e

#We will restart it in the forground at the end of the script
service apache2 stop

# Create api laravel project if it doesn't exist
if [ ! -d /var/www/html/api ]; then
    cd /var/www/html
    composer create-project --prefer-dist laravel/laravel api
    composer require yab/laracogs
    php artisan vendor:publish --provider="Yab\Laracogs\LaracogsProvider"
    artisan laracogs:api
    composer update --no-scripts
fi

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
