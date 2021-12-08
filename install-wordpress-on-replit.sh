#!/bin/bash
# Install WordPress on Repl.it
# 
# 1. Create a new Repl.it as a PHP Web Server 
# 2. Update the replit.nix file to include the code in this repo
# 3. Restart the Repl
# 4. Run this script: wget -O - https://raw.githubusercontent.com/ethanpil/wordpress-on-replit/master/install-wordpress-on-replit.sh | bash

echo "Ready to install Wordpress in your Replit."
echo "Did you make sure you configure your replit.nix files before

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
wget --directory-prefix=./wp-content https://raw.githubusercontent.com/aaemnnosttv/wp-sqlite-db/master/src/db.php

# Get info for WP install
echo -n Wordpress Admin Username: 
read -s username

echo -n Wordpress Admin Password: 
read -s password

echo -n Wordpress Admin Email: 
read -s email

echo -n Wordpress Website Title: 
read -s title

REPL_URL=$REPL_SLUG.$REPL_OWNER.repl.co
wp core install --url=$REPL_URL --title=$TITLE --admin_user=$username --admin_password=$password --admin_email=$email

#Add SSL fix to wp-config.php for repl.it proxy
echo '$_SERVER[ "HTTPS" ] = "on";' >> ./wordpress/wp-config.php
echo 'define ('FS_METHOD', 'direct');' >> ./wordpress/wp-config.php

echo ""
echo "Done! Your new WordPress site is now setup."
echo "URL: https://$REPL_URL"
echo "Admin URL: https://$REPL_URL/wp-admin"
echo "Admin User: $USERNAME"
echo "Admin Password: $password"
