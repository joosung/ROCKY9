#!/bin/bash

systemctl restart php-fpm
systemctl restart php74-php-fpm 
systemctl restart php80-php-fpm 
systemctl restart php81-php-fpm 
systemctl restart php82-php-fpm 
systemctl restart php83-php-fpm 
systemctl restart php84-php-fpm 

systemctl restart httpd