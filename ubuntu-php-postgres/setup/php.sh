#!/usr/bin/env bash

# Install php-7.0
sudo apt-get install -y php7.0 php7.0-pgsql php7.0-fpm php7.0-xml

echo "Successfully installed PHP-7"

# Installing Symphony2
echo "date.timezone = Europe/Moscow" >> /etc/php/7.0/cli/php.ini
sudo curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony

echo "Successfully installed Symfony2"