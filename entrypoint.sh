#!/bin/bash

# Display the files in /tmp to check if the plugins were copied correctly
echo "Listing files in /tmp before moving:"
ls -l /tmp

# Display the files in the WordPress plugin directory to check the initial state
WORDPRESS_PATH="/var/www/html"
PLUGIN_DIR="${WORDPRESS_PATH}/wp-content/plugins"
echo "Listing files in the plugin directory before moving:"
ls -l ${PLUGIN_DIR}

# Wait until the database is ready before proceeding
echo "Checking database connection..."
until wp db check --allow-root --path=${WORDPRESS_PATH}; do
  echo "Waiting for MySQL..."
  sleep 5
done
echo "Database is ready!"

# Move the plugins from the temporary location to the WordPress plugin directory
echo "Moving plugin files..."
mv /tmp/all-in-one-wp-migration.zip ${PLUGIN_DIR}/
mv /tmp/all-in-one-wp-migration-unlimited-extension.zip ${PLUGIN_DIR}/

# Check if the files were moved correctly
echo "Listing files in the plugin directory after moving:"
ls -l ${PLUGIN_DIR}

# Install the WordPress plugins
echo "Installing WordPress plugins..."
wp --path=${WORDPRESS_PATH} plugin install ${PLUGIN_DIR}/all-in-one-wp-migration.zip --allow-root --activate
wp --path=${WORDPRESS_PATH} plugin install ${PLUGIN_DIR}/all-in-one-wp-migration-unlimited-extension.zip --allow-root --activate

# Display a final message to confirm script completion
echo "Plugins installed and activated successfully!"

# Call the original entrypoint script to start the web server
exec docker-entrypoint.sh apache2-foreground

