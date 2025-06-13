# Etapa 1: Composer
FROM composer:latest AS composer

# Etapa 2: PHP + Apache + Node
FROM php:8.2-apache

# Instala dependencias del sistema y extensiones PHP
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Habilita mod_rewrite para Laravel
RUN a2enmod rewrite

# Cambia DocumentRoot a /var/www/html/public para Laravel
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Copia Composer desde la imagen anterior
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Establece directorio de trabajo
WORKDIR /var/www/html

# Copia archivos del proyecto al contenedor
COPY . .

# Instala dependencias de PHP y Node.js y construye assets
RUN composer install --no-scripts --no-autoloader \
    && composer dump-autoload --optimize \
    && npm install \
    && npm run build

# Genera el enlace simbólico para storage
RUN php artisan storage:link

# Da permisos necesarios para Apache y Laravel
RUN chown -R www-data:www-data /var/www/html \
    && find /var/www/html -type d -exec chmod 755 {} \; \
    && find /var/www/html -type f -exec chmod 644 {} \; \
    && chmod -R 775 storage bootstrap/cache public

# Expone puerto 80
EXPOSE 80

# Arranca Apache
CMD ["apache2-foreground"]