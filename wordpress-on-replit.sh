#!/bin/bash
# Install WordPress on Repl.it
# 
# Create a new Repl.it as a PHP Web Server and run this script.
# wget -O - https://raw.githubusercontent.com/ethanpil/wordpress-on-replit/master/wordpress-on-replit.sh | bash

#Download, extract and cleanup required missing PHP modules
wget http://archive.ubuntu.com/ubuntu/pool/main/p/php7.2/php7.2-mysql_7.2.24-0ubuntu0.18.04.7_amd64.deb
for Module in $( ls php*.deb ); do dpkg -x $Module .; done
mkdir ~/$REPL_SLUG/php
cp usr/lib/php/*/* ~/$REPL_SLUG/php
echo 'extension=pdo.so' > ~/$REPL_SLUG/php/php.ini
mv ~/$REPL_SLUG/php/mysqlnd.so ~/$REPL_SLUG/php/A-mysqlnd.so #To ensure mysqlnd.so is loaded before mysqli.so
for Module in $( ls ~/$REPL_SLUG/php/*.so ); do echo "extension=$Module" >> ~/$REPL_SLUG/php/php.ini; done
rm -rf ./etc/ 
rm -rf ./usr/
rm php7.2-mysql_7.2.24-0ubuntu0.18.04.7_amd64.deb

#Download and setup portable mariadb
cd ~/$REPL_SLUG/
wget -O portable-mariadb.tbz2 https://raw.githubusercontent.com/pts/portable-mariadb/master/release/portable-mariadb-5.5.46.tbz2
tar xjvf portable-mariadb.tbz2
rm portable-mariadb.tbz2
chmod 700 ./portable-mariadb

#Download, extract and cleanup WordPress Latest
wget https://wordpress.org/latest.zip
unzip latest.zip
rm latest.zip

#Setup the wp-config file and salts
#todo: generate a different salt for each key
mv ./wordpress/wp-config-sample.php ./wordpress/wp-config.php
NEW_PHRASE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9!#$%&()*+,-.:;<=>?@^_{|}~' | fold -w 60 | head -n 1)
sed -i "s/put your unique phrase here/${NEW_PHRASE}/g" ./wordpress/wp-config.php

#set database details
sed -e "s/database_name_here/$dbname/" wp-config.php
sed -e "s/username_here/$dbuser/g" wp-config.php

#Add SSL fix to wp-config.php for repl.it proxy
echo '$_SERVER[ "HTTPS" ] = "on";' >> ./wordpress/wp-config.php


#Download, extract and setup wp-cli and dependencies
cd ~
wget http://archive.ubuntu.com/ubuntu/pool/main/l/less/less_551-2_amd64.deb
for Module in $( ls less*.deb ); do dpkg -x $Module .; done
mv ./usr/ ~/$REPL_SLUG
rm -rf less*
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar ~/$REPL_SLUG/php/wp-cli.phar

#hacky way to get wp-cli working in limited repli.it shell
cat > ~/$REPL_SLUG/wordpress/wp <<EOL
#!/bin/bash
export PATH=$PATH:~/$REPL_SLUG/usr/bin:~/$REPL_SLUG:~/$REPL_SLUG/php
php -c ~/$REPL_SLUG/php/php.ini ~/$REPL_SLUG/php/wp-cli.phar "\$@"
EOL
chmod +x ~/$REPL_SLUG/wordpress/wp

#remove default repl.it code file
rm ~/$REPL_SLUG/index.php

#Setup the repl to start PHP with the correct php.ini that includes our modules
echo 'run = "php -c ~/$REPL_SLUG/php/php.ini -S 0.0.0.0:8000 -t wordpress/"' >> ~/$REPL_SLUG/.replit

echo "Done!"
