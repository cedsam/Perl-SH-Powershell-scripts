#!/bin/bash
dpkg --configure -a
apt-get upgrade
apt-get update
apt-get install make
apt-get install libxml-simple-perl
apt-get install libcompress-zlib-perl
apt-get install libdbi-perl
apt-get install libdbd-mysql-perl
apt-get install libapache-dbi-perl
apt-get install libnet-ip-perl
apt-get install libsoap-lite-perl
cpan -i XML::Entities
apt-get install libphp-pclzip
apt-get install php-pear
apt-get install libpcre3
apt-get install libpcre3-dev
pecl install zip
apt-get install php5-gd
apt-get install apache2 apache2-doc
apt-get install mysql-server
apt-get install php5 php5-mysql php5-gd
apt-get install libapache2-mod-perl2 libxml-simple-perl libcompress-zlib-perl libapache-dbi-perl libnet-ip-perl libsoap-lite-perl
apt-get install libc6-dev
apt-get install libdbd-mysql-perl libnet-ip-perl libsoap-lite-perl
apt-get install perl libapache2-mod-perl2 libxml-simple-perl libcompress-zlib-perl libdbi-perl libapache-dbi-perl
apt-get install phpmyadmin
cpan -i {{SOAP::Transport::HTTP}}
perl -MCPAN -e 'install XML::Entities'
perl -MCPAN -e 'install SOAP::Lite'
/etc/init.d/apache2 reload
apache2ctl restart
