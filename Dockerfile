# Use a specific version of WordPress, in this case it will always download the latest
FROM wordpress:latest

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar cliente MySQL
RUN apt-get update && apt-get install -y default-mysql-client

# Copy plugin zip files to a temporary location
COPY all-in-one-wp-migration.zip /tmp/
COPY all-in-one-wp-migration-unlimited-extension.zip /tmp/

# Add entrypoint to install plugins
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
