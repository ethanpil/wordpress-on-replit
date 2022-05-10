{ pkgs }: {  
  deps = [  
    (pkgs.php.buildEnv {  
      extraConfig = "  
      error_reporting=On  
     zend_extension=${pkgs.phpExtensions.xdebug}/lib/php/extensions/xdebug.so 
      ";  
    })  
    pkgs.phpExtensions.curl  
    pkgs.phpExtensions.mbstring  
    pkgs.phpExtensions.pdo  
    pkgs.phpExtensions.imagick
    pkgs.phpExtensions.mysqli  
    pkgs.phpExtensions.xdebug  
    pkgs.phpPackages.phpcs  
    pkgs.phpPackages.phpstan  
    pkgs.phpPackages.psalm  
    pkgs.phpPackages.composer
    pkgs.php74
    pkgs.wget
    pkgs.zip
    pkgs.unzip
    pkgs.less
    pkgs.wp-cli
  ];  
}
