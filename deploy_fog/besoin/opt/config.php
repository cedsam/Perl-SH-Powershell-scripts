<?php
define( "UPDSENDERPATH", "/usr/local/sbin/udp-sender" );
define( "MULTICASTLOGPATH", "/opt/fog/log/multicast.log" );
define( "MULTICASTDEVICEOUTPUT", "/dev/tty2" );
define( "MULTICASTSLEEPTIME", 10 );
define( "MULTICASTINTERFACE", "eth0" );
define( "UDPSENDER_MAXWAIT", null );

define( "MYSQL_HOST", "localhost" );
define( "MYSQL_DATABASE", "fog" );
define( "MYSQL_USERNAME", "root" );
define( "MYSQL_PASSWORD", "#mysql!fog" );

define( "LOGMAXSIZE", "1000000" );

define( "REPLICATORLOGPATH", "/opt/fog/log/fogreplicator.log" );
define( "REPLICATORDEVICEOUTPUT", "/dev/tty3" );
define( "REPLICATORSLEEPTIME", 600 );
define( "REPLICATORIFCONFIG", "/sbin/ifconfig" );

define( "SCHEDULERLOGPATH", "/opt/fog/log/fogscheduler.log" );
define( "SCHEDULERDEVICEOUTPUT", "/dev/tty4" );
define( "SCHEDULERWEBROOT", "/var/www/fog" );
define( "SCHEDULERSLEEPTIME", 60 );
?>
