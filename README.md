# Run WordPress on Repl.it
Install WordPress and wp-cli on [Repl.it](https://repl.it/) via SQLite

## How
1. Create a new Repl.it as a PHP Web Server
2. In the console, run this script:<br>
 `wget -O - https://raw.githubusercontent.com/ethanpil/wordpress-on-replit/master/wordpress-on-replit.sh | bash`
3. Install your WordPress site and work!

## Caveats:
* WordPress is running on a local SQLite file. Not performant. Great for testing and hacking.
* WP-CLI is very hacky but works. You can execute it from the base wordpress directory with `./wp` as repl.it currently has no way to set PATH in a reliable way.
* Subject to all of the limitations of the [SQLite plugin](https://github.com/wp-plugins/sqlite-integration)

## Notes:
You can remove wp-cli by deleting `wordpress/wp` and `~/php/wp-cli.phar` and `~/usr`

## How It Works

*Overview*

[Repl.it](https://repl.it/) does not have MySQL available for `PHP Web Server` repls, but even more surprisingly, the SQLite extension is also not included. We also have quite a few limitations. The shell is quite hardened, and we cannot install packages or even modify the path. PHP code that is available via the public port is served by  [PHP's Command Line Web Server](https://www.php.net/manual/en/features.commandline.webserver.php) and passed through to port 80 via the repl's public URL.

*Getting the PHP Modules loaded*

Luckily, we know that Repl.it runs [Ubuntu](https://hub.docker.com/r/replco/polygott) as the base image for all languages. What we have to do is download the correct PHP modules for Ubuntu and then get PHP to load them at runtime. Fortunately, Repl.it also allows us to [define a custom run command](https://docs.repl.it/repls/dot-replit) where we can force PHP start the Command Line Web Server but using our customized php.ini file which loads the modules.

*Getting WP-CLI working*

Since WP-CLI does not use the run command, but is actually run at the command line, we cannot expect the modules to be available for it. Addtionally, we cannot simply alter the `PATH` variable in Bash to make an easy alias. What finally worked was creating a simple Bash script as `wordpress/wp` which loads the path and then forces php to run the WP-CLI phar file with a custom php.ini as defined in `~/php/php.ini` and viola! It's hacky and barely works. I'm sure lots of functions don't, and it has not been fully tested. Some examples that worked:

* `./wp plugin install disable-comments`
* `./wp plugin activate disable-comments`

## Paths
The php modules are downloaded to `~/php` and the .ini file is created there as well
WP-CLI requires `less` which for some reason is also not included in the base image, so that is downloaded and installed into `~/usr/bin`

## Thanks & Credits
* My starting point https://repl.it/talk/learn/Installing-WordPress-on-Replit/34284
* https://wordpress.org/plugins/sqlite-integration/
* https://wp-cli.org/
