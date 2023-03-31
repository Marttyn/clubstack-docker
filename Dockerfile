# Dockerfile
FROM php:8-apache
ENV PHP_EXTRA_CONFIGURE_ARGS="--with-apxs2 --disable-cgi --with-zip"
ENV ServerName='stock.clubstack.com'

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN apt-get update && apt-get install wget zip unzip git -y

COPY src/ /var/www/html/
COPY conf/clubstack-stock.conf /etc/apache2/sites-available/clubstack-stock.conf
RUN a2enmod rewrite && \
    a2dissite 000-default && \
    a2ensite clubstack-stock && \
    service apache2 restart

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
WORKDIR /var/www/html
RUN composer install

EXPOSE 80
CMD ["apache2-foreground"]