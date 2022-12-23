# start with the official Composer image and name it
FROM composer:2.5.0 AS composer

# continue with the official PHP image
FROM php:8.2.0-fpm-buster

# copy the Composer PHAR from the Composer image into the PHP image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# install dependencies
RUN apt-get update && apt-get install --yes libxslt-dev git zip unzip libonig-dev wait-for-it

# install PHP Core extensions
RUN docker-php-ext-install pdo_mysql bcmath xsl sockets intl mbstring soap opcache

# install APCu extension
RUN pecl install apcu && docker-php-ext-enable apcu

# install Xdebug but not enable it
RUN pecl install xdebug

# show that both Composer and PHP run as expected
RUN composer --version && php -v && php -m

# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

# Trust GitHub servers
RUN ssh-keyscan github.com >> /etc/ssh/ssh_known_hosts

# use production config
RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

# enable monitoring (for Datadog)
COPY ./php-fpm.d/monitoring.conf /usr/local/etc/php-fpm.d/monitoring.conf

# copy additional PHP configuration
COPY ./php.d/* /usr/local/etc/php/conf.d/