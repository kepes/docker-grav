FROM php:7.2-apache

# Based on the official Wordpress docker file

RUN a2enmod rewrite expires

# install the PHP extensions we need
RUN apt-get update
RUN apt-get install -y git libpng-dev libjpeg-dev zlib1g-dev rsync && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr
RUN docker-php-ext-install gd mysqli opcache zip mbstring

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

ENV GRAV_VERSION 1.6.16
ENV APACHE_RUN_USER 'web'
ENV APACHE_RUN_GROUP 'staff'

RUN useradd -b /var/www/html/ -g 50 -M -u 1000 web

WORKDIR /tmp

RUN curl -o grav.tar.gz -SL https://github.com/getgrav/grav/archive/${GRAV_VERSION}.tar.gz
RUN tar -xzf grav.tar.gz -C /tmp
RUN ls -la /tmp
RUN ls -la /tmp/grav-${GRAV_VERSION}
RUN ls -la /tmp/grav-${GRAV_VERSION}/bin

WORKDIR /tmp/grav-${GRAV_VERSION}
RUN bin/grav install

RUN rsync -a /tmp/grav-${GRAV_VERSION}/ /var/www/html
#RUN /var/www/html/bin/grav install
RUN chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /var/www/html

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

WORKDIR /var/www/html
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
