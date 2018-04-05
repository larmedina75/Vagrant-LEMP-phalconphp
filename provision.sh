#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# Install Phalcon PHP repository
curl -s https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh | sudo bash

# update package list
sudo aptitude update -q

# Force a blank root password for mysql
#echo "mysql-server mysql-server/root_password password " | debconf-set-selections
#echo "mysql-server mysql-server/root_password_again password " | debconf-set-selections
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password pass1234'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password pass1234'
sudo -E apt-get -q -y install mysql-server

# install packages
sudo -E apt-get -q -y install \
nginx \
php7.0-fpm \
php7.0-common \
php7.0-dev \
php7.0-cli \
php7.0-curl \
php7.0-gd \
php7.0-intl \
php7.0-mbstring \
php7.0-mcrypt \
php7.0-xml \
php7.0-mysql \
php7.0-json \
php-msgpack \
php-imagick \
imagemagick \
curl \
htop \
vim \
wget \
git \
zip \
unzip 

# install phalcon php module
sudo -E apt-get -q -y install php7.0-phalcon

# nginx configuration
sudo rm /etc/nginx/nginx.conf
sudo touch /etc/nginx/nginx.conf

sudo cat >> /etc/nginx/nginx.conf <<'EOF'
user www-data;
worker_processes auto;
pid /run/nginx.pid;
events {
	worker_connections 1024;
	# multi_accept on;
}
http {
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 15;
	types_hash_max_size 2048;
	server_tokens off;
	# server_names_hash_bucket_size 64;
	# server_name_in_redirect off;
	fastcgi_buffers 16 16k;
	fastcgi_buffer_size 32k;
	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	client_max_body_size 10M;
	##
	# SSL Settings
	##
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;
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
	gzip_proxied any;
	gzip_proxied expired no-cache no-store private auth;
	# gzip_comp_level 6;
	# gzip_buffers 16 8k;
	# gzip_http_version 1.1;
	gzip_types text/plain text/css application/json application/javascript text/xml application/xml 
application/xml+rss text/javascript;
	##
	# Virtual Host Configs
	##
	include /etc/nginx/conf.d/*.conf;
	include /etc/nginx/sites-enabled/*;
}
EOF

sudo rm /etc/nginx/sites-available/default
sudo touch /etc/nginx/sites-available/default

sudo cat >> /etc/nginx/sites-available/default <<'EOF'
server {
    listen       80;
    server_name  vm01.devel www.vm01.devel;
    charset utf8;

    root /var/www/html;

    #access_log  logs/host.access.log  main;
	if ($request_method !~ ^(GET|HEAD|POST)$ )
	{
	       return 405;
	}

	location / {
 		try_files $uri $uri/ =404;
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
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    }

}
EOF

# configure phalcon host server
sudo rm /etc/nginx/sites-available/phalcon
sudo touch /etc/nginx/sites-available/phalcon
sudo cat >> /etc/nginx/sites-available/phalcon <<'EOF'
server {
        listen 80 ;
        listen [::]:80 ;
        root /var/www/phalcon/public;
        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html index.php;
        server_name  phalcon.devel www.phalcon.devel;
        charset utf8;
        location / {
                try_files $uri $uri/ /index.php?_url=$uri&$args;
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                autoindex off;
        }
        location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
            access_log        off;
            log_not_found     off;
            expires           30d;
    }
        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
        #       # With php7.0-cgi alone:
        #       fastcgi_pass 127.0.0.1:9000;
                # With php7.0-fpm:
                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }
    }
EOF

sudo ln -s /etc/nginx/sites-available/phalcon /etc/nginx/sites-enabled/phalcon

# create info.php file to show PHP modules' state
sudo touch /var/www/html/info.php
sudo cat >> /var/www/html/info.php <<'EOF'
<?php phpinfo(); ?>
EOF

# Install composer
cd /tmp/
sudo curl -sS https://getcomposer.org/installer | php
sudo mv /tmp/composer.phar /usr/local/bin/composer
sudo chmod 755 /usr/local/bin/composer

#Install Phalcon Tools
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

#Restart php7-0 service
sudo systemctl restart php7.0-fpm.service
sudo systemctl restart nginx.service