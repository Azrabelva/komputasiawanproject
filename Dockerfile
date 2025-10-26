FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# 🟢 Copy composer.json & composer.lock lebih dulu
COPY composer.json composer.lock ./

# Tambahkan baris ini untuk memastikan file lock tidak error
RUN if [ ! -f composer.lock ]; then composer update --no-interaction; fi

# 🟢 Jalankan composer install
RUN composer install --no-dev --optimize-autoloader --no-interaction || true

COPY . .

RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000  
CMD ["php-fpm"]
