# -----------------------------
# STAGE 1: Build PHP dependencies
# -----------------------------
FROM composer:2.6 AS vendor

WORKDIR /app

# Copy composer files first (for Docker layer caching)
COPY composer.json composer.lock ./

# Install PHP dependencies (vendor folder)
RUN composer install --no-dev --no-scripts --no-progress --no-interaction --prefer-dist

# -----------------------------
# STAGE 2: Build Laravel App
# -----------------------------
FROM php:8.2-fpm

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/html

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    zip \
    libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip exif pcntl bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy vendor folder from the Composer stage
COPY --from=vendor /app/vendor /var/www/html/vendor

# Copy rest of Laravel project
COPY . .

# Now run Composer scripts safely (artisan exists now)
RUN composer dump-autoload --optimize && \
    php artisan package:discover --ansi || true

# Fix permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
