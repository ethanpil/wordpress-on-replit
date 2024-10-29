#!/bin/bash
# Install WordPress on Repl.it
# 
# 1. Create a new Repl.it as a PHP Web Server 
# 2. Update the replit.nix file to include the code in this repo
# 3. Restart the Repl
# 4. Run this command from the Replit shell:
#    bash <(curl -s https://raw.githubusercontent.com/ethanpil/wordpress-on-replit/master/install-wordpress-on-replit.sh)

echo "Ready to install Wordpress in your Replit."
echo "Did you make sure you configure your replit.nix files before running this script?"

read -p "Continue? <Y/n> " prompt
if [[ $prompt == "N" || $prompt == "n" || $prompt == "No" || $prompt == "no" ]]; then
  exit 0
fi

#Make sure steps 1-3 are completed before installing Wordpress
if ! [ -x "$(command -v less)" ]; then
  echo 'Error: less is not installed. Please make sure you have updated the replit.nix file and restarted the Repl.' >&2
  exit 1
fi

if ! [ -x "$(command -v wp)" ]; then
  echo 'Error: wp-cli is not installed. Please make sure you have updated the replit.nix file and restarted the Repl.' >&2
  exit 1
fi

#Make sure we're in the right place!
cd ~/$REPL_SLUG

#remove default repl.it code file
rm ~/$REPL_SLUG/index.php

#Download Wordpress!
wp core download

#SQLITE Plugin: Download, extract and cleanup sqlite plugin for WP
curl -LG https://raw.githubusercontent.com/aaemnnosttv/wp-sqlite-db/master/src/db.php > ./wp-content/db.php

#Create dummy config to be overruled by sqlite plugin
wp config create --skip-check --dbname=wp --dbuser=wp --dbpass=pass --extra-php <<PHP
\$_SERVER[ "HTTPS" ] = "on";
define('WP_SITEURL', 'https://' . $_SERVER['HTTP_HOST']);
define('WP_HOME', 'https://' . $_SERVER['HTTP_HOST']);
define ('FS_METHOD', 'direct');
define('FORCE_SSL_ADMIN', false);
PHP

# Get info for WP install
read -p "Wordpress Username: " username
while true; do
  read -s -p "Wordpress Password: " password
  echo
  read -s -p "Wordpress Password (again): " password2
  echo
  [ "$password" = "$password2" ] && break
  echo "Please try again"
done

read -p "Wordpress Email: " email
read -p "Wordpress Website Title: " title

REPL_URL=$REPL_SLUG.$REPL_OWNER.repl.co

# Install Wordpress
wp core install --url=$REPL_URL --title=$title --admin_user=$username --admin_password=$password --admin_email=$email

echo ""
echo "Done! Your new WordPress site is now setup."
echo "Admin User: $username"
echo "Admin Password: $password"
