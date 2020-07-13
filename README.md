# wordpress-on-replit
Install WordPress and wp-cli on [Repl.it](https://repl.it/) via SQLite

1. Create a new Repl.it as a PHP Web Server
2. In the console, run this script:<br>
 `wget -O - https://raw.githubusercontent.com/ethanpil/wordpress-on-replit/master/wordpress-on-replit.sh | bash`
3. Install your WordPress site and work!

Caveats:
* WordPress is running on a local SQLite file. Not performant. Great for testing and hacking.
* WP-CLI is very hacky but works. You can execute it from the base wordpress directory with `./wp` as repl.it currently has no way to set PATH in a reliable way.
* Subject to all of the limitations of the [SQLite plugin](https://github.com/wp-plugins/sqlite-integration)
