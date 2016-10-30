# Edit the following to change the name of the database user that will be created:
APP_DB_USER=vagrant
APP_DB_PASS=vagrant

# Edit the following to change the name of the database that is created (defaults to the user name)
APP_DB_NAME=yandex-photos

# Edit the following to change the version of PostgreSQL that is installed
PG_VERSION=9.5

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "psql access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su postgres"
  echo "  psql -h localhost -U $APP_DB_USER -d $APP_DB_NAME -W"
  echo "\n"
  echo "Env variable for application development:"
  echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:5432/$APP_DB_NAME"
  echo "\n"
  echo "Local command to access the database via psql:"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 5432 $APP_DB_NAME"
}

sudo apt-get install -y software-properties-common python-software-properties
sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -


# Update package list and upgrade all packages
sudo apt-get update
sudo apt-get -y upgrade

# Install php-7.0 
sudo apt-get install -y php7.0 php7.0-pgsql php7.0-fpm php7.0-xml

# Installing Symphony2
echo "date.timezone = Europe/Moscow" >> /etc/php/7.0/cli/php.ini
sudo curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
sudo chmod a+x /usr/local/bin/symfony
mkdir /web


# Install PostgreSql
sudo apt-get -y install postgresql-$PG_VERSION postgresql-contrib-$PG_VERSION

PG_CONF="/etc/postgresql/$PG_VERSION/main/postgresql.conf"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"
PG_DIR="/var/lib/postgresql/$PG_VERSION/main"

echo "PGROOT=/var/lib/postgresql" >> ~/.bashrc

# Edit postgresql.conf to change listen address to '*':
sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"

# Append to pg_hba.conf to add password auth:
echo "host    all             all             all                     md5" > "$PG_HBA"

# Explicitly set default client_encoding
echo "client_encoding = utf8" >> "$PG_CONF"

# Installing locale packages
sudo apt-get install -y language-pack-ru
sudo apt-get install -y language-pack-en

# Restart so that all new config is loaded:
service postgresql restart

cat << EOF | sudo su postgres -c psql
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';

CREATE DATABASE "$APP_DB_NAME" WITH OWNER=$APP_DB_USER
                                 LC_COLLATE='en_US.utf8'
                                 LC_CTYPE='en_US.utf8'
                                 ENCODING='UTF8'
                                 TEMPLATE=template0;
EOF

# Tag the provision time:
# date > "$PROVISIONED_ON"

echo "Successfully created PostgreSQL dev virtual machine."
echo ""
print_db_usage
