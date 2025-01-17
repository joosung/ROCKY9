#!/bin/bash
 
#####################################################################################
#                                                                                   #
# * APMinstaller with Rocky9 Linux                                                  #
# * ROCKY Linux-9.x                                                                 #
# * Apache 2.4.X , MariaDB 10.5.X, Multi-PHP(base php7.4) setup shell script        #
# * Created Date    : 2025/1/5                                                      #
# * Created by  : Joo Sung ( webmaster@apachezone.com )                             #
#                                                                                   #
#####################################################################################

##########################################
#                                        #
#           repositories install         #
#                                        #
########################################## 

sudo dnf update -y

sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm

sudo dnf install -y epel-release mod_ssl

sudo dnf -y install wget tar openssh-clients bind-utils git nc vim-enhanced man ntsysv vim \
iotop sysstat strace lsof mc lrzsz zip unzip bzip2 glibc* net-tools bind gcc gcc-c++ cmake \
libxml2-devel libXpm-devel gmp-devel libicu-devel openssl openssl-devel gettext-devel tree \
bzip2-devel libcurl-devel libjpeg-devel libpng-devel freetype-devel readline-devel expat-devel gnupg2 \
libxslt-devel pcre-devel curl-devel ncurses-devel autoconf automake zlib-devel libuuid-devel python3 curl \
net-snmp-devel libevent-devel postgresql-devel bison make pkgconfig firewalld yum-utils perl-ExtUtils-Embed

sudo dnf -y update

cd /root/ROCKY9/APM

##########################################
#                                        #
#           SELINUX disabled             #
#                                        #
##########################################

sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
/usr/sbin/setenforce 0

##########################################
#                                        #
#           아파치 및 HTTP2 설치            #
#                                        #
########################################## 

# httpd 설치
sudo dnf install -y httpd httpd-devel

sudo systemctl enable --now httpd

sudo dnf install -y certbot python3-certbot-apache 

##########################################
#                                        #
#               firewalld                #
#                                        #
##########################################  

sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
sudo firewall-cmd --permanent --zone=public --add-port=9090/tcp
sudo firewall-cmd --permanent --zone=public --add-port=11211/tcp
sudo firewall-cmd --reload

##########################################
#                                        #
#           httpd.conf   Setup           #
#                                        #
##########################################  

sed -i '/nameserver/i\nameserver 127.0.0.1' /etc/resolv.conf
cp -av /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.original
sed -i 's/DirectoryIndex index.html/ DirectoryIndex index.html index.htm index.php index.php3 index.cgi index.jsp/' /etc/httpd/conf/httpd.conf
sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/' /etc/httpd/conf/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/' /etc/httpd/conf/httpd.conf
sed -i 's/AllowOverride none/AllowOverride All/' /etc/httpd/conf/httpd.conf
sed -i 's/#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi/' /etc/httpd/conf/httpd.conf
sed -i 's/UserDir disabled/#UserDir disabled/' /etc/httpd/conf.d/userdir.conf
sed -i 's/#UserDir public_html/UserDir public_html/' /etc/httpd/conf.d/userdir.conf
sed -i 's/Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec/Options MultiViews SymLinksIfOwnerMatch IncludesNoExec/' /etc/httpd/conf.d/userdir.conf

cp /root/ROCKY9/APM/index.html /var/www/html/
#cp -f /root/ROCKY9/APM/index.html /usr/share/httpd/noindex/

echo "<VirtualHost *:80>
  DocumentRoot /var/www/html
</VirtualHost> " >> /etc/httpd/conf.d/default.conf

sudo systemctl restart httpd
sudo systemctl restart named.service

##########################################
#                                        #
#         PHP7.4 및 라이브러리 install      #
#                                        #
########################################## 

sudo dnf config-manager --set-enabled remi -y

sudo dnf module reset php -y

sudo dnf module enable php:remi-7.4 -y

sudo dnf -y install php74 php74-php-cli php74-php-fpm \
php74-php-common php74-php-pdo php74-php-mysqlnd php74-php-mbstring php74-php-mcrypt \
php74-php-opcache php74-php-xml php74-php-pecl-imagick php74-php-gd php74-php-fileinfo \
php74-php-pecl-mysql php74-php-pecl-ssh2 php74-php-pecl-zip php74-php-soap php74-php-imap \
php74-php-json php74-php-ldap php74-php-xml php74-php-iconv php74-php-xmlrpc php74-php-snmp \
php74-php-pecl-apcu php74-php-pecl-geoip php74-php-pecl-memcached php74-php-pecl-redis \
php74-php-pecl-mailparse php74-php-pgsql php74-php-process php74-php-ioncube-loader

sudo dnf module enable php:remi-8.0 -y

sudo dnf -y install php80 php80-php-cli php80-php-fpm \
php80-php-common php80-php-pdo php80-php-mysqlnd php80-php-mbstring php80-php-mcrypt \
php80-php-opcache php80-php-xml php80-php-pecl-imagick php80-php-gd php80-php-fileinfo \
php80-php-pecl-mysql php80-php-pecl-ssh2 php80-php-pecl-zip php80-php-soap php80-php-imap \
php80-php-json php80-php-ldap php80-php-xml php80-php-iconv php80-php-xmlrpc php80-php-snmp \
php80-php-pecl-apcu php80-php-pecl-geoip php80-php-pecl-memcached php80-php-pecl-redis \
php80-php-pecl-mailparse php80-php-pgsql php80-php-process

sudo dnf module enable php:remi-8.1 -y

sudo dnf -y install php81 php81-php-cli php81-php-fpm \
php81-php-common php81-php-pdo php81-php-mysqlnd php81-php-mbstring php81-php-mcrypt \
php81-php-opcache php81-php-xml php81-php-pecl-imagick php81-php-gd php81-php-fileinfo \
php81-php-pecl-mysql php81-php-pecl-ssh2 php81-php-pecl-zip php81-php-soap php81-php-imap \
php81-php-json php81-php-ldap php81-php-xml php81-php-iconv php81-php-xmlrpc php81-php-snmp \
php81-php-pecl-apcu php81-php-pecl-geoip php81-php-pecl-memcached php81-php-pecl-redis \
php81-php-pecl-mailparse php81-php-pgsql php81-php-process php81-php-ioncube-loader

sudo dnf module enable php:remi-8.2 -y

sudo dnf -y install php82 php82-php-cli php82-php-fpm \
php82-php-common php82-php-pdo php82-php-mysqlnd php82-php-mbstring php82-php-mcrypt \
php82-php-opcache php82-php-xml php82-php-pecl-imagick php82-php-gd php82-php-fileinfo \
php82-php-pecl-mysql php82-php-pecl-ssh2 php82-php-pecl-zip php82-php-soap php82-php-imap \
php82-php-json php82-php-ldap php82-php-xml php82-php-iconv php82-php-xmlrpc php82-php-snmp \
php82-php-pecl-apcu php82-php-pecl-geoip php82-php-pecl-memcached php82-php-pecl-redis \
php82-php-pecl-mailparse php82-php-pgsql php82-php-process php82-php-ioncube-loader

sudo dnf module enable php:remi-8.3 -y

sudo dnf -y install php83 php83-php-cli php83-php-fpm \
php83-php-common php83-php-pdo php83-php-mysqlnd php83-php-mbstring php83-php-mcrypt \
php83-php-opcache php83-php-xml php83-php-pecl-imagick php83-php-gd php83-php-fileinfo \
php83-php-pecl-mysql php83-php-pecl-ssh2 php83-php-pecl-zip php83-php-soap php83-php-imap \
php83-php-json php83-php-ldap php83-php-xml php83-php-iconv php83-php-xmlrpc php83-php-snmp \
php83-php-pecl-apcu php83-php-pecl-geoip php83-php-pecl-memcached php83-php-pecl-redis \
php83-php-pecl-mailparse php83-php-pgsql php83-php-process php83-php-ioncube-loader

sudo dnf module enable php:remi-8.4 -y

sudo dnf -y install php84 php84-php-cli php84-php-fpm \
php84-php-common php84-php-pdo php84-php-mysqlnd php84-php-mbstring php84-php-mcrypt \
php84-php-opcache php84-php-xml php84-php-pecl-imagick php84-php-gd php84-php-fileinfo \
php84-php-pecl-mysql php84-php-pecl-ssh2 php84-php-pecl-zip php84-php-soap php84-php-imap \
php84-php-json php84-php-ldap php84-php-xml php84-php-iconv php84-php-xmlrpc php84-php-snmp \
php84-php-pecl-apcu php84-php-pecl-geoip php84-php-pecl-memcached php84-php-pecl-redis \
php84-php-pecl-mailparse php84-php-pgsql php84-php-process

echo 'listen = 127.0.0.1:9074
pm = ondemand' >> /etc/opt/remi/php74/php-fpm.d/www.conf

echo 'listen = 127.0.0.1:9080
pm = ondemand' >> /etc/opt/remi/php80/php-fpm.d/www.conf

echo 'listen = 127.0.0.1:9081
pm = ondemand' >> /etc/opt/remi/php81/php-fpm.d/www.conf

echo 'listen = 127.0.0.1:9082
pm = ondemand' >> /etc/opt/remi/php82/php-fpm.d/www.conf

echo 'listen = 127.0.0.1:9083
pm = ondemand' >> /etc/opt/remi/php83/php-fpm.d/www.conf

echo 'listen = 127.0.0.1:9084
pm = ondemand' >> /etc/opt/remi/php84/php-fpm.d/www.conf

sudo dnf install -y php

systemctl start php-fpm
systemctl enable php-fpm

sudo systemctl start php74-php-fpm
sudo systemctl enable php74-php-fpm

sudo systemctl start php80-php-fpm
sudo systemctl enable php80-php-fpm

sudo systemctl start php81-php-fpm
sudo systemctl enable php81-php-fpm

sudo systemctl start php82-php-fpm
sudo systemctl enable php82-php-fpm

sudo systemctl start php83-php-fpm
sudo systemctl enable php83-php-fpm

sudo systemctl start php84-php-fpm
sudo systemctl enable php84-php-fpm

#sed -i 's/php_value/#php_value/' /etc/httpd/conf.d/php.conf

echo '<Files ".user.ini">
  Require all denied
</Files>
AddType text/html .php
DirectoryIndex index.php
SetEnvIfNoCase ^Authorization$ "(.+)" HTTP_AUTHORIZATION=$1
<FilesMatch \.php$>
  SetHandler "proxy:fcgi://127.0.0.1:9074"
</FilesMatch>' >> /etc/httpd/conf.d/php.conf


sudo dnf install -y GeoIP-devel
echo "#geoip setup
<IfModule mod_geoip.c>
 GeoIPEnable On
 GeoIPDBFile /usr/share/GeoIP/GeoIP.dat MemoryCache
</IfModule>" > /etc/httpd/conf.d/geoip.conf

cp -av /etc/php.ini /etc/php.ini.original
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/php.ini
sed -i 's/display_errors = Off/display_errors = On/' /etc/php.ini
sed -i 's/;error_log = php_errors.log/error_log = php_errors.log/' /etc/php.ini
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_USER_DEPRECATED/' /etc/php.ini
sed -i 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 100M/' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/php.ini
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/php.ini
sed -i 's/disable_functions =/disable_functions = system,exec,passthru,proc_open,popen,curl_multi_exec,parse_ini_file,show_source/' /etc/php.ini 

cp -av /etc/opt/remi/php74/php.ini /etc/opt/remi/php74/php.ini.original
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/opt/remi/php74/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/opt/remi/php74/php.ini
sed -i 's/display_errors = Off/display_errors = On/' /etc/opt/remi/php74/php.ini
sed -i 's/;error_log = php_errors.log/error_log = php_errors.log/' /etc/opt/remi/php74/php.ini
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_USER_DEPRECATED/' /etc/opt/remi/php74/php.ini
sed -i 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/opt/remi/php74/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 100M/' /etc/opt/remi/php74/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/opt/remi/php74/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/opt/remi/php74/php.ini
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/opt/remi/php74/php.ini
sed -i 's/disable_functions =/disable_functions = system,exec,passthru,proc_open,popen,curl_multi_exec,parse_ini_file,show_source/' /etc/opt/remi/php74/php.ini 

cp -av /etc/opt/remi/php80/php.ini /etc/opt/remi/php80/php.ini.original
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/opt/remi/php80/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/opt/remi/php80/php.ini
sed -i 's/display_errors = Off/display_errors = On/' /etc/opt/remi/php80/php.ini
sed -i 's/;error_log = php_errors.log/error_log = php_errors.log/' /etc/opt/remi/php80/php.ini
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_USER_DEPRECATED/' /etc/opt/remi/php80/php.ini
sed -i 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/opt/remi/php80/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 100M/' /etc/opt/remi/php80/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/opt/remi/php80/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/opt/remi/php80/php.ini
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/opt/remi/php80/php.ini
sed -i 's/disable_functions =/disable_functions = system,exec,passthru,proc_open,popen,curl_multi_exec,parse_ini_file,show_source/' /etc/opt/remi/php80/php.ini 

cp -av /etc/opt/remi/php81/php.ini /etc/opt/remi/php81/php.ini.original
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/opt/remi/php81/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/opt/remi/php81/php.ini
sed -i 's/display_errors = Off/display_errors = On/' /etc/opt/remi/php81/php.ini
sed -i 's/;error_log = php_errors.log/error_log = php_errors.log/' /etc/opt/remi/php81/php.ini
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_USER_DEPRECATED/' /etc/opt/remi/php81/php.ini
sed -i 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/opt/remi/php81/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 100M/' /etc/opt/remi/php81/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/opt/remi/php81/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/opt/remi/php81/php.ini
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/opt/remi/php81/php.ini
sed -i 's/disable_functions =/disable_functions = system,exec,passthru,proc_open,popen,curl_multi_exec,parse_ini_file,show_source/' /etc/opt/remi/php81/php.ini 

cp -av /etc/opt/remi/php82/php.ini /etc/opt/remi/php82/php.ini.original
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/opt/remi/php82/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/opt/remi/php82/php.ini
sed -i 's/display_errors = Off/display_errors = On/' /etc/opt/remi/php82/php.ini
sed -i 's/;error_log = php_errors.log/error_log = php_errors.log/' /etc/opt/remi/php82/php.ini
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_USER_DEPRECATED/' /etc/opt/remi/php82/php.ini
sed -i 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/opt/remi/php82/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 100M/' /etc/opt/remi/php82/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/opt/remi/php82/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/opt/remi/php82/php.ini
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/opt/remi/php82/php.ini
sed -i 's/disable_functions =/disable_functions = system,exec,passthru,proc_open,popen,curl_multi_exec,parse_ini_file,show_source/' /etc/opt/remi/php82/php.ini 

cp -av /etc/opt/remi/php83/php.ini /etc/opt/remi/php83/php.ini.original
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/opt/remi/php83/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/opt/remi/php83/php.ini
sed -i 's/display_errors = Off/display_errors = On/' /etc/opt/remi/php83/php.ini
sed -i 's/;error_log = php_errors.log/error_log = php_errors.log/' /etc/opt/remi/php83/php.ini
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_USER_DEPRECATED/' /etc/opt/remi/php83/php.ini
sed -i 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/opt/remi/php83/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 100M/' /etc/opt/remi/php83/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/opt/remi/php83/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/opt/remi/php83/php.ini
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/opt/remi/php83/php.ini
sed -i 's/disable_functions =/disable_functions = system,exec,passthru,proc_open,popen,curl_multi_exec,parse_ini_file,show_source/' /etc/opt/remi/php83/php.ini 

cp -av /etc/opt/remi/php84/php.ini /etc/opt/remi/php84/php.ini.original
sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/opt/remi/php84/php.ini
sed -i 's/expose_php = On/expose_php = Off/' /etc/opt/remi/php84/php.ini
sed -i 's/display_errors = Off/display_errors = On/' /etc/opt/remi/php84/php.ini
sed -i 's/;error_log = php_errors.log/error_log = php_errors.log/' /etc/opt/remi/php84/php.ini
sed -i 's/error_reporting = E_ALL \& ~E_DEPRECATED/error_reporting = E_ALL \& ~E_NOTICE \& ~E_DEPRECATED \& ~E_USER_DEPRECATED/' /etc/opt/remi/php84/php.ini
sed -i 's/variables_order = "GPCS"/variables_order = "EGPCS"/' /etc/opt/remi/php84/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 100M/' /etc/opt/remi/php84/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 100M/' /etc/opt/remi/php84/php.ini
sed -i 's/;date.timezone =/date.timezone = "Asia\/Seoul"/' /etc/opt/remi/php84/php.ini
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 86400/' /etc/opt/remi/php84/php.ini
sed -i 's/disable_functions =/disable_functions = system,exec,passthru,proc_open,popen,curl_multi_exec,parse_ini_file,show_source/' /etc/opt/remi/php84/php.ini 


##########################################
#                                        #
#          설정 파일 들의 퍼미션 설정         #
#                                        #
########################################## 

mkdir /etc/skel/public_html

chmod 707 /etc/skel/public_html

chmod 700 /root/ROCKY9/adduser.sh

chmod 700 /root/ROCKY9/deluser.sh

chmod 700 /root/ROCKY9/clamav.sh

chmod 700 /root/ROCKY9/restart.sh

cp /root/ROCKY9/APM/skel/index.html /etc/skel/public_html/

rm -rf /etc/httpd/conf.d/php74-php.conf
rm -rf /etc/httpd/conf.d/php80-php.conf
rm -rf /etc/httpd/conf.d/php81-php.conf
rm -rf /etc/httpd/conf.d/php82-php.conf
rm -rf /etc/httpd/conf.d/php83-php.conf
rm -rf /etc/httpd/conf.d/php84-php.conf

systemctl restart httpd


curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

sed -i 's/allow_url_fopen = On/allow_url_fopen = Off/' /etc/php.ini
sed -i 's/allow_url_fopen = On/allow_url_fopen = Off/' /etc/opt/remi/php74/php.ini
sed -i 's/allow_url_fopen = On/allow_url_fopen = Off/' /etc/opt/remi/php80/php.ini
sed -i 's/allow_url_fopen = On/allow_url_fopen = Off/' /etc/opt/remi/php81/php.ini
sed -i 's/allow_url_fopen = On/allow_url_fopen = Off/' /etc/opt/remi/php82/php.ini
sed -i 's/allow_url_fopen = On/allow_url_fopen = Off/' /etc/opt/remi/php83/php.ini
sed -i 's/allow_url_fopen = On/allow_url_fopen = Off/' /etc/opt/remi/php84/php.ini

systemctl restart httpd

echo '<?php
phpinfo();
?>' >> /var/www/html/phpinfo.php

##########################################
#                                        #
#          MARIADB 10.5.X install        #
#                                        #
########################################## 

# MariaDB 10.5.x 설치

sudo dnf install -y mariadb mariadb-server php-mysqli

sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo mariadb-secure-installation

##########################################
#                                        #
#        운영 및 보안 관련 추가 설정           #
#                                        #
##########################################

cd /root/ROCKY9/

#chkrootkit 설치
tar xvfz chkrootkit.tar.gz

mv chkrootkit-* chkrootkit

cd chkrootkit

make sense

rm -rf /root/ROCKY9/chkrootkit.tar.gz

#mod_security fail2ban.noarch arpwatch 설치
dnf -y install  mod_security mod_security_crs fail2ban arpwatch

sed -i 's/SecRuleEngine On/SecRuleEngine DetectionOnly/' /etc/httpd/conf.d/mod_security.conf

#fail2ban 설치
service fail2ban start
chkconfig --level 2345 fail2ban on

#sed -i 's/# enabled = true/enabled = true/' /etc/fail2ban/jail.conf 
service fail2ban restart

#clamav 설치
dnf -y install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd

cp /usr/share/doc/clamd/clamd.conf /etc/clamd.conf

sed -i '/^Example/d' /etc/clamd.conf
sed -i 's/User <USER>/User clamscan/' /etc/clamd.conf
sed -i 's/#LocalSocket /LocalSocket /' /etc/clamd.conf
sed -i 's/clamd.<SERVICE>/clamd.scan/' /etc/clamd.conf

chmod 755 /var/run/clamd.scan

sed 's/710/755/' /usr/lib/tmpfiles.d/clamd.scan.conf > /etc/tmpfiles.d/clamd.scan.conf
cp /etc/freshclam.conf /etc/freshclam.conf.bak
sed -i '/^Example/d' /etc/freshclam.conf

echo "# Run the freshclam as daemon
[Unit]
Description = freshclam scanner
After = network.target
[Service]
Type = forking
ExecStart = /usr/bin/freshclam -d -c 4
Restart = on-failure
PrivateTmp = true
[Install]
WantedBy=multi-user.target" >> /usr/lib/systemd/system/clam-freshclam.service

systemctl enable clam-freshclam.service
systemctl start clam-freshclam.service
mv /usr/lib/systemd/system/clamd\@.service /usr/lib/systemd/system/clamd.service
rm -rf /usr/lib/systemd/system/clamd.service

echo "[Unit]
Description = clamd scanner daemon
After = syslog.target nss-lookup.target network.target

[Service]
Type = simple
ExecStart = /usr/sbin/clamd -c /etc/clamd.conf --foreground=yes
Restart = on-failure
PrivateTmp = true

[Install]
WantedBy=multi-user.target" >> /usr/lib/systemd/system/clamd.service

sed -i '/^Example$/d' /etc/clamd.d/scan.conf
sed -i -e 's/#LocalSocket \/var\/run\/clamd.scan\/clamd.sock/LocalSocket \/var\/run\/clamd.scan\/clamd.sock/g' /etc/clamd.d/scan.conf

systemctl enable clamd.service

systemctl start clamd.service

systemctl stop clamd.service


mkdir /virus
mkdir /backup
mkdir /root/ROCKY9/php

#memcache 설치
sudo dnf install -y memcached

sudo systemctl enable memcached.service

sudo systemctl start memcached.service

sed -i 's/OPTIONS=""/OPTIONS="-l 127.0.0.1"/' /etc/sysconfig/memcached

systemctl restart memcached


echo "#mod_expires configuration" > /tmp/httpd.conf_tempfile
echo "<IfModule mod_expires.c>"   >> /tmp/httpd.conf_tempfile
echo "    ExpiresActive On"    >> /tmp/httpd.conf_tempfile
echo "    ExpiresDefault \"access plus 1 days\""    >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType text/css \"access plus 1 days\""       >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType text/javascript \"access plus 1 days\""      >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType text/x-javascript \"access plus 1 days\""        >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType application/x-javascript \"access plus 1 days\"" >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType application/javascript \"access plus 1 days\""    >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType image/jpeg \"access plus 1 days\""    >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType image/gif \"access plus 1 days\""       >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType image/png \"access plus 1 days\""      >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType image/bmp \"access plus 1 days\""        >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType image/cgm \"access plus 1 days\"" >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType image/tiff \"access plus 1 days\""       >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType audio/basic \"access plus 1 days\""      >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType audio/midi \"access plus 1 days\""        >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType audio/mpeg \"access plus 1 days\""        >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType audio/x-aiff \"access plus 1 days\""  >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType audio/x-mpegurl \"access plus 1 days\"" >> /tmp/httpd.conf_tempfile
echo "	  ExpiresByType audio/x-pn-realaudio \"access plus 1 days\""   >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType audio/x-wav \"access plus 1 days\""   >> /tmp/httpd.conf_tempfile
echo "    ExpiresByType application/x-shockwave-flash \"access plus 1 days\""   >> /tmp/httpd.conf_tempfile
echo "</IfModule>"   >> /tmp/httpd.conf_tempfile
cat /tmp/httpd.conf_tempfile >> /etc/httpd/conf.d/mod_expires.conf
rm -f /tmp/httpd.conf_tempfile

##########################################
#                                        #
#            Local SSL 설정              #
#                                        #
##########################################

mv /root/ROCKY9/APM/etc/cron.daily/backup /etc/cron.daily/
mv /root/ROCKY9/APM/etc/cron.daily/check_chkrootkit /etc/cron.daily/

chmod 700 /etc/cron.daily/backup
chmod 700 /etc/cron.daily/check_chkrootkit


echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && /usr/bin/certbot renew" | sudo tee -a /etc/crontab > /dev/null
echo "01 01 * * 7 /root/ROCKY9/clamav.sh" >> /etc/crontab

#openssl 로 디피-헬만 파라미터(dhparam) 키 만들기 둘중 하나 선택
#openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

#중요 폴더 및 파일 링크
ln -s /etc/httpd/conf.d /root/ROCKY9/conf.d
ln -s /etc/my.cnf /root/ROCKY9/my.cnf
ln -s /etc/php.ini /root/ROCKY9/php/php.ini
ln -s /etc/opt/remi/php74/php.ini /root/ROCKY9/php/php74.ini
ln -s /etc/opt/remi/php80/php.ini /root/ROCKY9/php/php80.ini
ln -s /etc/opt/remi/php81/php.ini /root/ROCKY9/php/php81.ini
ln -s /etc/opt/remi/php82/php.ini /root/ROCKY9/php/php82.ini
ln -s /etc/opt/remi/php83/php.ini /root/ROCKY9/php/php83.ini
ln -s /etc/opt/remi/php84/php.ini /root/ROCKY9/php/php84.ini

service httpd restart

cd /root/ROCKY9

##########################################
#                                        #
#             Cockpit install            #
#                                        #
########################################## 

dnf install -y cockpit

systemctl enable --now cockpit.socket

sh restart.sh

echo ""
echo ""
echo "축하 드립니다. APMinstaller 모든 작업이 끝났습니다."

exit 0