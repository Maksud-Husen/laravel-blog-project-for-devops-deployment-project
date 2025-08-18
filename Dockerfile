FROM php:8.0-fpm

WORKDIR /var/www/html/blog

RUN apt-get update && apt-get install -y libzip-dev unzip && \
    docker-php-ext-install zip pdo pdo_mysql
RUN apt-get install -y curl

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . .

RUN composer config --no-plugins allow-plugins.kylekatarnls/update-helper true && \
    composer install && \
    cp .env.example .env && \
    chmod 644 .env

RUN chmod -R 755 storage bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache

RUN php artisan config:clear && \
    php artisan cache:clear && \
    php artisan route:clear && \
    php artisan view:clear

EXPOSE 9000



