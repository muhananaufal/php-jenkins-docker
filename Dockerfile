# Gunakan official image PHP dengan server Apache
FROM php:8.0-apache

# Salin semua file dari direktori saat ini ke direktori web server di dalam container
COPY . /var/www/html/

# Instal dependensi Composer
# Pertama, salin installer composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Jalankan composer install untuk mengunduh dependensi (seperti PHPUnit)
RUN composer install
