FROM php:7.4-apache-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    gnupg2 \
    libxml2-dev \
    libltdl-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Fix for the libltdl.la error: Create a symlink or dummy file if it's missing
# This prevents the 'can't read /usr/lib/x86_64-linux-gnu/libltdl.la' error
RUN mkdir -p /usr/lib/x86_64-linux-gnu/ && \
    ln -s /usr/lib/x86_64-linux-gnu/libltdl.so /usr/lib/x86_64-linux-gnu/libltdl.la || true

# Install Microsoft SQL Server Drivers
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Install PHP Extensions (using specific versions for PHP 7.4)
RUN pecl channel-update pecl.php.net \
    && pecl install sqlsrv-5.10.1 \
    && pecl install pdo_sqlsrv-5.10.1 \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv \
    && docker-php-ext-install bcmath gd

# Enable Apache Mod_Rewrite
RUN a2enmod rewrite

# Fix the .htaccess security warning by allowing overrides in the web directory
RUN echo "<Directory /var/www/html>\n\
    Options Indexes FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" >> /etc/apache2/apache2.conf

# Restart apache to apply (Docker handles this on start, but good for clarity)
COPY ./src /var/www/html/
RUN chown -R www-data:www-data /var/www/html
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

