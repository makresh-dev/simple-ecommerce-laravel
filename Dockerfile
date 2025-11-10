# -----------------------------
# STAGE 1: Build PHP dependencies
# -----------------------------
FROM composer:2.6 AS vendor

WORKDIR /app

# Copy composer files first (for caching)
COPY composer.json composer.lock ./

# Install PHP dependencies (vendor folder)
RUN composer install --no-dev --no-scripts --no-progress --no-interaction --prefer-dist

# -----------------------------
# STAGE 2: Build Laravel App
# -----------------------------
FROM php:8.2-fpm

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/html

# Install PHP extensions and system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql zip exif pcntl bcmath \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy vendor folder from the Composer stage
COPY --from=vendor /app/vendor /var/www/html/vendor

# Copy the rest of the Laravel app
COPY . .

# -----------------------------
# Permission & Ownership Fixes
# -----------------------------
# Ensure correct ownership for Laravel writable directories and .env
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache && \
    touch /var/www/html/.env && \
    chown -R www-data:www-data /var/www/html && \
    find /var/www/html -type f -exec chmod 664 {} \; && \
    find /var/www/html -type d -exec chmod 775 {} \; && \
    chmod -R ug+rwx /var/www/html/storage /var/www/html/bootstrap/cache && \
    chmod 664 /var/www/html/.env && \
    find /var/www/html -type d -exec chmod g+s {} \;

# -----------------------------
# Optimize Laravel (optional, non-blocking)
# -----------------------------
RUN composer dump-autoload --optimize && \
    php artisan package:discover --ansi || true

# -----------------------------
# Final runtime settings
# -----------------------------
EXPOSE 9000
CMD ["php-fpm"]
