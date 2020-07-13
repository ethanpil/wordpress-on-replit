#!/bin/bash
# Install WordPress on Repl.it
# 
# Create a new Repl.it as a PHPWebServer
# wget -O - https://raw.githubusercontent.com/ethanpil/wordpress-on-replit/master/wordpress-on-replit.sh | bash

#Download, extract and cleanup required missing PHP modules
wget http://archive.ubuntu.com/ubuntu/pool/main/p/php7.2/php7.2-mysql_7.2.24-0ubuntu0.18.04.6_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/p/php7.2/php7.2-sqlite3_7.2.24-0ubuntu0.18.04.6_amd64.deb
for Module in $( ls php*.deb ); do dpkg -x $Module .; done
mkdir php
cp usr/lib/php/*/* ./php
mv mysqlnd.so A-mysqlnd.so
echo 'extension=pdo.so' > php/php.ini
mv ./php/mysqlnd.so ./php/A-mysqlnd.so #Ensure mysqlnd.so is loaded before mysqli.so
for Module in $( ls php/*.so ); do echo "extension=$Module" >> php/php.ini; done
rm -rf ./etc/ 
rm -rf ./usr/
rm php7.2-mysql_7.2.24-0ubuntu0.18.04.6_amd64.deb
rm php7.2-sqlite3_7.2.24-0ubuntu0.18.04.6_amd64.deb

#Download, extract and cleanup WordPress Latest
wget https://wordpress.org/latest.zip
unzip latest.zip
rm latest.zip

#Setup the wp-config file and salts
#todo: generate a different salt for each key
mv ./wordpress/wp-config-sample.php ./wordpress/wp-config.php
NEW_PHRASE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9!#$%&()*+,-.:;<=>?@^_`{|}~' | fold -w 60 | head -n 1)
sed -i "s/put your unique phrase here/${NEW_PHRASE}/g" ./wordpress/wp-config.php

#Download, extract and cleanup sqlite plugin for WP
cd ./wordpress/wp-content/plugins
wget https://downloads.wordpress.org/plugin/sqlite-integration.1.8.1.zip
unzip sqlite-integration.1.8.1.zip
rm sqlite-integration.1.8.1.zip
cp ./sqlite-integration/db.php ..

#Setup the repl to start PHP with the correct php.ini that includes our modules
echo 'run = "bash run.sh"' > .replit
echo '#!/bin/bash' > run.sh
echo 'export PATH=$PATH:~/usr/bin:~' >> run.sh
echo 'php -c php/php.ini -S 0.0.0.0:8000 -t wordpress/' >> run.sh
