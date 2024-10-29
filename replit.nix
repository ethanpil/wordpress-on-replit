{ pkgs }: {
	deps = [
		pkgs.php82
		pkgs.php82Extensions.pdo
		pkgs.php82Extensions.sqlite3
		pkgs.less
		pkgs.wp-cli
	];
}
