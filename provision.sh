#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# add phalconphp PPA
sudo apt-add-repository -y ppa:phalcon/stable

sudo aptitude update -q

# Force a blank root password for mysql
#echo "mysql-server mysql-server/root_password password " | debconf-set-selections
#echo "mysql-server mysql-server/root_password_again password " | debconf-set-selections
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password pass1234'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pass1234'

# Install mysql, nginx, php5-fpm
sudo -E apt-get -q -y install mysql-server
sudo aptitude install -q -y -f mysql-client nginx php5-fpm php5-cli php5-phalcon

# Install commonly used php packages
sudo aptitude install -q -y -f php5-mysql php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcached php5-ming php5-ps php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xcache git
# php5-pspell php5-snmp snmp

sudo rm /etc/nginx/nginx.conf
sudo touch /etc/nginx/nginx.conf

sudo cat >> /etc/nginx/nginx.conf <<'EOF'
user www-data;
worker_processes 1;
pid /run/nginx.pid;

events {
	worker_connections 1024;
	multi_accept on;
	use epoll;
}

http {

	##
	# Basic Settings
	##

	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 15;
	types_hash_max_size 2048;
	server_tokens off;

	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	##
	# Logging Settings
	##

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	##
	# Gzip Settings
	##

	gzip on;
	gzip_disable "msie6";

	gzip_vary on;
	gzip_proxied expired no-cache no-store private auth;
	# gzip_comp_level 6;
	# gzip_buffers 16 8k;
	# gzip_http_version 1.1;
	gzip_types text/plain text/css text/xml text/javascript application/json application/x-javascript application/xml application/xml+rss;

	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}
EOF


sudo rm /etc/nginx/sites-available/default
sudo touch /etc/nginx/sites-available/default

sudo cat >> /etc/nginx/sites-available/default <<'EOF'
server {
    listen       80;
    server_name  www.phvm01.dev;

    charset utf8;

    #access_log  logs/host.access.log  main;

	if ($request_method !~ ^(GET|HEAD|POST)$ )
	{
	       return 405;
	}

    location / {
        root   html;
        index  index.html index.htm;
    autoindex off;
    }

	location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
            access_log        off;
            log_not_found     off;
            expires           30d;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }

	location ~ \.php$ {
		try_files $uri =404;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}


}
EOF

sudo touch /usr/share/nginx/html/info.php
sudo cat >> /usr/share/nginx/html/info.php <<'EOF'
<?php phpinfo(); ?>
EOF

# start Ptoject

mkdir -p /var/www/phalconphp/public

sudo touch /etc/nginx/sites-available/phalconphp
sudo cat >> /etc/nginx/sites-available/phalconphp <<'EOF'
server {
    #listen       80;

    root /var/www/phalconphp/public/;
    index  index.php;

    charset utf8;

    #access_log  logs/host.access.log  main;
    #access_log /var/www/phalconphp/logs/access.log;
    #error_log /var/www/phalconphp/logs/error.log;

	if ($request_method !~ ^(GET|HEAD|POST)$ )
	{
	       return 405;
	}

    location / {
        autoindex off;
        try_files $uri $uri/ /index.php?$args;
    }

	location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
            access_log        off;
            log_not_found     off;
            expires           30d;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    #error_page   500 502 503 504  /50x.html;
    #location = /50x.html {
    #    root   html;
    #}

	location ~ \.php$ {
		try_files $uri =404;
		fastcgi_split_path_info ^(.+\.php)(/.+)$;
		fastcgi_pass unix:/var/run/php5-fpm.sock;
		fastcgi_index index.php;
		include fastcgi_params;
	}

}
EOF

sudo ln -s /etc/nginx/sites-available/phalconphp /etc/nginx/sites-enabled/phalconphp

# end Project


#sudo aptitude install -q -y -f phpmyadmin

sudo service nginx restart

sudo service php5-fpm restart

# Install composer
cd /tmp/
sudo curl -sS https://getcomposer.org/installer | php
sudo mv /tmp/composer.phar /usr/local/bin/composer
sudo chmod 755 /usr/local/bin/composer

sudo touch /tmp/composer.json
sudo cat >> /tmp/composer.json <<'EOF'
{
"require": {
"phalcon/devtools": "dev-master"
}
}
EOF

sudo composer install

sudo mv /tmp/vendor/phalcon/devtools /opt/
sudo ln -s /opt/devtools/phalcon.php /usr/bin/phalcon
sudo chmod ugo+x /usr/bin/phalcon