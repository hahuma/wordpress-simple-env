# Use a specific version of WordPress, in this case it will always download the latest
FROM wordpress:latest

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy and install Plugins automatically 
COPY all-in-one-wp-migration.zip /usr/src/wordpress/wp-content/plugins/
COPY all-in-one-wp-migration-unlimited-extension.zip /usr/src/wordpress/wp-content/plugins/

RUN wp plugin install /usr/src/wordpress/wp-content/plugins/all-in-one-wp-migration.zip --allow-root --activate
RUN wp plugin install /usr/src/wordpress/wp-content/plugins/all-in-one-wp-migration-unlimited-extension.zip --allow-root --activate
