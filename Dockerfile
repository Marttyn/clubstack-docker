# Dockerfile
FROM php:8.2-apache
ENV PHP_EXTRA_CONFIGURE_ARGS="--with-apxs2 --disable-cgi --with-zip"
ENV ServerName='stock.clubstack.com'

#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN apt-get update && apt-get upgrade -y && apt-get install zip unzip git -y

COPY src/ /var/www/html/
COPY conf/clubstack-stock.conf /etc/apache2/sites-available/clubstack-stock.conf
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
WORKDIR /var/www/html
RUN composer install

RUN echo "ServerName localhost" | tee /etc/apache2/conf-available/clubstack-stock.conf
RUN a2enmod rewrite && \
    a2dissite 000-default && \
    a2ensite clubstack-stock && \
    a2enconf clubstack-stock && \
    service apache2 restart

CMD ["apache2-foreground"]