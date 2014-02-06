#!/usr/bin/env bash

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- MySQL ---"
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password DATABASEPASSWORD'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password DATABASEPASSWORD'

echo "--- Installing base packages ---"
sudo apt-get install -y vim curl python-software-properties

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- PHP ---"
sudo add-apt-repository -y ppa:ondrej/php5

echo "--- Updating packages list ---"
sudo apt-get update

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "--- Enabling mod-rewrite ---"
sudo a2enmod rewrite

echo "--- Setting document root ---"
sudo rm -rf /var/www
sudo ln -fs /vagrant/public /var/www


echo "--- Turn errors on. ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

echo "--- Restarting Apache ---"
sudo service apache2 restart

echo "--- Install composer ---"
curl -sS https://getcomposer.org/installer | php
sudo cp composer.phar /usr/local/bin/composer

# Laravel specific commands

echo "--- Change php.ini settings to allow tinker to function correctly. ---"
sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

echo "--- Set up env vars in default virtual host file. ---"
sudo rm -rf /etc/apache2/sites-available/000-default.conf
cp /vagrant/.setup/000-default.conf /etc/apache2/sites-available

echo "--- Restarting Apache ---"
sudo service apache2 restart

echo "--- Creating database. ---"
mysql -uroot -pDATABASEPASSWORD -e"CREATE DATABASE DATABASENAME"

echo "--- Updating database configuration file---"
sed -i "s/'host'  => 'localhost'/'host'  => getenv('DB_HOST')/g" /vagrant/app/config/database.php
sed -i "s/'database'  => 'database'/'database'  => getenv('DB_NAME')/g" /vagrant/app/config/database.php
sed -i "s/'username'  => 'root'/'username'  => getenv('DB_USER')/g" /vagrant/app/config/database.php
sed -i "s/'password'  => ''/'password'  => getenv('DB_PASSWORD')/g" /vagrant/app/config/database.php

echo "--- Moving bash files---"
cp /vagrant/.setup/.bash_env /home/vagrant
cp /vagrant/.setup/.bash_aliases /home/vagrant
cp /vagrant/.setup/.bash_profile /home/vagrant

chmod +x /vagrant/.setup/wkhtmltopdf.sh