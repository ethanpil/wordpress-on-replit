# Run WordPress on Repl.it
Install WordPress and wp-cli on [Repl.it](https://repl.it/) using SQLite

## How
1. Create a new Repl.it as a PHP Web Server
2. Update the replit.nix file to include the code in this repo
3. Restart the Repl
4. Run this command from the Replit shell:
`bash <(curl -s https://raw.githubusercontent.com/ethanpil/wordpress-on-replit/master/install-wordpress-on-replit.sh)`

## Caveats:
* WordPress is running on a local SQLite file. Not performant. Great for testing and hacking.
* WordPress is running on PHP's built in web server which doesn't support rewrites (fancy URLs)
* Subject to all of the limitations of the [SQLite plugin](https://github.com/aaemnnosttv/wp-sqlite-db)

## Future
I would like to explore setting up a Router Script for the PHP web server to see if I can get rewrites working. Some initial research:
* https://gist.github.com/thiagof/d940f8fe4b265c8c15f3109b45aa5001
* https://www.php.net/manual/en/features.commandline.webserver.php
* https://stackoverflow.com/questions/27381520/php-built-in-server-and-htaccess-mod-rewrites

## How It Works

[Repl.it](https://repl.it/) now allows users to configure a REPL via Nix. The newest Nix environments include packages for PHP with SQLite Support, as well as WP-Cli support. So everything you need is now available. (Unlike in the past when we really had to go deep in and mess with things in a nasty way).

All we have to do now is setup Repl to load in the correct Nix packages and install WordPress with the SQLite plugun. The `replit.nix` file in this Repo includes the necessary Nix packages and the Bash script `install-wordpress-on-replit.sh` simply automates the Wordpress install.

The script does the following:

1. Check to make sure Nix has installed the packages needed for WP-Cli (less and wp).
2. Download WordPress files through WP-Cli
3. Download and install the SQLite plugin for WordPress
4. Create a basic `wp-config.php` file with some tweaks for Replit and your Repl URL.
5. Ask for your prefered credentials and install WP

## Thanks & Credits

Nix Version:
* https://github.com/aaemnnosttv/wp-sqlite-db
* https://wp-cli.org/

Orignial Version:
* https://repl.it/talk/learn/Installing-WordPress-on-Replit/34284
* https://wordpress.org/plugins/sqlite-integration/
* https://wp-cli.org/
